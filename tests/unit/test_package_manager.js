/**
 * Unit tests for agents/claude/scripts/lib/package-manager.js
 *
 * Run: node --test tests/unit/test_package_manager.js
 */

const { describe, it, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const path = require('path');
const os = require('os');

const {
  PACKAGE_MANAGERS,
  DETECTION_PRIORITY,
  detectFromLockFile,
  detectFromPackageJson,
  getPackageManager,
  getRunCommand,
  getExecCommand,
  getCommandPattern
} = require('../../agents/claude/scripts/lib/package-manager');

let tmpDir;

beforeEach(() => {
  tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'pm-test-'));
});

afterEach(() => {
  fs.rmSync(tmpDir, { recursive: true, force: true });
});

// ── Constants ──

describe('PACKAGE_MANAGERS', () => {
  it('has all four package managers', () => {
    assert.deepEqual(
      new Set(Object.keys(PACKAGE_MANAGERS)),
      new Set(['npm', 'pnpm', 'yarn', 'bun'])
    );
  });

  it('each PM has required fields', () => {
    const requiredFields = [
      'name',
      'lockFile',
      'installCmd',
      'runCmd',
      'execCmd',
      'testCmd',
      'buildCmd',
      'devCmd'
    ];
    for (const [pmName, config] of Object.entries(PACKAGE_MANAGERS)) {
      for (const field of requiredFields) {
        assert.ok(config[field], `${pmName} missing field: ${field}`);
      }
    }
  });
});

describe('DETECTION_PRIORITY', () => {
  it('includes all four PMs', () => {
    assert.equal(DETECTION_PRIORITY.length, 4);
    assert.ok(DETECTION_PRIORITY.includes('pnpm'));
    assert.ok(DETECTION_PRIORITY.includes('npm'));
  });

  it('prefers pnpm over npm', () => {
    assert.ok(DETECTION_PRIORITY.indexOf('pnpm') < DETECTION_PRIORITY.indexOf('npm'));
  });
});

// ── detectFromLockFile ──

describe('detectFromLockFile', () => {
  it('detects npm from package-lock.json', () => {
    fs.writeFileSync(path.join(tmpDir, 'package-lock.json'), '{}');
    assert.equal(detectFromLockFile(tmpDir), 'npm');
  });

  it('detects pnpm from pnpm-lock.yaml', () => {
    fs.writeFileSync(path.join(tmpDir, 'pnpm-lock.yaml'), '');
    assert.equal(detectFromLockFile(tmpDir), 'pnpm');
  });

  it('detects yarn from yarn.lock', () => {
    fs.writeFileSync(path.join(tmpDir, 'yarn.lock'), '');
    assert.equal(detectFromLockFile(tmpDir), 'yarn');
  });

  it('detects bun from bun.lockb', () => {
    fs.writeFileSync(path.join(tmpDir, 'bun.lockb'), '');
    assert.equal(detectFromLockFile(tmpDir), 'bun');
  });

  it('returns null when no lock file', () => {
    assert.equal(detectFromLockFile(tmpDir), null);
  });

  it('respects priority when multiple lock files exist', () => {
    fs.writeFileSync(path.join(tmpDir, 'package-lock.json'), '{}');
    fs.writeFileSync(path.join(tmpDir, 'pnpm-lock.yaml'), '');
    // pnpm has higher priority than npm
    assert.equal(detectFromLockFile(tmpDir), 'pnpm');
  });
});

// ── detectFromPackageJson ──

describe('detectFromPackageJson', () => {
  it('detects from packageManager field', () => {
    fs.writeFileSync(
      path.join(tmpDir, 'package.json'),
      JSON.stringify({ packageManager: 'pnpm@8.6.0' })
    );
    assert.equal(detectFromPackageJson(tmpDir), 'pnpm');
  });

  it('handles bare name without version', () => {
    fs.writeFileSync(path.join(tmpDir, 'package.json'), JSON.stringify({ packageManager: 'yarn' }));
    assert.equal(detectFromPackageJson(tmpDir), 'yarn');
  });

  it('returns null when no packageManager field', () => {
    fs.writeFileSync(path.join(tmpDir, 'package.json'), JSON.stringify({ name: 'test' }));
    assert.equal(detectFromPackageJson(tmpDir), null);
  });

  it('returns null when no package.json', () => {
    assert.equal(detectFromPackageJson(tmpDir), null);
  });

  it('returns null for unknown PM name', () => {
    fs.writeFileSync(
      path.join(tmpDir, 'package.json'),
      JSON.stringify({ packageManager: 'deno@1.0' })
    );
    assert.equal(detectFromPackageJson(tmpDir), null);
  });

  it('returns null for invalid JSON', () => {
    fs.writeFileSync(path.join(tmpDir, 'package.json'), 'not json');
    assert.equal(detectFromPackageJson(tmpDir), null);
  });
});

