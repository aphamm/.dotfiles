/**
 * Unit tests for agents/claude/scripts/lib/session-aliases.js
 *
 * Run: node --test tests/unit/test_session_aliases.js
 *
 * Sets HOME to a temp directory so tests don't touch real ~/.claude/
 */

const { describe, it, beforeEach, afterEach } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const path = require('path');
const os = require('os');

let tmpDir;
let origHome;

beforeEach(() => {
  tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'aliases-test-'));
  origHome = process.env.HOME;
  process.env.HOME = tmpDir;

  // Clear the module cache so it re-reads HOME
  const modPaths = Object.keys(require.cache).filter(
    (k) => k.includes('session-aliases') || k.includes('lib/utils')
  );
  for (const p of modPaths) delete require.cache[p];
});

afterEach(() => {
  process.env.HOME = origHome;
  fs.rmSync(tmpDir, { recursive: true, force: true });
});

function loadModule() {
  return require('../../agents/claude/scripts/lib/session-aliases');
}

// ── setAlias ──

describe('setAlias', () => {
  it('creates a new alias', () => {
    const { setAlias, resolveAlias } = loadModule();
    const result = setAlias('mytest', '/tmp/session-1', 'Test session');
    assert.equal(result.success, true);
    assert.equal(result.isNew, true);
    assert.equal(result.alias, 'mytest');

    const resolved = resolveAlias('mytest');
    assert.equal(resolved.sessionPath, '/tmp/session-1');
    assert.equal(resolved.title, 'Test session');
  });

  it('updates an existing alias', () => {
    const { setAlias } = loadModule();
    setAlias('upd', '/tmp/old');
    const result = setAlias('upd', '/tmp/new');
    assert.equal(result.success, true);
    assert.equal(result.isNew, false);
  });

  it('rejects empty alias name', () => {
    const { setAlias } = loadModule();
    const result = setAlias('', '/tmp/x');
    assert.equal(result.success, false);
    assert.ok(result.error.includes('empty'));
  });

  it('rejects invalid characters', () => {
    const { setAlias } = loadModule();
    const result = setAlias('bad name!', '/tmp/x');
    assert.equal(result.success, false);
    assert.ok(result.error.includes('letters'));
  });

  it('rejects reserved names', () => {
    const { setAlias } = loadModule();
    for (const reserved of ['list', 'help', 'remove', 'delete', 'create', 'set']) {
      const result = setAlias(reserved, '/tmp/x');
      assert.equal(result.success, false, `Should reject reserved name: ${reserved}`);
      assert.ok(result.error.includes('reserved'));
    }
  });

  it('rejects names over 128 characters', () => {
    const { setAlias } = loadModule();
    const result = setAlias('a'.repeat(129), '/tmp/x');
    assert.equal(result.success, false);
    assert.ok(result.error.includes('128'));
  });

  it('rejects empty session path', () => {
    const { setAlias } = loadModule();
    const result = setAlias('valid', '');
    assert.equal(result.success, false);
    assert.ok(result.error.includes('empty'));
  });

  it('allows dashes and underscores in names', () => {
    const { setAlias } = loadModule();
    const result = setAlias('my-test_alias', '/tmp/x');
    assert.equal(result.success, true);
  });
});

// ── resolveAlias ──

describe('resolveAlias', () => {
  it('returns null for nonexistent alias', () => {
    const { resolveAlias } = loadModule();
    assert.equal(resolveAlias('nope'), null);
  });

  it('returns null for null input', () => {
    const { resolveAlias } = loadModule();
    assert.equal(resolveAlias(null), null);
  });

  it('rejects invalid characters', () => {
    const { resolveAlias } = loadModule();
    assert.equal(resolveAlias('bad name!'), null);
  });

  it('resolves existing alias', () => {
    const { setAlias, resolveAlias } = loadModule();
    setAlias('findme', '/tmp/found');
    const result = resolveAlias('findme');
    assert.ok(result);
    assert.equal(result.sessionPath, '/tmp/found');
  });
});

// ── listAliases ──

describe('listAliases', () => {
  it('returns empty array when no aliases', () => {
    const { listAliases } = loadModule();
    assert.deepEqual(listAliases(), []);
  });

  it('returns all aliases', () => {
    const { setAlias, listAliases } = loadModule();
    setAlias('alpha', '/tmp/1');
    setAlias('beta', '/tmp/2');
    const list = listAliases();
    assert.equal(list.length, 2);
    const names = new Set(list.map((a) => a.name));
    assert.ok(names.has('alpha'));
    assert.ok(names.has('beta'));
  });

  it('filters by search term', () => {
    const { setAlias, listAliases } = loadModule();
    setAlias('frontend-v1', '/tmp/1');
    setAlias('backend-v1', '/tmp/2');
    setAlias('frontend-v2', '/tmp/3');
    const list = listAliases({ search: 'frontend' });
    assert.equal(list.length, 2);
  });

  it('searches titles too', () => {
    const { setAlias, listAliases } = loadModule();
    setAlias('proj-a', '/tmp/1', 'React migration');
    setAlias('proj-b', '/tmp/2', 'API rewrite');
    const list = listAliases({ search: 'react' });
    assert.equal(list.length, 1);
    assert.equal(list[0].name, 'proj-a');
  });

  it('respects limit', () => {
    const { setAlias, listAliases } = loadModule();
    for (let i = 0; i < 10; i++) {
      setAlias(`alias${i}`, `/tmp/${i}`);
    }
    const list = listAliases({ limit: 3 });
    assert.equal(list.length, 3);
  });
});

