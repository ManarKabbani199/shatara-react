'use client';

import Link from 'next/link';
import Image from 'next/image';
import { SITE, CONTACT, URLS, SOCIALS } from '@/config/constants';
import { FaLinkedin, FaXTwitter, FaInstagram, FaYoutube, FaFacebook } from 'react-icons/fa6';

const footerLinks = {
  pages: [
    { name: 'الرئيسية', href: '/' },
    { name: 'تعرف على شطارة', href: '#guide' },
    { name: 'إلعب الآن', href: 'https://shatara.sa/play/', external: true },
    { name: 'المنتجات', href: '#products' },
  ],
};

// Social icons render only for profiles with a real URL in SOCIALS (config).
const socials = (
  [
    { key: 'linkedin', icon: FaLinkedin, label: 'LinkedIn' },
    { key: 'twitter', icon: FaXTwitter, label: 'X' },
    { key: 'facebook', icon: FaFacebook, label: 'Facebook' },
    { key: 'instagram', icon: FaInstagram, label: 'Instagram' },
    { key: 'youtube', icon: FaYoutube, label: 'YouTube' },
  ] as const
)
  .filter(({ key }) => SOCIALS[key].length > 0)
  .map(({ key, icon, label }) => ({ icon, label, href: SOCIALS[key] }));

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
              {socials.length > 0 && (
                <div className="pt-6 space-y-3">
                  <h4 className="text-sm font-bold text-gray-800">حسابات شطارة</h4>
                  <div className="flex items-center justify-center md:justify-start gap-1.5">
                    {socials.map((social) => (
                      <a
                        key={social.label}
                        href={social.href}
                        target="_blank"
                        rel="noopener noreferrer"
                        aria-label={social.label}
                        className="w-8 h-8 rounded bg-[#AB86B9] text-white flex items-center justify-center hover:bg-[#AB86B9]/90 transition-all"
                      >
                        <social.icon className="w-4 h-4" />
                      </a>
                    ))}
                  </div>
                </div>
              )}
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
