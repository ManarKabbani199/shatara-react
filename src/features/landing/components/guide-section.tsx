'use client';

import { HiDownload } from 'react-icons/hi';
import { URLS } from '@/config/constants';

export function GuideSection() {
  return (
    <section
      className="relative min-h-[600px] sm:min-h-[700px] bg-black bg-cover bg-center bg-no-repeat overflow-hidden flex items-center justify-center p-4 sm:p-8 lg:p-12"
      dir="rtl"
      style={{
        backgroundImage: "url('/assets/images/19 1.png')",
      }}
    >
      <div className="relative w-full max-w-6xl">
        <div className="bg-[#F5F3F0] rounded-3xl shadow-2xl overflow-hidden flex flex-col">
          {/* Header */}
          <div className="flex items-center justify-between gap-4 bg-[#1F1F1F] px-5 sm:px-8 py-4 sm:py-5 flex-shrink-0">
            <h2 className="text-xl sm:text-2xl lg:text-3xl font-bold text-white">
              دليل شطارة
            </h2>
            <a
              href={URLS.guide}
              download
              className="inline-flex items-center gap-2 px-4 sm:px-6 py-2 sm:py-2.5 bg-[#06AC2A] hover:bg-[#059622] text-white text-sm sm:text-base font-bold rounded-xl transition-colors shadow-lg"
            >
              <HiDownload className="w-4 h-4 sm:w-5 sm:h-5" />
              <span>تحميل</span>
            </a>
          </div>

          {/* Full PDF viewer */}
          <div className="rounded-b-3xl overflow-hidden border border-[#E8E4DE] bg-[#F5F3F0]">
            <iframe
              src={URLS.guide}
              title="دليل شطارة الكامل"
              className="w-full h-[50vh] sm:h-[60vh] md:h-[75vh] min-h-[300px] sm:min-h-[400px]"
              loading="lazy"
            />
            <p className="text-center text-xs sm:text-sm text-[#6B7280] py-3 px-4 bg-white">
              إذا لم يظهر الملف أعلاه، يمكنك{' '}
              <a
                href={URLS.guide}
                target="_blank"
                rel="noopener noreferrer"
                className="text-[#06AC2A] font-semibold hover:underline"
              >
                فتحه في نافذة جديدة
              </a>{' '}
              أو{' '}
              <a
                href={URLS.guide}
                download
                className="text-[#06AC2A] font-semibold hover:underline"
              >
                تحميله
              </a>
              .
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}
