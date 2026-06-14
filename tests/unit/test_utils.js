/**
 * Unit tests for agents/claude/scripts/lib/utils.js
 *
 * Run: node --test tests/unit/test_utils.js
 */

const { describe, it, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const path = require('path');
const os = require('os');

const {
  findFiles,
  readFile,
  writeFile,
  appendFile,
  replaceInFile,
  countInFile,
  grepFile,
  ensureDir,
  getDateString,
  getTimeString,
  getDateTimeString,
  getSessionIdShort,
  commandExists
} = require('../../agents/claude/scripts/lib/utils');

// ── Temp directory helpers ──

let tmpDir;

beforeEach(() => {
  tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'utils-test-'));
});

afterEach(() => {
  fs.rmSync(tmpDir, { recursive: true, force: true });
});

// ── Date/Time formatting ──

describe('getDateString', () => {
  it('returns YYYY-MM-DD format', () => {
    const result = getDateString();
    assert.match(result, /^\d{4}-\d{2}-\d{2}$/);
  });

  it('matches current date', () => {
    const now = new Date();
    const expected = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
    assert.equal(getDateString(), expected);
  });
});

describe('getTimeString', () => {
  it('returns HH:MM format', () => {
    const result = getTimeString();
    assert.match(result, /^\d{2}:\d{2}$/);
  });
});

describe('getDateTimeString', () => {
  it('returns YYYY-MM-DD HH:MM:SS format', () => {
    const result = getDateTimeString();
    assert.match(result, /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/);
  });
});

// ── getSessionIdShort ──

describe('getSessionIdShort', () => {
  it('returns last 8 chars of CLAUDE_SESSION_ID', () => {
    const original = process.env.CLAUDE_SESSION_ID;
    process.env.CLAUDE_SESSION_ID = 'abcdefgh12345678';
    try {
      assert.equal(getSessionIdShort(), '12345678');
    } finally {
      if (original !== undefined) process.env.CLAUDE_SESSION_ID = original;
      else delete process.env.CLAUDE_SESSION_ID;
    }
  });

  it('returns fallback when no session ID', () => {
    const original = process.env.CLAUDE_SESSION_ID;
    delete process.env.CLAUDE_SESSION_ID;
    try {
      const result = getSessionIdShort('fallback');
      // Will return project name or 'fallback'
      assert.ok(typeof result === 'string');
      assert.ok(result.length > 0);
    } finally {
      if (original !== undefined) process.env.CLAUDE_SESSION_ID = original;
    }
  });
});

// ── commandExists ──

describe('commandExists', () => {
  it('returns true for node', () => {
    assert.equal(commandExists('node'), true);
  });

  it('returns false for nonexistent command', () => {
    assert.equal(commandExists('definitely-not-a-real-command-xyz'), false);
  });

  it('rejects unsafe command names', () => {
    assert.equal(commandExists('foo; rm -rf /'), false);
    assert.equal(commandExists('$(whoami)'), false);
    assert.equal(commandExists('foo`bar`'), false);
  });

  it('allows valid command names with dots and dashes', () => {
    // These are valid command name patterns even if the command doesn't exist
    const result = commandExists('some-tool.v2');
    assert.equal(typeof result, 'boolean');
  });
});

// ── ensureDir ──

describe('ensureDir', () => {
  it('creates directory if it does not exist', () => {
    const dir = path.join(tmpDir, 'new', 'nested', 'dir');
    ensureDir(dir);
    assert.ok(fs.existsSync(dir));
  });

  it('returns the directory path', () => {
    const dir = path.join(tmpDir, 'return-test');
    assert.equal(ensureDir(dir), dir);
  });

  it('does not throw if directory already exists', () => {
    const dir = path.join(tmpDir, 'existing');
    fs.mkdirSync(dir);
    assert.doesNotThrow(() => ensureDir(dir));
  });
});

// ── readFile / writeFile / appendFile ──

