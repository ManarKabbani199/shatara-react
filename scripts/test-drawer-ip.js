const puppeteer = require('puppeteer-core');

(async () => {
  const browser = await puppeteer.launch({
    executablePath: 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    headless: 'new',
    args: ['--no-sandbox'],
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 375, height: 812, deviceScaleFactor: 2, isMobile: true, hasTouch: true });
  const logs = [];
  page.on('pageerror', (e) => logs.push('PAGEERROR: ' + e.message));
  page.on('console', (m) => logs.push(m.type().toUpperCase() + ': ' + m.text()));
  page.on('requestfailed', (r) => logs.push('REQFAIL: ' + r.url() + ' ' + (r.failure()?.errorText || '')));
  page.on('response', (r) => { if (r.status() >= 300) logs.push('HTTP ' + r.status() + ': ' + r.url()); });

  await page.goto('http://192.168.1.6:3000/', { waitUntil: 'networkidle2', timeout: 60000 }).catch((e) => logs.push('GOTO: ' + e.message));

  // Poll for hydration signs for up to 15s
  for (let i = 0; i < 15; i++) {
    await new Promise((r) => setTimeout(r, 1000));
    const s = await page.evaluate(() => ({
      popup: !!document.querySelector('.video-popup-overlay'),
      nextData: !!window.__NEXT_DATA__,
      readyState: document.readyState,
    }));
    if (s.popup) { logs.push('HYDRATED after ~' + (i + 1) + 's (popup appeared)'); break; }
    if (i === 14) logs.push('NOT hydrated after 15s: ' + JSON.stringify(s));
  }

  // synthetic click test
  const synth = await page.evaluate(() => {
    const btn = document.querySelector('button[aria-label="فتح القائمة"]');
    if (!btn) return 'no button';
    btn.click();
    return 'clicked';
  });
  await new Promise((r) => setTimeout(r, 500));
  const after = await page.evaluate(() => !!document.querySelector('.fixed.inset-y-0'));
  logs.push('synthetic click: ' + synth + ', panel: ' + after);

  console.log(logs.join('\n'));
  await browser.close();
})();
