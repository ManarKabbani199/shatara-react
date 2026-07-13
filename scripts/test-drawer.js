const puppeteer = require('puppeteer-core');

(async () => {
  const browser = await puppeteer.launch({
    executablePath: 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    headless: 'new',
    args: ['--no-sandbox'],
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 375, height: 812, deviceScaleFactor: 2, isMobile: true, hasTouch: true });
  const errors = [];
  page.on('pageerror', (e) => errors.push('PAGEERROR: ' + e.message));
  page.on('console', (m) => { if (m.type() === 'error') errors.push('CONSOLE: ' + m.text()); });

  await page.goto('http://localhost:3000/', { waitUntil: 'domcontentloaded', timeout: 60000 });
  await new Promise((r) => setTimeout(r, 4000));

  // Close video popup if present (click close button)
  const closedPopup = await page.evaluate(() => {
    const btn = document.querySelector('.video-popup-close');
    if (btn) { btn.click(); return true; }
    return false;
  });
  console.log('popup closed:', closedPopup);
  await new Promise((r) => setTimeout(r, 600));

  // Find and click the hamburger (mobile menu button)
  const clicked = await page.evaluate(() => {
    const btns = Array.from(document.querySelectorAll('header button, nav button'));
    const burger = btns.find((b) => {
      const label = (b.getAttribute('aria-label') || '').toLowerCase();
      return label.includes('menu') || label.includes('القائمة') || b.querySelector('svg');
    });
    // prefer the one in the navbar that is visible on mobile
    const visible = btns.filter((b) => b.offsetParent !== null);
    const target = burger && burger.offsetParent !== null ? burger : visible[0];
    if (target) { target.click(); return target.outerHTML.slice(0, 120); }
    return null;
  });
  console.log('clicked button:', clicked);
  await new Promise((r) => setTimeout(r, 800));

  const drawerInfo = await page.evaluate(() => {
    const overlays = Array.from(document.querySelectorAll('.fixed.inset-0'));
    const panel = document.querySelector('.fixed.inset-y-0');
    return {
      overlayCount: overlays.length,
      panelExists: !!panel,
      panelText: panel ? panel.textContent.slice(0, 80) : null,
      bodyOverflow: document.body.style.overflow,
    };
  });
  console.log('drawer:', JSON.stringify(drawerInfo));

  await page.screenshot({ path: 'screenshots/09-drawer-click-test.png' });
  console.log('errors:', errors.length ? errors.slice(0, 5) : 'none');
  await browser.close();
})();