describe('readFile', () => {
  it('reads file content', () => {
    const fp = path.join(tmpDir, 'read.txt');
    fs.writeFileSync(fp, 'hello world');
    assert.equal(readFile(fp), 'hello world');
  });

  it('returns null for nonexistent file', () => {
    assert.equal(readFile(path.join(tmpDir, 'nope.txt')), null);
  });
});

describe('writeFile', () => {
  it('creates file with content', () => {
    const fp = path.join(tmpDir, 'write.txt');
    writeFile(fp, 'test content');
    assert.equal(fs.readFileSync(fp, 'utf8'), 'test content');
  });

  it('creates parent directories', () => {
    const fp = path.join(tmpDir, 'deep', 'nested', 'file.txt');
    writeFile(fp, 'deep');
    assert.equal(fs.readFileSync(fp, 'utf8'), 'deep');
  });
});

describe('appendFile', () => {
  it('appends to existing file', () => {
    const fp = path.join(tmpDir, 'append.txt');
    fs.writeFileSync(fp, 'line1\n');
    appendFile(fp, 'line2\n');
    assert.equal(fs.readFileSync(fp, 'utf8'), 'line1\nline2\n');
  });

  it('creates file if it does not exist', () => {
    const fp = path.join(tmpDir, 'new-append.txt');
    appendFile(fp, 'first');
    assert.equal(fs.readFileSync(fp, 'utf8'), 'first');
  });
});

// ── findFiles ──

describe('findFiles', () => {
  it('finds files matching glob pattern', () => {
    fs.writeFileSync(path.join(tmpDir, 'a.txt'), '');
    fs.writeFileSync(path.join(tmpDir, 'b.txt'), '');
    fs.writeFileSync(path.join(tmpDir, 'c.md'), '');

    const results = findFiles(tmpDir, '*.txt');
    assert.equal(results.length, 2);
    assert.ok(results.every((r) => r.path.endsWith('.txt')));
  });

  it('returns empty for nonexistent directory', () => {
    assert.deepEqual(findFiles('/nonexistent/dir', '*.txt'), []);
  });

  it('returns empty for null/undefined inputs', () => {
    assert.deepEqual(findFiles(null, '*.txt'), []);
    assert.deepEqual(findFiles(tmpDir, null), []);
  });

  it('filters by maxAge', () => {
    const fp = path.join(tmpDir, 'recent.txt');
    fs.writeFileSync(fp, '');
    // File just created — should be within maxAge of 1 day
    const results = findFiles(tmpDir, '*.txt', { maxAge: 1 });
    assert.equal(results.length, 1);
  });

  it('sorts by modification time (newest first)', () => {
    const f1 = path.join(tmpDir, 'old.txt');
    const f2 = path.join(tmpDir, 'new.txt');
    fs.writeFileSync(f1, '');
    // Set f1 to older mtime
    const oldTime = new Date(Date.now() - 60000);
    fs.utimesSync(f1, oldTime, oldTime);
    fs.writeFileSync(f2, '');

    const results = findFiles(tmpDir, '*.txt');
    assert.equal(results.length, 2);
    assert.ok(results[0].mtime >= results[1].mtime);
  });

  it('handles ? wildcard in pattern', () => {
    fs.writeFileSync(path.join(tmpDir, 'a1.txt'), '');
    fs.writeFileSync(path.join(tmpDir, 'b2.txt'), '');
    fs.writeFileSync(path.join(tmpDir, 'abc.txt'), '');

    const results = findFiles(tmpDir, '??.txt');
    assert.equal(results.length, 2);
  });

  it('excludes files older than maxAge', () => {
    const fp = path.join(tmpDir, 'ancient.txt');
    fs.writeFileSync(fp, '');
    const veryOld = new Date(Date.now() - 30 * 86400000);
    fs.utimesSync(fp, veryOld, veryOld);

    const results = findFiles(tmpDir, '*.txt', { maxAge: 7 });
    assert.equal(results.length, 0);
  });
});

// ── replaceInFile ──