// ── getPackageManager ──

describe('getPackageManager', () => {
  it('detects from environment variable', () => {
    const orig = process.env.CLAUDE_PACKAGE_MANAGER;
    process.env.CLAUDE_PACKAGE_MANAGER = 'bun';
    try {
      const pm = getPackageManager({ projectDir: tmpDir });
      assert.equal(pm.name, 'bun');
      assert.equal(pm.source, 'environment');
    } finally {
      if (orig !== undefined) process.env.CLAUDE_PACKAGE_MANAGER = orig;
      else delete process.env.CLAUDE_PACKAGE_MANAGER;
    }
  });

  it('detects from lock file', () => {
    const orig = process.env.CLAUDE_PACKAGE_MANAGER;
    delete process.env.CLAUDE_PACKAGE_MANAGER;
    try {
      fs.writeFileSync(path.join(tmpDir, 'yarn.lock'), '');
      const pm = getPackageManager({ projectDir: tmpDir });
      assert.equal(pm.name, 'yarn');
      assert.equal(pm.source, 'lock-file');
    } finally {
      if (orig !== undefined) process.env.CLAUDE_PACKAGE_MANAGER = orig;
    }
  });

  it('detects from package.json', () => {
    const orig = process.env.CLAUDE_PACKAGE_MANAGER;
    delete process.env.CLAUDE_PACKAGE_MANAGER;
    try {
      fs.writeFileSync(
        path.join(tmpDir, 'package.json'),
        JSON.stringify({ packageManager: 'pnpm@9' })
      );
      const pm = getPackageManager({ projectDir: tmpDir });
      assert.equal(pm.name, 'pnpm');
      assert.equal(pm.source, 'package.json');
    } finally {
      if (orig !== undefined) process.env.CLAUDE_PACKAGE_MANAGER = orig;
    }
  });

  it('defaults to npm when nothing detected', () => {
    const orig = process.env.CLAUDE_PACKAGE_MANAGER;
    delete process.env.CLAUDE_PACKAGE_MANAGER;
    try {
      const pm = getPackageManager({ projectDir: tmpDir });
      assert.equal(pm.name, 'npm');
      assert.equal(pm.source, 'default');
    } finally {
      if (orig !== undefined) process.env.CLAUDE_PACKAGE_MANAGER = orig;
    }
  });

  it('config object matches the PM definition', () => {
    const orig = process.env.CLAUDE_PACKAGE_MANAGER;
    process.env.CLAUDE_PACKAGE_MANAGER = 'pnpm';
    try {
      const pm = getPackageManager({ projectDir: tmpDir });
      assert.deepEqual(pm.config, PACKAGE_MANAGERS.pnpm);
    } finally {
      if (orig !== undefined) process.env.CLAUDE_PACKAGE_MANAGER = orig;
      else delete process.env.CLAUDE_PACKAGE_MANAGER;
    }
  });
});

// ── getRunCommand ──

describe('getRunCommand', () => {
  it('returns install command', () => {
    const orig = process.env.CLAUDE_PACKAGE_MANAGER;
    process.env.CLAUDE_PACKAGE_MANAGER = 'pnpm';
    try {
      assert.equal(getRunCommand('install', { projectDir: tmpDir }), 'pnpm install');
    } finally {
      if (orig !== undefined) process.env.CLAUDE_PACKAGE_MANAGER = orig;
      else delete process.env.CLAUDE_PACKAGE_MANAGER;
    }
  });

  it('returns test command', () => {
    const orig = process.env.CLAUDE_PACKAGE_MANAGER;
    process.env.CLAUDE_PACKAGE_MANAGER = 'npm';
    try {
      assert.equal(getRunCommand('test', { projectDir: tmpDir }), 'npm test');
    } finally {
      if (orig !== undefined) process.env.CLAUDE_PACKAGE_MANAGER = orig;
      else delete process.env.CLAUDE_PACKAGE_MANAGER;
    }
  });

  it('returns generic run command for custom scripts', () => {
    const orig = process.env.CLAUDE_PACKAGE_MANAGER;
    process.env.CLAUDE_PACKAGE_MANAGER = 'npm';
    try {
      assert.equal(getRunCommand('lint', { projectDir: tmpDir }), 'npm run lint');
    } finally {
      if (orig !== undefined) process.env.CLAUDE_PACKAGE_MANAGER = orig;
      else delete process.env.CLAUDE_PACKAGE_MANAGER;
    }
  });

  it('throws on empty script name', () => {
    assert.throws(() => getRunCommand(''), { message: /non-empty string/ });
  });

  it('throws on unsafe script name', () => {
    assert.throws(() => getRunCommand('test; rm -rf /'), { message: /unsafe/ });
  });
});

