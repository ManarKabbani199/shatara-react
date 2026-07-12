import type { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'الشروط و الأحكام',
};

export default function TermsPage() {
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
          الشروط و الأحكام
        </h1>

        <div className="prose prose-brand-brown max-w-none text-brand-brown/80 text-sm leading-relaxed">
          <p className="mb-4">
            مرحبًا بكم في شطارة. باستخدامكم لهذا التطبيق، فإنكم توافقون على الشروط والأحكام
            التالية. يرجى قراءتها بعناية قبل الاستخدام.
          </p>

          <h2 className="text-lg font-bold text-brand-brown mt-8 mb-3">1. الاستخدام</h2>
          <p className="mb-4">
            يُسمح باستخدام التطبيق للأغراض المشروعة فقط ووفقًا لهذه الشروط.
          </p>

          <h2 className="text-lg font-bold text-brand-brown mt-8 mb-3">2. الملكية الفكرية</h2>
          <p className="mb-4">
            جميع المحتويات والتصاميم والعلامات التجارية في هذا التطبيق هي ملك لشطارة ومحمية
            بموجب قوانين الملكية الفكرية.
          </p>

          <h2 className="text-lg font-bold text-brand-brown mt-8 mb-3">3. الخصوصية</h2>
          <p className="mb-4">
            نحن نحترم خصوصيتكم ونلتزم بحماية بياناتكم الشخصية وفقًا لسياسة الخصوصية المعمول
            بها.
          </p>

          <h2 className="text-lg font-bold text-brand-brown mt-8 mb-3">4. التعديلات</h2>
          <p className="mb-4">
            نحتفظ بالحق في تعديل هذه الشروط في أي وقت. سيتم إشعاركم بأي تغييرات جوهرية.
          </p>
        </div>
      </div>
    </main>
  );
}