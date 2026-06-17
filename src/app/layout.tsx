import type { Metadata, Viewport } from 'next';
import './globals.css';
import { Toaster } from 'react-hot-toast';
import { SITE } from '@/config/constants';
import { JsonLd } from '@/components/layout/json-ld';
import GoogleProvider from '@/components/providers/GoogleProvider';

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 5,
  themeColor: '#FFFFFF',
};

export const metadata: Metadata = {
  title: {
    default: `${SITE.name} | لعبة شطارة الاستراتيجية`,
    template: `%s | ${SITE.name}`,
  },
  description: SITE.description,
  keywords: ['شطارة', 'لعبة استراتيجية', 'Saudi shatara', 'شطارة سعودية'],
  authors: [{ name: SITE.nameEn }],
  openGraph: {
    title: `${SITE.name} | لعبة شطارة الاستراتيجية`,
    description: SITE.description,
    url: SITE.url,
    siteName: SITE.name,
    images: [{ url: SITE.ogImage, width: 1200, height: 630 }],
    locale: 'ar_SA',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: `${SITE.name} | لعبة شطارة الاستراتيجية`,
    description: SITE.description,
    images: [SITE.ogImage],
  },
  metadataBase: new URL(SITE.url),
  alternates: {
    canonical: '/',
    languages: {
      ar: '/',
      'x-default': '/',
    },
  },
  other: {
    'geo.region': 'SA',
    'geo.placename': 'Saudi Arabia',
    language: 'Arabic',
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ar" dir="rtl">
      <head>
        <link rel="canonical" href={SITE.url} />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          href="https://fonts.googleapis.com/css2?family=Alexandria:wght@400;500;600;700&display=swap"
          rel="stylesheet"
        />
      </head>

      <body className="min-h-screen flex flex-col font-alexandria">
        <GoogleProvider>
          <JsonLd />
          {children}

          <Toaster
            position="top-center"
            toastOptions={{
              duration: 4000,
              style: {
                fontFamily: 'Alexandria, sans-serif',
                direction: 'rtl',
              },
            }}
          />
        </GoogleProvider>
      </body>
    </html>
  );
}