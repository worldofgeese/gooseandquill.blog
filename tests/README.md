# Accessibility Tests

This directory contains Playwright tests for verifying WCAG 2.1 accessibility compliance.

## Setup

1. Install dependencies:
   ```bash
   cd tests
   npm install
   npx playwright install
   ```

2. Start the local server (from the project root):
   ```bash
   raco pollen start
   ```

3. Run the tests (from the tests directory):
   ```bash
   npm test
   ```

## Tests

### accessibility.spec.js

Tests the color contrast ratio of the home link element to ensure it meets WCAG 2.1 AA standards (4.5:1 contrast ratio).

This test was added to prevent regression of the fix for the accessibility issue where the home link had insufficient color contrast (3.86:1 between #8B7355 foreground and #F4EDE5 background).

The fix changed the home link color to #7d674c, which provides a 4.62:1 contrast ratio.
