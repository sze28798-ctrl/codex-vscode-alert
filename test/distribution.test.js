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

test('README documents the three supported setup targets', () => {
  const readme = read('README.md');

  assert.match(readme, /Windows Local/);
  assert.match(readme, /macOS Local/);
  assert.match(readme, /VS Code Remote SSH: Windows Client \+ Linux Server/);
  assert.match(readme, /remote Linux trigger/i);
  assert.match(readme, /local Windows listener/i);
});

test('remote SSH Linux installer installs a trigger and protected AGENTS block', () => {
  const script = read('scripts/install-remote-ssh-linux.sh');

  assert.match(script, /notify-remote-ssh-linux\.sh/);
  assert.match(script, /BEGIN codex-vscode-alert/);
  assert.match(script, /Remote SSH Linux trigger/);
  assert.match(script, /done/);
  assert.match(script, /approval/);
});

test('remote SSH Linux trigger posts to the local bridge endpoint', () => {
  const script = read('scripts/notify-remote-ssh-linux.sh');

  assert.match(script, /CODEX_VSCODE_ALERT_URL/);
  assert.match(script, /127\.0\.0\.1:37991/);
  assert.match(script, /curl/);
  assert.match(script, /approval/);
});

test('Windows remote bridge includes a listener and reverse tunnel helper', () => {
  const listener = read('scripts/start-windows-listener.ps1');
  const tunnel = read('scripts/start-remote-ssh-tunnel.ps1');

  assert.match(listener, /HttpListener/);
  assert.match(listener, /flash-vscode\.ps1/);
  assert.match(listener, /37991/);
  assert.match(tunnel, /ssh/);
  assert.match(tunnel, /-R/);
  assert.match(tunnel, /37991/);
});
