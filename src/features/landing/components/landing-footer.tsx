'use client';

import Link from 'next/link';
import Image from 'next/image';
import { SITE, CONTACT, URLS } from '@/config/constants';

const footerLinks = {
  pages: [
    { name: 'الرئيسية', href: '/' },
    { name: 'تعرف على شطارة', href: '#guide' },
    { name: 'إلعب الآن', href: 'https://shatara.sa/play/', external: true },
    { name: 'المنتجات', href: '#products' },
  ],
  // Social accounts are hidden until the real profile URLs are available.
  socials: [] as { icon: unknown; href: string; label: string }[],
};

export function LandingFooter() {
  return (
    <footer className="bg-white border-t border-gray-100 pt-16 pb-8" dir="rtl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 mb-16 items-start">

          {/* Right Column: Logo & Pages (First Child = Rightmost in RTL) */}
          <div className="text-right">
            <Link href="/" className="inline-block mb-8">
              <Image
                src="/assets/images/logoapp.png"
                alt={SITE.name}
                width={150}
                height={60}
                className="h-14 w-auto"
              />
            </Link>
            <div className="space-y-4">
              <h3 className="text-xl font-bold text-gray-800 mb-6">الصفحات</h3>
              <ul className="space-y-4">
                {footerLinks.pages.map((link) => (
                  <li key={link.name}>
                    {link.external ? (
                      <a
                        href={link.href}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-gray-600 hover:text-[#AB86B9] font-bold text-base transition-colors"
                      >
                        {link.name}
                      </a>
                    ) : (
                      <Link
                        href={link.href}
                        className="text-gray-600 hover:text-[#AB86B9] font-bold text-base transition-colors"
                      >
                        {link.name}
                      </Link>
                    )}
                  </li>
                ))}
                <li>
                  <a
                    href={URLS.store}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-gray-600 hover:text-[#AB86B9] font-bold text-base transition-colors"
                  >
                    متجر شطارة
                  </a>
                </li>
              </ul>
            </div>
          </div>

          {/* Left Column: Contact */}
          <div className="text-center md:text-left">
            <h3 className="text-xl font-bold text-gray-800 mb-6">تواصل معنا</h3>
            <div className="space-y-4">
              <p className="text-gray-600 font-medium">{CONTACT.email}</p>
              <p className="text-gray-800 font-bold text-lg" dir="ltr">{CONTACT.phone}</p>
              <div className="pt-4">
                <a
                  href={`mailto:${CONTACT.email}`}
                  className="inline-block px-8 py-3 rounded-xl bg-[#AB86B9] text-white font-bold text-sm hover:bg-[#AB86B9]/90 transition-colors shadow-sm"
                >
                  مركز المساعدة و الدعم
                </a>
              </div>
            </div>
          </div>

        </div>

        {/* Bottom Bar */}
        <div className="pt-8 border-t border-gray-100 flex flex-col md:flex-row items-center justify-between gap-4">
          <p className="text-sm font-bold text-gray-500">
            © {new Date().getFullYear()} شطارة. جميع الحقوق محفوظة
          </p>
          <div className="flex items-center gap-8">
            <Link href="/terms" className="text-sm font-bold text-gray-500 hover:text-[#AB86B9] transition-colors">الشروط والأحكام</Link>
            <Link href="/privacy" className="text-sm font-bold text-gray-500 hover:text-[#AB86B9] transition-colors">سياسة الملكية الفكرية</Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
