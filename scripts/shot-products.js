const puppeteer = require('puppeteer-core');

(async () => {
  const browser = await puppeteer.launch({
    executablePath: 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    headless: 'new',
    args: ['--no-sandbox'],
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 375, height: 812, deviceScaleFactor: 2, isMobile: true });
  await page.goto('http://localhost:3000/', { waitUntil: 'domcontentloaded', timeout: 60000 });
  await new Promise((r) => setTimeout(r, 3000));

  const section = await page.evaluateHandle(() => {
    const h2s = Array.from(document.querySelectorAll('h2'));
    const h = h2s.find((el) => el.textContent.includes('إكتشف'));
    return h ? h.closest('section') : null;
  });
  if (section && section.asElement()) {
    const el = section.asElement();
    await el.scrollIntoView();
    await new Promise((r) => setTimeout(r, 2500));
    await el.screenshot({ path: 'screenshots/02-products-section.png' });
    console.log('saved 02-products-section.png');
  } else {
    console.log('section not found');
  }
  await browser.close();
})();
