const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const root = path.join(__dirname, '..');

function read(relativePath) {
  return fs.readFileSync(path.join(root, relativePath), 'utf8');
}

test('installer copies scripts and skill into Codex home', () => {
  const script = read('scripts/install.ps1');

  assert.match(script, /codex-vscode-alert/);
  assert.match(script, /scripts/);
  assert.match(script, /skills[\\/]codex-vscode-alert/);
  assert.match(script, /AGENTS\.md/);
});

test('installer manages a protected AGENTS block', () => {
  const script = read('scripts/install.ps1');

  assert.match(script, /BEGIN codex-vscode-alert/);
  assert.match(script, /END codex-vscode-alert/);
  assert.match(script, /-Reason done/);
  assert.match(script, /-Reason approval/);
});

test('notify script directly calls the flash helper', () => {
  const script = read('scripts/notify-codex-done.ps1');

  assert.match(script, /flash-vscode\.ps1/);
  assert.doesNotMatch(script, /notify\.json/);
});

test('macOS notify script sends a system notification directly', () => {
  const script = read('scripts/notify-codex-done.sh');

  assert.match(script, /osascript/);
  assert.match(script, /display notification/);
  assert.doesNotMatch(script, /notify\.json/);
});

test('skill is scoped to installation and troubleshooting', () => {
  const skill = read('skills/codex-vscode-alert/SKILL.md');

  assert.match(skill, /^name: codex-vscode-alert/m);
  assert.match(skill, /installing, configuring, or troubleshooting/i);
  assert.match(skill, /AGENTS\.md/);
  assert.match(skill, /notify-codex-done\.ps1/);
});
