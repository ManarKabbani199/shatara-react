// Compress large PNG/JPG assets used by the site into optimized WebP files.
// Usage: node scripts/optimize-images.mjs
// Originals are kept untouched.

import sharp from 'sharp';
import { existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const imagesDir = join(root, 'public', 'assets', 'images');

// [source, output, maxWidth, quality, keepAlpha]
const jobs = [
  ['backhome.png', 'backhome.webp', 1920, 78, false],
  ['Login.png', 'login-bg.webp', 1920, 78, false],
  ['19 1.png', 'guide-bg.webp', 1600, 78, false],
  ['looog.png', 'looog.webp', 1600, 88, true],
  ['image 302.png', 'auth-pieces.webp', 1080, 85, true],
  ['st1.png', 'st1.webp', 800, 80, false],
  ['st2.png', 'st2.webp', 800, 80, false],
  ['st3.png', 'st3.webp', 800, 80, false],
  ['st4.png', 'st4.webp', 800, 80, false],
  ['product-sha-26-004-s2.png', 'product-sha-26-004-s2.webp', 800, 82, false],
  ['stat.png', 'stat.webp', 1200, 82, false],
  ['hero.png', 'hero.webp', 1600, 80, false],
];

for (const [src, out, maxWidth, quality, keepAlpha] of jobs) {
  const srcPath = join(imagesDir, src);
  const outPath = join(imagesDir, out);
  if (!existsSync(srcPath)) {
    console.log(`SKIP (missing): ${src}`);
    continue;
  }
  try {
    let img = sharp(srcPath);
    const meta = await img.metadata();
    if (meta.width && meta.width > maxWidth) img = img.resize({ width: maxWidth });
    if (!keepAlpha) img = img.flatten({ background: '#ffffff' });
    await img.webp({ quality }).toFile(outPath);
    console.log(`OK: ${src} -> ${out}`);
  } catch (err) {
    console.error(`FAIL: ${src}: ${err.message}`);
  }
}
