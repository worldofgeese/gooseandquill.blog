const { chromium } = require('playwright');
const axe = require('axe-core');
const fs = require('fs');
const path = require('path');

(async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();

  // Read and serve the test HTML file
  const testFilePath = path.join(__dirname, 'test-index-structure.html');
  const htmlContent = fs.readFileSync(testFilePath, 'utf-8');
  await page.setContent(htmlContent);

  // Inject axe-core
  await page.addScriptTag({ path: require.resolve('axe-core') });

  // Run axe accessibility tests
  const results = await page.evaluate(() => {
    return axe.run();
  });

  // Check for the specific landmark-one-main rule
  const landmarkMainViolations = results.violations.filter(
    v => v.id === 'landmark-one-main'
  );

  console.log('\n=== Accessibility Test Results ===\n');
  
  if (landmarkMainViolations.length > 0) {
    console.error('❌ FAIL: landmark-one-main violation detected!');
    console.error(JSON.stringify(landmarkMainViolations, null, 2));
    await browser.close();
    process.exit(1);
  }

  // Verify that a main landmark exists
  const mainElement = await page.$('main');
  if (!mainElement) {
    console.error('❌ FAIL: No <main> element found in the document!');
    await browser.close();
    process.exit(1);
  }

  console.log('✅ PASS: Document has exactly one main landmark');
  console.log(`   Total violations found: ${results.violations.length}`);
  console.log(`   Total passes: ${results.passes.length}`);
  
  if (results.violations.length > 0) {
    console.log('\n⚠️  Other accessibility issues found:');
    results.violations.forEach(v => {
      console.log(`   - ${v.id}: ${v.description}`);
    });
  }

  await browser.close();
  console.log('\n✅ All tests passed!\n');
})();
