#!/usr/bin/env bash
set -e

echo "📦 Initializing log-it package…"

# 1. package.json
cat > package.json <<'EOF'
{
  "name": "log-it",
  "version": "0.1.0",
  "description": "A tool to log it all in a JavaScript file.",
  "main": "lib/index.js",
  "bin": {
    "log-it": "bin/log-it.js"
  },
  "keywords": ["log", "trace", "cli"],
  "author": "",
  "license": "MIT",
  "dependencies": {}
}
EOF

# 2. CLI entrypoint
mkdir -p bin
cat > bin/log-it.js <<'EOF'
#!/usr/bin/env node

const path    = require('path');
const fs      = require('fs');
const tracify = require('../lib/index');

const [,, inputFile] = process.argv;
if (!inputFile) {
  console.error('Usage: log-it <file.js>');
  process.exit(1);
}

const output = tracify(inputFile);
process.stdout.write(output);
EOF
chmod +x bin/log-it.js

# 3. Core tracify logic
mkdir -p lib
cat > lib/index.js <<'EOF'
const fs   = require('fs');
const path = require('path');

module.exports = function tracify(file) {
  const filePath = path.resolve(file);
  const content  = fs.readFileSync(filePath, 'utf8');
  const lines    = content.split('\\n');
  const result   = [];

  lines.forEach((line, idx) => {
    const parts = line.split(';');
    parts.forEach((part, i) => {
      // Skip empty trailing parts
      if (part === '' && i === parts.length - 1) return;

      // Reconstruct the segment (with semicolon if it was there)
      const segment = part + (i < parts.length - 1 ? ';' : '');
      result.push(segment);

      // After each real semicolon, insert a log with absolute path and line
      if (i < parts.length - 1) {
        const indent = (line.match(/^(\s*)/) || [])[1] || '';
        result.push(\`\${indent}console.log(\`[\${filePath}:\${idx + 1}]\`);\`);
      }
    });
  });

  return result.join('\\n');
};
EOF

# 4. README.md
cat > README.md <<'EOF'
# log-it

A tool to log it all in a JavaScript file.

## Installation

\`\`\`bash
npm install -g log-it
\`\`\`

## Usage

\`\`\`bash
log-it yourFile.js > tracedFile.js
\`\`\`
EOF

# 5. .gitignore
cat > .gitignore <<'EOF'
node_modules/
npm-debug.log
EOF

echo ""
echo "✅ Scaffold complete! Your directory now contains:"
tree -a -L 2
echo ""
echo "Next steps:"
echo " 1. Run \`npm link\` (or \`npm install -g .\`) to install globally."
echo " 2. Use \`log-it path/to/your.js > out.js\` to generate traced output."