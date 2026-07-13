'use client';

import { useState, useCallback, useEffect } from 'react';
import Link from 'next/link';
import { MdLogin, MdLogout, MdClose } from 'react-icons/md';
import { URLS } from '@/config/constants';
import { useAuthState } from '@/features/auth/hooks/use-auth-state';

export function Navbar() {
  const [mobileOpen, setMobileOpen] = useState(false);
  const { isLoggedIn, logout } = useAuthState();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

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
        className="sticky top-0 z-50 w-full bg-white/80 backdrop-blur-md border-b border-brand-brown/10 supports-[backdrop-filter]:bg-white/80"
        style={{ willChange: 'transform' }}
      >
        <nav className="max-w-6xl mx-auto px-4 py-3" dir="rtl">
          {/* Desktop */}
          <div className="hidden lg:flex items-center gap-4">
            <Link href="/" className="shrink-0 group">
              <img
                src="/assets/images/logon.png"
                alt="شعار شطارة"
                width="75"
                height="33"
                className="w-auto transition-transform group-hover:scale-105"
                style={{ height: '36px', display: 'block' }}
              />
            </Link>

            <NavLink label="إلعب الآن" icon={<NavIcon src="/assets/images/chese.jpeg" alt="إلعب الآن" />} href="https://shatara.sa/play/" external />
            <NavLink label="متجر شطارة" icon={<NavIcon src="/assets/images/store.jpeg" alt="متجر شطارة" />} href={URLS.store} external />
            <NavLink label="نادي شطارة" icon={<NavIcon src="/assets/images/commuinty.jpeg" alt="نادي شطارة" />} href={URLS.club} external />
            <NavLink label="دليل شطارة" icon={<NavIcon src="/assets/images/book.jpeg" alt="دليل شطارة" />} href={URLS.guide} external />

            <div className="flex-1" />

            {mounted && isLoggedIn ? (
              <button
                onClick={logout}
                className="flex items-center gap-1.5 px-4 py-2 rounded-lg bg-brand-purple/10 text-brand-purple font-semibold text-base transition-colors hover:bg-brand-purple hover:text-white"
              >
                <MdLogout className="w-5 h-5" />
                تسجيل الخروج
              </button>
            ) : (
              <Link
                href="/login"
                className="inline-flex items-center gap-1.5 px-5 py-2 rounded-lg bg-brand-purple text-white font-semibold text-base shadow-md shadow-brand-purple/20 hover:shadow-brand-purple/30 transition-all"
              >
                <MdLogin className="w-5 h-5" />
                تسجيل الدخول
              </Link>
            )}
          </div>

          {/* Mobile */}
          <div className="flex lg:hidden items-center justify-between">
            <Link href="/">
              <img
                src="/assets/images/logon.png"
                alt="شعار شطارة"
                width="75"
                height="33"
                className="w-auto"
                style={{ height: '36px', display: 'block' }}
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
            className="fixed inset-y-0 start-0 w-72 max-w-[85vw] bg-white shadow-2xl z-50 flex flex-col"
            dir="rtl"
          >
            <div className="flex items-center justify-between p-4 border-b border-brand-brown/10 shrink-0">
              <img
                src="/assets/images/logon.png"
                alt="شعار شطارة"
                width="84"
                height="37"
                className="w-auto"
                style={{ height: '40px', display: 'block' }}
              />
              <button
                onClick={closeMobile}
                className="p-2 text-brand-brown rounded-lg hover:bg-brand-brown/10 transition-colors"
                aria-label="إغلاق القائمة"
              >
                <MdClose className="w-6 h-6" />
              </button>
            </div>

            <div className="flex flex-col p-4 gap-1 overflow-y-auto">
              <DrawerLink label="إلعب الآن" icon={<NavIcon src="/assets/images/chese.jpeg" alt="إلعب الآن" />} href="https://shatara.sa/play/" onClick={closeMobile} />
              <DrawerLink label="متجر شطارة" icon={<NavIcon src="/assets/images/store.jpeg" alt="متجر شطارة" />} href={URLS.store} onClick={closeMobile} />
              <DrawerLink label="نادي شطارة" icon={<NavIcon src="/assets/images/commuinty.jpeg" alt="نادي شطارة" />} href={URLS.club} onClick={closeMobile} />
              <DrawerLink label="دليل شطارة" icon={<NavIcon src="/assets/images/book.jpeg" alt="دليل شطارة" />} href={URLS.guide} onClick={closeMobile} />

              <hr className="border-brand-brown/10 my-2" />

              {mounted && isLoggedIn ? (
                <button
                  onClick={() => { logout(); closeMobile(); }}
                  className="flex items-center gap-2 px-4 py-3 rounded-xl bg-brand-purple text-white font-bold text-base"
                >
                  <MdLogout className="w-5 h-5" />
                  تسجيل الخروج
                </button>
              ) : (
                <Link
                  href="/login"
                  onClick={closeMobile}
                  className="flex items-center gap-2 px-4 py-3 rounded-xl bg-brand-purple text-white font-bold text-base"
                >
                  <MdLogin className="w-5 h-5" />
                  تسجيل الدخول
                </Link>
              )}
            </div>
          </div>
        </>
      )}
    </>
  );
}

function NavLink({
  label,
  icon,
  href,
  external,
}: {
  label: string;
  icon: React.ReactNode;
  href: string;
  external?: boolean;
}) {
  return (
    <a
      href={href}
      target={external ? '_blank' : undefined}
      rel={external ? 'noopener noreferrer' : undefined}
      className="flex items-center gap-1.5 px-3 py-2 text-base font-semibold text-brand-purple hover:text-brand-brown transition-colors group"
    >
      <span className="transition-transform group-hover:scale-110">{icon}</span>
      {label}
      <span className="h-0.5 w-0 group-hover:w-full bg-brand-purple transition-all duration-300" />
    </a>
  );
}

function DrawerLink({
  label,
  icon,
  href,
  onClick,
}: {
  label: string;
  icon?: React.ReactNode;
  href: string;
  onClick: () => void;
}) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      onClick={onClick}
      className="flex items-center gap-2 px-4 py-3 rounded-xl text-brand-brown hover:bg-brand-purple/10 hover:text-brand-purple font-semibold text-base transition-all"
    >
      {icon}
      {label}
    </a>
  );
}

function NavIcon({ src, alt }: { src: string; alt: string }) {
  return <img src={src} alt={alt} className="w-5 h-5 object-contain rounded-sm" />;
}
