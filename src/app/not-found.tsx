import Link from 'next/link';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'الصفحة غير موجودة',
};

export default function NotFound() {
  return (
    <main className="flex-1 min-h-screen flex items-center justify-center" dir="rtl">
      <div className="text-center px-4">
        <h1 className="text-6xl font-bold text-brand-purple mb-4">404</h1>
        <h2 className="text-2xl font-bold text-brand-brown mb-4 font-alexandria">
          الصفحة غير موجودة
        </h2>
        <p className="text-text-secondary mb-8 font-alexandria">
          عذراً، الصفحة التي تبحث عنها غير موجودة.
        </p>
        <Link
          href="/"
          className="inline-block bg-brand-purple text-white px-6 py-3 rounded-xl font-bold font-alexandria hover:bg-brand-purple/90 transition-colors"
        >
          العودة للرئيسية
        </Link>
      </div>
    </main>
  );
}