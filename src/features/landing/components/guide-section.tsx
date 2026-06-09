'use client';

import { HiDownload } from 'react-icons/hi';

export function GuideSection() {
  return (
    <section
      className="relative py-[80px] overflow-hidden"
      dir="rtl"
      style={{
        background: 'linear-gradient(160deg, #0b1a10 0%, #0f2318 40%, #0a1a0d 100%)',
      }}
    >
      {/* Subtle background texture pattern */}
      <div
        className="absolute inset-0 opacity-[0.04] pointer-events-none"
        style={{
          backgroundImage: `repeating-linear-gradient(
            0deg, transparent, transparent 40px,
            rgba(255,255,255,0.6) 40px, rgba(255,255,255,0.6) 41px
          ), repeating-linear-gradient(
            90deg, transparent, transparent 40px,
            rgba(255,255,255,0.6) 40px, rgba(255,255,255,0.6) 41px
          )`,
        }}
      />

      <div className="relative max-w-2xl mx-auto px-4 sm:px-6">

        {/* White guide card */}
        <div className="bg-white rounded-[24px] shadow-2xl overflow-hidden">

          {/* Card header — title right, button left (RTL) */}
          <div className="flex items-center justify-between px-6 sm:px-8 pt-6 pb-5 border-b border-gray-100">
            {/* Title (first child = right in RTL) */}
            <h2 className="text-xl sm:text-2xl font-bold text-[#6B4E45]">
              دليل شطارة
            </h2>

            {/* Download button (second child = left in RTL) */}
            <a
              href="#"
              download
              className="inline-flex items-center gap-2 bg-[#06AC2A] hover:bg-[#059924] active:scale-95 text-white text-sm font-bold px-4 py-2 rounded-xl transition-all shadow-md"
            >
              <HiDownload className="w-4 h-4" />
              <span>تحميل</span>
            </a>
          </div>

          {/* Card body */}
          <div className="px-6 sm:px-8 py-6 space-y-6">

            {/* Intro text */}
            <div className="text-right space-y-2">
              <p className="text-sm font-bold text-gray-700 leading-relaxed">
                تعريف ميدان شطارة
              </p>
              <p className="text-xs text-gray-500 leading-[1.9] font-medium">
                ميدان شطارة هو لعبة ذات أبعاد استراتيجية تقوم على إدارة وبناء القوة عبر نظام تجزئي من خلال وجود منطقة داعم حيث تنقسم الرقعة إلى منطقة اللعب الرئيسية ومنطقة دعم خاصة بكل لاعب. تمارس اللعبة على رقعة هندسية ذات بنية هندسية محددة وباستخدام قطع لعب مصنفة إلى مراتب قوة متتابعة وتدار وفق مجموعة من القوانين التي تنظم الحركة، التمرير، التعزيز، والحسم.
              </p>
              <p className="text-xs text-gray-500 leading-[1.9] font-medium">
                وتُعدّ ميدان شطارة نظام لعب قائم بذاته له بنية ومفاهيم وقواعد وتعريف خاص مستقل ويتعامل في جميع استخداماته بوصفه لعبة ذهنية.
              </p>
            </div>

            {/* Divider */}
            <div className="border-t border-gray-100" />

            {/* Game components */}
            <div className="text-right space-y-3">
              <h3 className="text-base font-bold text-[#6B4E45]">
                مكونات اللعبة
              </h3>

              <div className="space-y-1">
                <p className="text-sm font-bold text-[#6B4E45]">الرقعة</p>
                <p className="text-xs text-gray-500 leading-[1.9] font-medium">
                  الرقعة هي الأساس الفيزيائي الذي تُمارس عليها لعبة ميدان شطارة، وتمثل المكان الذي تتم فيه جميع الحركات والمناورات والقرارات. تتألف من شبكة موحدة من المربعات تتكرر وفق نمط هندسي معين. يُميز بين المربعات بصرياً ما لا يلتبس التمييز بين المربعات الهندسية المختلفة في هذا الشأن.
                </p>
                <p className="text-xs text-gray-500 leading-[1.9] font-medium">
                  يُعدّ من أشكال الدليل الأنسب ربما ما يأتي في الاعتبار الأمثل للمواصفات الهندسية المستخدمة في هذا الشأن.
                </p>
              </div>
            </div>

            {/* Board diagram placeholder */}
            <div className="mt-2 rounded-2xl overflow-hidden border-2 border-gray-900 bg-gray-50">
              {/* Grid diagram — will be replaced by a real image */}
              <div className="relative w-full aspect-[4/3] flex items-center justify-center bg-gradient-to-br from-gray-50 to-gray-100">
                {/* SVG board grid placeholder */}
                <svg
                  viewBox="0 0 400 300"
                  className="w-full h-full p-6"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  {/* Outer border */}
                  <rect x="20" y="20" width="320" height="260" rx="4" stroke="#e5e7eb" strokeWidth="1" fill="white" />

                  {/* Grid lines — vertical */}
                  {Array.from({ length: 9 }).map((_, i) => (
                    <line
                      key={`v${i}`}
                      x1={20 + (i + 1) * 29}
                      y1="20"
                      x2={20 + (i + 1) * 29}
                      y2="280"
                      stroke="#e5e7eb"
                      strokeWidth="1"
                    />
                  ))}

                  {/* Grid lines — horizontal */}
                  {Array.from({ length: 8 }).map((_, i) => (
                    <line
                      key={`h${i}`}
                      x1="20"
                      y1={20 + (i + 1) * 29}
                      x2="340"
                      y2={20 + (i + 1) * 29}
                      stroke="#e5e7eb"
                      strokeWidth="1"
                    />
                  ))}

                  {/* Highlighted squares (sample) */}
                  {[[2, 2], [3, 5], [5, 3], [7, 6]].map(([col, row], i) => (
                    <rect
                      key={`s${i}`}
                      x={20 + col * 29}
                      y={20 + row * 29}
                      width="29"
                      height="29"
                      fill="#AB86B9"
                      fillOpacity="0.15"
                    />
                  ))}

                  {/* Red marker (like in the screenshot) */}
                  <rect x="290" y="130" width="29" height="29" fill="#ef4444" fillOpacity="0.2" stroke="#ef4444" strokeWidth="1" />
                  <rect x="260" y="160" width="29" height="29" fill="#ef4444" fillOpacity="0.2" stroke="#ef4444" strokeWidth="1" />

                  {/* Dimension lines */}
                  <line x1="20" y1="290" x2="340" y2="290" stroke="#9ca3af" strokeWidth="1" markerEnd="url(#arrow)" />
                  <text x="180" y="298" textAnchor="middle" fill="#9ca3af" fontSize="8" fontFamily="sans-serif">10 مربعات</text>
                </svg>
              </div>
            </div>

          </div>
        </div>

      </div>
    </section>
  );
}
