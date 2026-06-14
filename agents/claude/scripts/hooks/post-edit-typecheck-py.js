#!/usr/bin/env node
/**
 * PostToolUse Hook: Type-check Python files with basedpyright after edits
 *
 * Runs after Edit tool use on .py files. Invokes basedpyright with JSON
 * output and reports up to 10 errors for the edited file.
 * Fails silently if basedpyright isn't installed.
 */

const { execFileSync } = require('child_process');
const path = require('path');

const MAX_STDIN = 1024 * 1024;
let data = '';
process.stdin.setEncoding('utf8');

process.stdin.on('data', (chunk) => {
  if (data.length < MAX_STDIN) {
    data += chunk;
  }
});

process.stdin.on('end', () => {
  try {
    const input = JSON.parse(data);
    const filePath = input.tool_input?.file_path;

    if (filePath && /\.py$/.test(filePath)) {
      try {
        execFileSync('basedpyright', ['--outputjson', filePath], {
          stdio: ['pipe', 'pipe', 'pipe'],
          timeout: 30000,
          encoding: 'utf8'
        });
      } catch (err) {
        const out = err.stdout || '';
        try {
          const result = JSON.parse(out);
          const errors = (result.generalDiagnostics || [])
            .filter((d) => d.severity === 'error')
            .slice(0, 10);

          if (errors.length > 0) {
            console.error('[Hook] basedpyright errors in ' + path.basename(filePath) + ':');
            errors.forEach((e) => {
              console.error('  ' + filePath + ':' + e.range?.start?.line + ': ' + e.message);
            });
          }
        } catch {
          // JSON parse failed — non-blocking
        }
      }
    }
  } catch {
    // Invalid input — pass through
  }

  process.stdout.write(data);
  process.exit(0);
});
