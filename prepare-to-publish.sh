#!/usr/bin/env bash
set -euo pipefail

# -----------------------
# publish.sh
# -----------------------
# Usage: ./publish.sh [patch|minor|major]
# Default bump is patch.
# Must be run from the root of your log-it repo, 
# with a clean working tree and npm/git already configured.

BUMP_TYPE="${1:-patch}"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "🔧  Ensuring package.json has repo/bugs/homepage fields…"
node <<'JS'
const fs = require('fs');
const pkgPath = './package.json';
let pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));

// modify or set these fields as needed:
pkg.repository = { 
  type: "git", 
  url: "git+https://github.com/Konard/log-it.git" 
};
pkg.bugs       = { url: "https://github.com/Konard/log-it/issues" };
pkg.homepage   = "https://github.com/Konard/log-it#readme";

fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2) + '\n');
JS