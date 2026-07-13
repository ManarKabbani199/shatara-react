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
  await new Promise((r) => setTimeout(r, 5000));

  const popup = await page.evaluateHandle(() => document.querySelector('.video-popup-overlay'));
  if (popup && popup.asElement()) {
    await popup.asElement().screenshot({ path: 'screenshots/08-video-popup.png' }).catch(async () => {
      await page.screenshot({ path: 'screenshots/08-video-popup.png' });
    });
    console.log('popup found, saved 08-video-popup.png');
  } else {
    await page.screenshot({ path: 'screenshots/08-video-popup.png' });
    console.log('popup NOT found, saved full page');
  }
  await browser.close();
})();
