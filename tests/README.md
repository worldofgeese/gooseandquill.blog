# Accessibility Tests

This directory contains automated accessibility tests for gooseandquill.blog.

## Test Files

- `accessibility.spec.js` - Automated Playwright tests that verify accessibility compliance
- `manual-test.html` - Manual test file to verify scrollable region keyboard access

## Running Tests

### Automated Tests

The automated tests run against the live site at https://gooseandquill.blog/

```bash
# Install dependencies
npm install

# Install Playwright browsers
npx playwright install chromium

# Run all accessibility tests
npm run test:a11y

# Run tests in UI mode (for debugging)
npx playwright test --ui
```

### Manual Testing

Open `manual-test.html` in a browser and:
1. Press Tab to navigate through the page
2. Verify that the second pre element (with tabindex="0") receives focus
3. While focused, use arrow keys to scroll horizontally

## What the Tests Check

1. **scrollable-region-focusable**: Ensures all scrollable regions have keyboard access
2. **Full accessibility scan**: Checks for any accessibility violations
3. **Specific pre.code check**: Verifies all `<pre class="code">` elements have `tabindex="0"`

## Fix Applied

The fix adds `tabindex="0"` to all `<pre class="code">` elements, making them:
- Focusable via keyboard (Tab key)
- Scrollable via keyboard (arrow keys when focused)
- WCAG 2.1 compliant

### Files Modified

1. `pollen-local/tags-html.rkt` - Added `tabindex="0"` to code blocks
2. `util/make-html-source.sh` - Added `tabindex="0"` to source listings

## CI/CD

Tests automatically run on:
- Push to main/master branches
- Pull requests to main/master branches
- Manual workflow dispatch

See `.github/workflows/accessibility-tests.yml` for configuration.
