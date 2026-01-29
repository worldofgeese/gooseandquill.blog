/**
 * Accessibility test to verify all page content is contained within landmarks
 * 
 * This test validates that the fix for the accessibility issue where article 
 * content was not contained by landmarks is working correctly.
 * 
 * To run this test:
 * 1. npm install @playwright/test axe-playwright
 * 2. npx playwright test tests/accessibility-landmarks.spec.js
 */

const { test, expect } = require('@playwright/test');
const { injectAxe, checkA11y } = require('axe-playwright');

test.describe('Accessibility - Landmarks', () => {
  test('homepage should have all content contained by landmarks', async ({ page }) => {
    // Navigate to the homepage
    await page.goto('https://gooseandquill.blog/');
    
    // Verify main landmark exists
    const main = page.locator('main');
    await expect(main).toBeVisible();
    
    // Verify articles are inside main landmark
    const articlesInMain = page.locator('main article');
    const articleCount = await articlesInMain.count();
    expect(articleCount).toBeGreaterThan(0);
    
    // Verify header landmark exists
    const header = page.locator('header');
    await expect(header).toBeVisible();
    
    // Verify footer landmark exists
    const footer = page.locator('footer');
    await expect(footer).toBeVisible();
  });

  test('homepage should pass axe accessibility checks for region rule', async ({ page }) => {
    // Navigate to the homepage
    await page.goto('https://gooseandquill.blog/');
    
    // Inject axe-core
    await injectAxe(page);
    
    // Check specifically for the region rule that was failing
    await checkA11y(page, null, {
      axeOptions: {
        runOnly: {
          type: 'rule',
          values: ['region']
        }
      }
    });
  });

  test('individual post pages should have content in main landmark', async ({ page }) => {
    // This test assumes at least one post exists
    // If you need to test a specific post, update the URL
    await page.goto('https://gooseandquill.blog/');
    
    // Find all article links
    const postLinks = page.locator('article h1 a');
    const linkCount = await postLinks.count();
    
    // Skip test if no posts exist
    if (linkCount === 0) {
      test.skip();
      return;
    }
    
    // Navigate to first post
    await postLinks.first().click();
    
    // Verify main landmark exists on post page
    const main = page.locator('main');
    await expect(main).toBeVisible();
    
    // Verify article is inside main landmark
    const articleInMain = page.locator('main article');
    await expect(articleInMain).toBeVisible();
  });
});
