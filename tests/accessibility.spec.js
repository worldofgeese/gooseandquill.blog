const { test, expect } = require('@playwright/test');
const AxeBuilder = require('@axe-core/playwright').default;

test.describe('Accessibility Tests', () => {
  test('scrollable regions should have keyboard access', async ({ page }) => {
    // Navigate to the home page
    await page.goto('https://gooseandquill.blog/');
    
    // Run axe accessibility scan specifically for scrollable-region-focusable rule
    const accessibilityScanResults = await new AxeBuilder({ page })
      .withRules(['scrollable-region-focusable'])
      .analyze();
    
    // Check that there are no violations for scrollable-region-focusable
    expect(accessibilityScanResults.violations).toHaveLength(0);
  });

  test('no accessibility violations on home page', async ({ page }) => {
    // Navigate to the home page
    await page.goto('https://gooseandquill.blog/');
    
    // Run full axe accessibility scan
    const accessibilityScanResults = await new AxeBuilder({ page })
      .analyze();
    
    // Check that there are no violations
    expect(accessibilityScanResults.violations).toHaveLength(0);
  });

  test('pre elements with code class should be keyboard accessible', async ({ page }) => {
    // Navigate to the home page
    await page.goto('https://gooseandquill.blog/');
    
    // Find all pre elements with class "code"
    const preElements = await page.locator('pre.code').all();
    
    // Ensure at least one pre.code element exists
    expect(preElements.length).toBeGreaterThan(0);
    
    for (const preElement of preElements) {
      // Check if the element has tabindex="0" for keyboard accessibility
      const tabindex = await preElement.getAttribute('tabindex');
      
      expect(tabindex).toBe('0');
    }
  });
});
