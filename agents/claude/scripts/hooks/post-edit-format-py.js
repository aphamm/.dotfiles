#!/usr/bin/env node
/**
 * PostToolUse Hook: Auto-format Python files with Ruff after edits
 *
 * Runs after Edit tool use. If the edited file is a .py file,
 * formats it with ruff. Fails silently if ruff isn't installed.
 */

const { execFileSync } = require('child_process');

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
        execFileSync('ruff', ['format', filePath], {
          stdio: 'pipe',
          timeout: 15000
        });
      } catch {
        // ruff not installed or failed — non-blocking
      }
    }
  } catch {
    // Invalid input — pass through
  }

  process.stdout.write(data);
  process.exit(0);
});
