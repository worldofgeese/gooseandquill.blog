# Accessibility Tests

This directory contains accessibility tests for gooseandquill.blog.

## Overview

The tests verify that the website meets WCAG 2.1 accessibility guidelines, specifically ensuring that all page content is contained within proper landmark elements (`<main>`, `<header>`, `<footer>`, `<nav>`).

## Running the Tests

### Prerequisites

1. Node.js installed on your system
2. The live site must be deployed at https://gooseandquill.blog/

### Installation

```bash
cd tests
npm install
```

### Run Tests

```bash
# Run all tests headlessly
npm test

# Run tests with browser visible
npm run test:headed

# Run tests with Playwright UI
npm run test:ui
```

## Test Coverage

- `accessibility-landmarks.spec.js`: Tests that verify:
  - Homepage has all content contained within the `<main>` landmark
  - Articles are properly nested inside the `<main>` element
  - Header and footer landmarks are present
  - The site passes axe-core's "region" rule check
  - Individual post pages also use proper landmark structure

## Related

- Issue: Accessibility issue: All page content should be contained by landmarks on /
- Rule: https://dequeuniversity.com/rules/axe/4.11/region
