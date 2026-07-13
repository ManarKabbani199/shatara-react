const puppeteer = require('puppeteer-core');
const path = require('path');

const CHROME_PATH = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';
const BASE_URL = 'http://localhost:3000';
const OUTPUT_DIR = path.join(__dirname, '..', 'screenshots');

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function findSectionByText(page, text) {
  return page.evaluateHandle((searchText) => {
    const sections = Array.from(document.querySelectorAll('section'));
    return sections.find((s) => s.textContent && s.textContent.includes(searchText)) || null;
  }, text);
}

async function capture() {
  const browser = await puppeteer.launch({
    executablePath: CHROME_PATH,
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-gpu'],
  });

  const page = await browser.newPage();
  await page.setViewport({ width: 375, height: 812, deviceScaleFactor: 2, isMobile: true, hasTouch: true });

  // Disable video popup before loading
  await page.evaluateOnNewDocument(() => {
    sessionStorage.setItem('shatara_kings_intro_seen', '1');
  });

  // Landing page
  console.log('Loading landing page...');
  await page.goto(`${BASE_URL}/`, { waitUntil: 'networkidle2', timeout: 60000 });
  await sleep(1500);

  await page.screenshot({ path: path.join(OUTPUT_DIR, '01-landing-mobile.png'), fullPage: true });
  console.log('01-landing-mobile.png');

  // Products section heading
  let handle = await findSectionByText(page, 'إكتشف');
  let element = handle.asElement();
  if (element) {
    await element.screenshot({ path: path.join(OUTPUT_DIR, '02-products-section.png') });
    console.log('02-products-section.png');
  }

  // Stats section
  handle = await findSectionByText(page, 'أرقامنا');
  element = handle.asElement();
  if (element) {
    await element.screenshot({ path: path.join(OUTPUT_DIR, '03-stats-section.png') });
    console.log('03-stats-section.png');
  }

  // Open mobile drawer on landing
  console.log('Opening landing drawer...');
  await page.evaluate(() => {
    const btn = Array.from(document.querySelectorAll('button')).find((b) => b.getAttribute('aria-label') === 'فتح القائمة');
    if (btn) btn.click();
  });
  await sleep(1000);

  const drawerExists = await page.evaluate(() => {
    const drawer = document.querySelector('.fixed.inset-y-0.start-0');
    return !!drawer;
  });
  console.log('Landing drawer exists:', drawerExists);

  await page.screenshot({ path: path.join(OUTPUT_DIR, '04-drawer-open.png') });
  console.log('04-drawer-open.png');

  // Close drawer
  await page.evaluate(() => {
    const btn = Array.from(document.querySelectorAll('button')).find((b) => b.getAttribute('aria-label') === 'إغلاق القائمة');
    if (btn) btn.click();
  });
  await sleep(500);

  // Home page
  console.log('Loading home page...');
  await page.goto(`${BASE_URL}/home`, { waitUntil: 'networkidle2', timeout: 60000 });
  await sleep(1500);

  // Open home drawer
  console.log('Opening home drawer...');
  await page.evaluate(() => {
    const btn = Array.from(document.querySelectorAll('button')).find((b) => b.getAttribute('aria-label') === 'فتح القائمة');
    if (btn) btn.click();
  });
  await sleep(1000);

  const homeDrawerExists = await page.evaluate(() => {
    const drawer = document.querySelector('.fixed.inset-y-0.start-0');
    return !!drawer;
  });
  console.log('Home drawer exists:', homeDrawerExists);

  await page.screenshot({ path: path.join(OUTPUT_DIR, '05-home-drawer-open.png') });
  console.log('05-home-drawer-open.png');

  // Close home drawer
  await page.evaluate(() => {
    const btn = Array.from(document.querySelectorAll('button')).find((b) => b.getAttribute('aria-label') === 'إغلاق القائمة');
    if (btn) btn.click();
  });
  await sleep(500);

  await page.screenshot({ path: path.join(OUTPUT_DIR, '06-home-mobile.png'), fullPage: true });
  console.log('06-home-mobile.png');

  // Store section on home
  handle = await findSectionByText(page, 'متجر شطاره');
  element = handle.asElement();
  if (element) {
    await element.screenshot({ path: path.join(OUTPUT_DIR, '07-store-section.png') });
    console.log('07-store-section.png');
  }

  await browser.close();
  console.log('Done.');
}

capture().catch((err) => {
  console.error(err);
  process.exit(1);
});
