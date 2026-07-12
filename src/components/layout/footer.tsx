import Link from 'next/link';

const footerLinks = [
  { label: 'الشروط و الأحكام', href: '/terms' },
  { label: 'سياسة الملكية الفكرية', href: '/privacy' },
];

export function Footer() {
  return (
    <footer className="w-full px-4 md:px-10 py-10 anim-fade-up" dir="rtl" style={{ '--anim-delay': '0.4s' } as React.CSSProperties}>
      <div className="max-w-6xl mx-auto">
        <hr className="border-brand-brown/15 mb-5" />

        <div className="flex flex-col md:flex-row items-center justify-between gap-4">
          <p className="text-xs font-bold text-brand-brown">
            © 2025 شطارة. جميع الحقوق محفوظة
          </p>

          <div className="flex items-center gap-5">
            {footerLinks.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className="text-xs font-bold text-brand-brown hover:text-brand-purple transition-colors relative group"
              >
                {link.label}
                <span className="absolute -bottom-0.5 end-0 w-0 group-hover:w-full h-0.5 bg-brand-purple transition-all duration-300" />
              </Link>
            ))}
          </div>
        </div>
      </div>
    </footer>
  );
}