describe('replaceInFile', () => {
  it('replaces first occurrence of string', () => {
    const fp = path.join(tmpDir, 'replace.txt');
    fs.writeFileSync(fp, 'hello world hello');
    const ok = replaceInFile(fp, 'hello', 'goodbye');
    assert.equal(ok, true);
    assert.equal(fs.readFileSync(fp, 'utf8'), 'goodbye world hello');
  });

  it('replaces all occurrences with options.all', () => {
    const fp = path.join(tmpDir, 'replace-all.txt');
    fs.writeFileSync(fp, 'aaa bbb aaa');
    replaceInFile(fp, 'aaa', 'ccc', { all: true });
    assert.equal(fs.readFileSync(fp, 'utf8'), 'ccc bbb ccc');
  });

  it('supports regex patterns', () => {
    const fp = path.join(tmpDir, 'regex.txt');
    fs.writeFileSync(fp, 'date: 2024-01-01');
    replaceInFile(fp, /\d{4}-\d{2}-\d{2}/, '2025-12-31');
    assert.equal(fs.readFileSync(fp, 'utf8'), 'date: 2025-12-31');
  });

  it('returns false for nonexistent file', () => {
    assert.equal(replaceInFile(path.join(tmpDir, 'nope'), 'a', 'b'), false);
  });
});

// ── countInFile ──

describe('countInFile', () => {
  it('counts string occurrences', () => {
    const fp = path.join(tmpDir, 'count.txt');
    fs.writeFileSync(fp, 'foo bar foo baz foo');
    assert.equal(countInFile(fp, 'foo'), 3);
  });

  it('counts regex occurrences', () => {
    const fp = path.join(tmpDir, 'count-re.txt');
    fs.writeFileSync(fp, 'abc 123 def 456');
    assert.equal(countInFile(fp, /\d+/g), 2);
  });

  it('returns 0 for no matches', () => {
    const fp = path.join(tmpDir, 'count-zero.txt');
    fs.writeFileSync(fp, 'hello');
    assert.equal(countInFile(fp, 'xyz'), 0);
  });

  it('returns 0 for nonexistent file', () => {
    assert.equal(countInFile(path.join(tmpDir, 'nope'), 'a'), 0);
  });

  it('returns 0 for non-string non-regex pattern', () => {
    const fp = path.join(tmpDir, 'count-type.txt');
    fs.writeFileSync(fp, 'hello');
    assert.equal(countInFile(fp, 123), 0);
  });
});

// ── grepFile ──

describe('grepFile', () => {
  it('returns matching lines with line numbers', () => {
    const fp = path.join(tmpDir, 'grep.txt');
    fs.writeFileSync(fp, 'line one\nline two\nother three\nline four');
    const results = grepFile(fp, 'line');
    assert.equal(results.length, 3);
    assert.equal(results[0].lineNumber, 1);
    assert.equal(results[0].content, 'line one');
    assert.equal(results[2].lineNumber, 4);
  });

  it('supports regex patterns', () => {
    const fp = path.join(tmpDir, 'grep-re.txt');
    fs.writeFileSync(fp, 'error: bad\nwarning: ok\nerror: worse');
    const results = grepFile(fp, /^error/);
    assert.equal(results.length, 2);
  });

  it('returns empty for no matches', () => {
    const fp = path.join(tmpDir, 'grep-none.txt');
    fs.writeFileSync(fp, 'nothing here');
    assert.deepEqual(grepFile(fp, 'xyz'), []);
  });

  it('returns empty for nonexistent file', () => {
    assert.deepEqual(grepFile(path.join(tmpDir, 'nope'), 'x'), []);
  });

  it('handles global regex without stateful test issues', () => {
    const fp = path.join(tmpDir, 'grep-global.txt');
    fs.writeFileSync(fp, 'match\nmatch\nmatch');
    // A global regex used with .test() in a loop is stateful — grepFile
    // must handle this correctly
    const results = grepFile(fp, /match/g);
    assert.equal(results.length, 3);
  });
});
