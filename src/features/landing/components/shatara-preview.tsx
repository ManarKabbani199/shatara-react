'use client';

import Image from 'next/image';
import { HiPlay } from 'react-icons/hi';

export function ShataraPreview() {
  return (
    <section className="py-[70px] bg-white" dir="rtl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="bg-[#AB86B9] rounded-[24px] p-4 sm:p-6 shadow-xl">
          <div className="bg-white rounded-[16px] overflow-hidden flex flex-col lg:flex-row items-stretch">

            {/* Board Image Side */}
            <div className="relative w-full lg:flex-[2.5] aspect-square lg:aspect-auto lg:min-h-[380px] bg-[#E8DCC4] p-6">
              <Image
                src="/assets/images/shatttt.png"
                alt="لوحة شطارة"
                fill
                className="object-contain"
              />
            </div>

            {/* Content Side */}
            <div className="flex w-full lg:flex-[1] flex-col justify-center gap-4 p-6 sm:p-8 text-right border-t lg:border-t-0 lg:border-l border-gray-100">
              <h2 className="text-2xl sm:text-3xl font-bold text-[#6B4E45] leading-snug">
                جرّب لعبة شطارة الآن
              </h2>
              <p className="text-gray-500 text-sm sm:text-base font-medium leading-relaxed">
                لعبة ذهنية استراتيجية تعتمد على بناء القرار وإدارة القوة. تحدَّ
                أصدقاءك والعب مباشرة من متصفحك.
              </p>
              <a
                href="https://shatara.sa/play/"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center justify-center gap-2 mt-2 px-6 py-3.5 bg-[#AB86B9] hover:bg-[#AB86B9]/90 text-white font-bold text-sm sm:text-base rounded-xl shadow-md transition-colors self-start"
              >
                <HiPlay className="w-5 h-5" />
                <span>العب الآن</span>
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
