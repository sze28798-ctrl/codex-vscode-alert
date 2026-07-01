const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

test('Windows flash helper enumerates top-level windows', () => {
  const script = fs.readFileSync(
    path.join(__dirname, '..', 'scripts', 'flash-vscode.ps1'),
    'utf8',
  );

  assert.match(script, /EnumWindows/);
  assert.match(script, /GetWindowThreadProcessId/);
  assert.match(script, /IsWindowVisible/);
});
