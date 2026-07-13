import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  trailingSlash: true,

  // Allow accessing the dev server from other devices on the LAN
  // (e.g. testing on a phone at http://192.168.1.6:3000)
  allowedDevOrigins: ['192.168.1.6'],

  images: {
    unoptimized: true,
  },
};

export default nextConfig;