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
