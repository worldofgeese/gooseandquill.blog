// @ts-check
const { test, expect } = require('@playwright/test');

/**
 * Calculate relative luminance for accessibility contrast
 * https://www.w3.org/TR/WCAG20-TECHS/G17.html
 */
function relativeLuminance(r, g, b) {
  const [rs, gs, bs] = [r, g, b].map(c => {
    c = c / 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
}

/**
 * Calculate contrast ratio between two RGB colors
 * https://www.w3.org/TR/WCAG20-TECHS/G17.html
 */
function contrastRatio(rgb1, rgb2) {
  const l1 = relativeLuminance(rgb1[0], rgb1[1], rgb1[2]);
  const l2 = relativeLuminance(rgb2[0], rgb2[1], rgb2[2]);
  const lighter = Math.max(l1, l2);
  const darker = Math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

/**
 * Parse RGB color string to array of numbers
 */
function parseRgb(rgbString) {
  const match = rgbString.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)/);
  if (!match) return null;
  return [parseInt(match[1]), parseInt(match[2]), parseInt(match[3])];
}

test.describe('Color Contrast Accessibility', () => {
  test('home link should meet WCAG 2.1 AA contrast ratio of 4.5:1', async ({ page }) => {
    // Use environment variable or default to localhost
    const baseURL = process.env.BASE_URL || 'http://localhost:8080';
    await page.goto(`${baseURL}/`);
    
    // Find the home link element
    const homeLink = page.locator('a.home').first();
    await expect(homeLink).toBeVisible();
    
    // Get computed styles
    const color = await homeLink.evaluate(el => {
      return window.getComputedStyle(el).color;
    });
    
    const backgroundColor = await homeLink.evaluate(el => {
      // Walk up the DOM tree to find the first non-transparent background
      let element = el;
      let bgColor = window.getComputedStyle(element).backgroundColor;
      
      while (element && (bgColor === 'rgba(0, 0, 0, 0)' || bgColor === 'transparent')) {
        element = element.parentElement;
        if (!element) {
          // Fallback to white if no background is found
          bgColor = 'rgb(255, 255, 255)';
          break;
        }
        bgColor = window.getComputedStyle(element).backgroundColor;
      }
      
      return bgColor;
    });
    
    const fgRgb = parseRgb(color);
    const bgRgb = parseRgb(backgroundColor);
    
    expect(fgRgb).not.toBeNull();
    expect(bgRgb).not.toBeNull();
    
    const contrast = contrastRatio(fgRgb, bgRgb);
    
    // WCAG 2.1 AA requires 4.5:1 for normal text
    expect(contrast).toBeGreaterThanOrEqual(4.5);
  });
});
