import type { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'سياسة الملكية الفكرية',
};

export default function PrivacyPage() {
  return (
    <main className="flex-1 min-h-screen" dir="rtl">
      <div className="max-w-3xl mx-auto px-4 py-16">
        <Link
          href="/"
          className="text-brand-purple hover:text-brand-brown font-bold text-sm mb-8 inline-block"
        >
          ← العودة للرئيسية
        </Link>

        <h1 className="text-2xl font-bold text-brand-brown mb-8 font-alexandria">
          سياسة الملكية الفكرية
        </h1>

        <div className="prose max-w-none text-brand-brown/80 text-sm leading-relaxed">
          <p className="mb-4">
            تحمي شطارة حقوق الملكية الفكرية المتعلقة بجميع محتويات التطبيق بما في ذلك على سبيل
            المثال لا الحصر: الأسماء التجارية، الشعارات، التصاميم، النصوص، الرسومات، والأصوات.
          </p>

          <h2 className="text-lg font-bold text-brand-brown mt-8 mb-3">حقوق النشر</h2>
          <p className="mb-4">
            جميع المواد المنشورة في هذا التطبيق محمية بقوانين حقوق النشر المعمول بها في المملكة
            العربية السعودية.
          </p>

          <h2 className="text-lg font-bold text-brand-brown mt-8 mb-3">العلامات التجارية</h2>
          <p className="mb-4">
            شطارة وشعارها هي علامات تجارية مسجلة. لا يجوز استخدامها دون إذن كتابي مسبق.
          </p>

          <h2 className="text-lg font-bold text-brand-brown mt-8 mb-3">الانتهاكات</h2>
          <p className="mb-4">
            إذا كنت تعتقد أن حقوق الملكية الفكرية الخاصة بك قد انتهكت، يرجى التواصل معنا على
            shatara@shatara.sa
          </p>
        </div>
      </div>
    </main>
  );
}