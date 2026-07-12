'use client';

import Link from 'next/link';
import Image from 'next/image';
import { SITE, CONTACT } from '@/config/constants';
import { FaLinkedin, FaXTwitter, FaInstagram, FaYoutube, FaFacebook } from 'react-icons/fa6';

const footerLinks = {
  pages: [
    { name: 'الرئيسية', href: '/' },
    { name: 'تعرف على شطارة', href: '#guide' },
    { name: 'إلعب الآن', href: 'https://shatara.sa/play/', external: true },
    { name: 'من نحن', href: '#about' },
  ],
  socials: [
    { icon: FaLinkedin, href: '#', label: 'LinkedIn' },
    { icon: FaXTwitter, href: '#', label: 'X' },
    { icon: FaFacebook, href: '#', label: 'Facebook' },
    { icon: FaInstagram, href: '#', label: 'Instagram' },
    { icon: FaYoutube, href: '#', label: 'YouTube' },
  ],
};

export function LandingFooter() {
  return (
    <footer className="bg-white border-t border-gray-100 pt-16 pb-8" dir="rtl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-12 mb-16 items-start">

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
              </ul>
            </div>
          </div>

          {/* Middle Column: Contact */}
          <div className="text-center">
            <h3 className="text-xl font-bold text-gray-800 mb-6">تواصل معنا</h3>
            <div className="space-y-4">
              <p className="text-gray-600 font-medium">{CONTACT.email}</p>
              <p className="text-gray-800 font-bold text-lg" dir="ltr">{CONTACT.phone}</p>
              <div className="pt-4">
                <button className="px-8 py-3 rounded-xl bg-[#AB86B9] text-white font-bold text-sm hover:bg-[#AB86B9]/90 transition-colors shadow-sm">
                  مركز المساعدة و الدعم
                </button>
              </div>
            </div>
          </div>

          {/* Left Column: Newsletter & Socials (Inside Gray Box) */}
          <div className="bg-[#F8F9FA] rounded-[24px] p-8">
            <h3 className="text-[15px] font-bold text-[#4A4A4A] mb-4 text-right">ابق مطلع على جديد شطارة</h3>
            <form className="flex gap-[10px] mb-10" dir="rtl">
              <input
                type="email"
                placeholder="البريد الإلكتروني"
                className="w-full md:w-[302px] px-4 py-3 rounded-lg bg-white border border-gray-200 text-[11px] focus:outline-none focus:border-[#AB86B9] transition-all text-right placeholder:text-gray-300"
              />
              <button className="whitespace-nowrap px-4 py-3 rounded-lg bg-[#AB86B9] text-white font-bold text-[11px] hover:bg-[#AB86B9]/90 transition-all shadow-sm">
                إشترك الآن
              </button>
            </form>
            
            <div className="space-y-3 text-right">
              <h4 className="text-[13px] font-bold text-[#4A4A4A]">حسابات شطارة</h4>
              <div className="flex items-center justify-start gap-1.5">
                {footerLinks.socials.map((social, idx) => (
                  <Link
                    key={idx}
                    href={social.href}
                    aria-label={social.label}
                    className="w-8 h-8 rounded bg-[#AB86B9] text-white flex items-center justify-center hover:bg-[#AB86B9]/90 transition-all"
                  >
                    <social.icon className="w-4 h-4" />
                  </Link>
                ))}
              </div>
            </div>
          </div>

        </div>

        {/* Bottom Bar */}
        <div className="pt-8 border-t border-gray-100 flex flex-col md:flex-row items-center justify-between gap-4">
          <p className="text-sm font-bold text-gray-500">
            © 2025 شطارة. جميع الحقوق محفوظة
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
