'use client';

import Link from 'next/link';
import Image from 'next/image';
import { useState, useCallback, useEffect } from 'react';
import { SITE, URLS } from '@/config/constants';
import { MdClose } from 'react-icons/md';

export function LandingNavbar() {
  const [mobileOpen, setMobileOpen] = useState(false);

  const closeMobile = useCallback(() => setMobileOpen(false), []);

  useEffect(() => {
    if (mobileOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [mobileOpen]);

  return (
    <>
      <header
        className="sticky top-0 z-50 w-full bg-white border-b border-gray-100"
        style={{ willChange: 'transform' }}
      >
        <nav className="max-w-7xl mx-auto px-4 py-4" dir="rtl">
          {/* Desktop */}
          <div className="hidden lg:flex items-center justify-between w-full">
            <Link href="/" className="shrink-0">
              <Image
                src="/assets/images/logoapp.png"
                alt={SITE.name}
                width={150}
                height={60}
                className="h-12 w-auto object-contain"
              />
            </Link>

            <div className="flex items-center gap-10">
              <Link
                href="#play"
                className="text-base font-bold transition-colors hover:opacity-75"
                style={{ color: '#6B4E45' }}
              >
                إلعب الآن
              </Link>
              <a
                href={URLS.store}
                target="_blank"
                rel="noopener noreferrer"
                className="text-base font-bold transition-colors hover:opacity-75"
                style={{ color: '#6B4E45' }}
              >
                متجر شطارة
              </a>
              <a
                href={URLS.club}
                target="_blank"
                rel="noopener noreferrer"
                className="text-base font-bold transition-colors hover:opacity-75"
                style={{ color: '#6B4E45' }}
              >
                نادي شطارة
              </a>
              <a
                href={URLS.guide}
                target="_blank"
                rel="noopener noreferrer"
                className="text-base font-bold transition-colors hover:opacity-75"
                style={{ color: '#6B4E45' }}
              >
                دليل شطارة
              </a>
            </div>

            <div className="shrink-0">
              <Link
                href="/login"
                className="px-8 py-2 rounded-xl text-white font-bold text-lg shadow transition-all flex items-center justify-center hover:opacity-90"
                style={{ backgroundColor: '#AB86B9' }}
              >
                تسجيل الدخول
              </Link>
            </div>
          </div>

          {/* Mobile */}
          <div className="flex lg:hidden items-center justify-between">
            <Link href="/">
              <Image
                src="/assets/images/logoapp.png"
                alt={SITE.name}
                width={120}
                height={50}
                className="h-9 w-auto object-contain"
              />
            </Link>

            <button
              onClick={() => setMobileOpen(true)}
              className="p-2 text-brand-brown"
              aria-label="فتح القائمة"
            >
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </button>
          </div>
        </nav>
      </header>

      {mobileOpen && (
        <>
          <div
            className="fixed inset-0 bg-black/50 z-50"
            onClick={closeMobile}
          />
          <div
            className="fixed inset-y-0 end-0 w-64 bg-white shadow-2xl z-50"
            dir="rtl"
          >
            <div className="flex items-center justify-between p-3 border-b border-brand-brown/10">
              <Image
                src="/assets/images/logoapp.png"
                alt={SITE.name}
                width={120}
                height={50}
                className="h-10 w-auto object-contain"
              />
              <button
                onClick={closeMobile}
                className="p-1.5 text-brand-brown rounded-lg hover:bg-brand-brown/10 transition-colors"
                aria-label="إغلاق القائمة"
              >
                <MdClose className="w-5 h-5" />
              </button>
            </div>

            <div className="flex flex-col p-3 gap-0.5">
              <Link
                href="#play"
                onClick={closeMobile}
                className="px-4 py-3 rounded-xl text-brand-brown hover:bg-brand-purple/10 hover:text-brand-purple font-semibold text-base transition-all"
              >
                إلعب الآن
              </Link>
              <a
                href={URLS.store}
                target="_blank"
                rel="noopener noreferrer"
                onClick={closeMobile}
                className="px-4 py-3 rounded-xl text-brand-brown hover:bg-brand-purple/10 hover:text-brand-purple font-semibold text-base transition-all"
              >
                متجر شطارة
              </a>
              <a
                href={URLS.club}
                target="_blank"
                rel="noopener noreferrer"
                onClick={closeMobile}
                className="px-4 py-3 rounded-xl text-brand-brown hover:bg-brand-purple/10 hover:text-brand-purple font-semibold text-base transition-all"
              >
                نادي شطارة
              </a>
              <a
                href={URLS.guide}
                target="_blank"
                rel="noopener noreferrer"
                onClick={closeMobile}
                className="px-4 py-3 rounded-xl text-brand-brown hover:bg-brand-purple/10 hover:text-brand-purple font-semibold text-base transition-all"
              >
                دليل شطارة
              </a>

              <hr className="border-brand-brown/10 my-2" />

              <Link
                href="/login"
                onClick={closeMobile}
                className="flex items-center justify-center gap-2 px-4 py-3 rounded-xl bg-brand-purple text-white font-bold text-base"
              >
                تسجيل الدخول
              </Link>
            </div>
          </div>
        </>
      )}
    </>
  );
}
