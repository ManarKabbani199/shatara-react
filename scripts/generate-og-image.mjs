// Generate public/assets/images/og-image.png (1200x630) from the app logo.
// Usage: node scripts/generate-og-image.mjs

import sharp from 'sharp';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const imagesDir = join(root, 'public', 'assets', 'images');

const logo = await sharp(join(imagesDir, 'logoapp.png'))
  .resize({ width: 520, withoutEnlargement: true })
  .png()
  .toBuffer();

await sharp({
  create: {
    width: 1200,
    height: 630,
    channels: 3,
    background: '#ffffff',
  },
})
  .composite([{ input: logo, gravity: 'center' }])
  .png()
  .toFile(join(imagesDir, 'og-image.png'));

console.log('OK: og-image.png (1200x630)');
