# Accessibility Tests

This directory contains automated accessibility tests for the Goose and Quill blog.

## Running the Tests

To run the accessibility tests:

```bash
npm test
```

Or specifically:

```bash
npm run test:a11y
```

## What's Tested

The tests verify that:

1. **Main Landmark**: The document contains exactly one `<main>` landmark element as required by WCAG 2.1 guidelines (rule: `landmark-one-main`)
2. Other axe-core accessibility rules are also checked

## Test Files

- `test-main-landmark.js`: The main test script that uses Playwright and axe-core
- `test-index-structure.html`: A test HTML file that represents the structure of the homepage after the Pollen templates are rendered

## Dependencies

The tests require:
- Node.js
- Playwright (for browser automation)
- axe-core (for accessibility testing)

These are listed as devDependencies in `package.json` and will be installed when you run `npm install`.

## Adding New Tests

To add new accessibility tests:

1. Create a new test file in this directory
2. Use the existing test structure as a template
3. Update the npm scripts in `package.json` to include your new test
