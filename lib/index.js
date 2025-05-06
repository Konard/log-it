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