// ── getExecCommand ──

describe('getExecCommand', () => {
  it('returns exec command for binary', () => {
    const orig = process.env.CLAUDE_PACKAGE_MANAGER;
    process.env.CLAUDE_PACKAGE_MANAGER = 'npm';
    try {
      assert.equal(getExecCommand('biome', '', { projectDir: tmpDir }), 'npx biome');
    } finally {
      if (orig !== undefined) process.env.CLAUDE_PACKAGE_MANAGER = orig;
      else delete process.env.CLAUDE_PACKAGE_MANAGER;
    }
  });

  it('appends args', () => {
    const orig = process.env.CLAUDE_PACKAGE_MANAGER;
    process.env.CLAUDE_PACKAGE_MANAGER = 'pnpm';
    try {
      assert.equal(
        getExecCommand('eslint', '--fix src/', { projectDir: tmpDir }),
        'pnpm dlx eslint --fix src/'
      );
    } finally {
      if (orig !== undefined) process.env.CLAUDE_PACKAGE_MANAGER = orig;
      else delete process.env.CLAUDE_PACKAGE_MANAGER;
    }
  });

  it('throws on unsafe binary name', () => {
    assert.throws(() => getExecCommand('$(whoami)'), { message: /unsafe/ });
  });

  it('throws on unsafe args', () => {
    assert.throws(() => getExecCommand('biome', '--write; rm -rf /'), {
      message: /unsafe/
    });
  });

  it('throws on empty binary', () => {
    assert.throws(() => getExecCommand(''), { message: /non-empty string/ });
  });
});

// ── getCommandPattern ──

describe('getCommandPattern', () => {
  it('generates pattern for dev', () => {
    const pattern = getCommandPattern('dev');
    const regex = new RegExp(pattern);
    assert.ok(regex.test('npm run dev'));
    assert.ok(regex.test('pnpm dev'));
    assert.ok(regex.test('yarn dev'));
    assert.ok(regex.test('bun run dev'));
  });

  it('generates pattern for install', () => {
    const pattern = getCommandPattern('install');
    const regex = new RegExp(pattern);
    assert.ok(regex.test('npm install'));
    assert.ok(regex.test('pnpm install'));
    assert.ok(regex.test('yarn'));
    assert.ok(regex.test('bun install'));
  });

  it('generates pattern for test', () => {
    const pattern = getCommandPattern('test');
    const regex = new RegExp(pattern);
    assert.ok(regex.test('npm test'));
    assert.ok(regex.test('pnpm test'));
  });

  it('generates pattern for build', () => {
    const pattern = getCommandPattern('build');
    const regex = new RegExp(pattern);
    assert.ok(regex.test('npm run build'));
    assert.ok(regex.test('pnpm build'));
    assert.ok(regex.test('yarn build'));
  });

  it('generates pattern for custom scripts', () => {
    const pattern = getCommandPattern('lint');
    const regex = new RegExp(pattern);
    assert.ok(regex.test('npm run lint'));
    assert.ok(regex.test('pnpm lint'));
    assert.ok(regex.test('yarn lint'));
  });

  it('escapes regex metacharacters in action', () => {
    // Should not throw even with regex special chars
    assert.doesNotThrow(() => getCommandPattern('lint.fix'));
    const pattern = getCommandPattern('lint.fix');
    const regex = new RegExp(pattern);
    // The . should be escaped (match literal dot, not any char)
    assert.ok(regex.test('npm run lint.fix'));
  });
});
