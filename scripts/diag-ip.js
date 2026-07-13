const puppeteer = require('puppeteer-core');

(async () => {
  const browser = await puppeteer.launch({
    executablePath: 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    headless: 'new',
    args: ['--no-sandbox'],
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 375, height: 812, deviceScaleFactor: 2, isMobile: true, hasTouch: true });
  await page.goto('http://192.168.1.6:3000/', { waitUntil: 'domcontentloaded', timeout: 60000 });
  await new Promise((r) => setTimeout(r, 10000));

  const diag = await page.evaluate(() => {
    const root = document.getElementById('__next') || document.body;
    const fiberKey = Object.keys(root).find((k) => k.startsWith('__reactContainer') || k.startsWith('__reactFiber'));
    const btn = document.querySelector('button[aria-label="فتح القائمة"]');
    const btnFiber = btn ? Object.keys(btn).find((k) => k.startsWith('__reactProps')) : null;
    return {
      rootHasFiber: !!fiberKey,
      buttonHasReactProps: !!btnFiber,
      html: document.body.innerHTML.slice(0, 300),
      pendingScripts: Array.from(document.scripts).filter((s) => s.src && !s.dataset.loaded).length,
    };
  });
  console.log(JSON.stringify(diag, null, 2));
  await page.screenshot({ path: 'screenshots/10-ip-state.png' });
  await browser.close();
})();