// ── deleteAlias ──

describe('deleteAlias', () => {
  it('deletes existing alias', () => {
    const { setAlias, deleteAlias, resolveAlias } = loadModule();
    setAlias('todelete', '/tmp/del');
    const result = deleteAlias('todelete');
    assert.equal(result.success, true);
    assert.equal(resolveAlias('todelete'), null);
  });

  it('returns error for nonexistent alias', () => {
    const { deleteAlias } = loadModule();
    const result = deleteAlias('nope');
    assert.equal(result.success, false);
    assert.ok(result.error.includes('not found'));
  });
});

// ── renameAlias ──

describe('renameAlias', () => {
  it('renames an alias', () => {
    const { setAlias, renameAlias, resolveAlias } = loadModule();
    setAlias('oldname', '/tmp/x');
    const result = renameAlias('oldname', 'newname');
    assert.equal(result.success, true);
    assert.equal(resolveAlias('oldname'), null);
    assert.ok(resolveAlias('newname'));
  });

  it('returns error for nonexistent source', () => {
    const { renameAlias } = loadModule();
    const result = renameAlias('nope', 'newname');
    assert.equal(result.success, false);
  });

  it('returns error if target already exists', () => {
    const { setAlias, renameAlias } = loadModule();
    setAlias('src', '/tmp/1');
    setAlias('dst', '/tmp/2');
    const result = renameAlias('src', 'dst');
    assert.equal(result.success, false);
    assert.ok(result.error.includes('already exists'));
  });

  it('rejects reserved new names', () => {
    const { setAlias, renameAlias } = loadModule();
    setAlias('valid', '/tmp/x');
    const result = renameAlias('valid', 'list');
    assert.equal(result.success, false);
    assert.ok(result.error.includes('reserved'));
  });

  it('rejects invalid new names', () => {
    const { setAlias, renameAlias } = loadModule();
    setAlias('valid', '/tmp/x');
    const result = renameAlias('valid', 'bad name!');
    assert.equal(result.success, false);
  });
});

// ── updateAliasTitle ──

describe('updateAliasTitle', () => {
  it('updates title', () => {
    const { setAlias, updateAliasTitle, resolveAlias } = loadModule();
    setAlias('titled', '/tmp/x', 'Old title');
    const result = updateAliasTitle('titled', 'New title');
    assert.equal(result.success, true);
    assert.equal(resolveAlias('titled').title, 'New title');
  });

  it('clears title with null', () => {
    const { setAlias, updateAliasTitle, resolveAlias } = loadModule();
    setAlias('titled', '/tmp/x', 'Has title');
    updateAliasTitle('titled', null);
    assert.equal(resolveAlias('titled').title, null);
  });

  it('returns error for nonexistent alias', () => {
    const { updateAliasTitle } = loadModule();
    const result = updateAliasTitle('nope', 'title');
    assert.equal(result.success, false);
  });
});

// ── cleanupAliases ──

describe('cleanupAliases', () => {
  it('removes aliases for non-existent sessions', () => {
    const { setAlias, cleanupAliases, listAliases } = loadModule();
    setAlias('alive', '/tmp/exists');
    setAlias('dead', '/tmp/gone');

    const result = cleanupAliases((p) => p === '/tmp/exists');
    assert.equal(result.success, true);
    assert.equal(result.removed, 1);

    const list = listAliases();
    assert.equal(list.length, 1);
    assert.equal(list[0].name, 'alive');
  });

  it('returns error if sessionExists is not a function', () => {
    const { cleanupAliases } = loadModule();
    const result = cleanupAliases('not a function');
    assert.ok(result.error);
  });

  it('does nothing when all sessions exist', () => {
    const { setAlias, cleanupAliases } = loadModule();
    setAlias('ok', '/tmp/here');
    const result = cleanupAliases(() => true);
    assert.equal(result.removed, 0);
  });
});

// ── getAliasesForSession ──

describe('getAliasesForSession', () => {
  it('finds all aliases pointing to a session', () => {
    const { setAlias, getAliasesForSession } = loadModule();
    setAlias('a1', '/tmp/session-1');
    setAlias('a2', '/tmp/session-1');
    setAlias('other', '/tmp/session-2');

    const aliases = getAliasesForSession('/tmp/session-1');
    assert.equal(aliases.length, 2);
    const names = aliases.map((a) => a.name).sort();
    assert.deepEqual(names, ['a1', 'a2']);
  });

  it('returns empty for unknown session', () => {
    const { getAliasesForSession } = loadModule();
    assert.deepEqual(getAliasesForSession('/tmp/nope'), []);
  });
});

// ── resolveSessionAlias ──

describe('resolveSessionAlias', () => {
  it('resolves alias to session path', () => {
    const { setAlias, resolveSessionAlias } = loadModule();
    setAlias('quick', '/tmp/s1');
    assert.equal(resolveSessionAlias('quick'), '/tmp/s1');
  });

  it('returns input as-is when not an alias', () => {
    const { resolveSessionAlias } = loadModule();
    assert.equal(resolveSessionAlias('/tmp/direct'), '/tmp/direct');
  });
});
