'use client';

import Image from 'next/image';
import { HiChevronDown } from 'react-icons/hi';

export function ShataraPreview() {
  return (
    <section className="py-[70px] bg-white" dir="rtl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 gap-[25px]">

          {/* Shatara Board Preview */}
          <div className="bg-[#AB86B9] rounded-[24px] p-4 sm:p-6 shadow-xl">
            <div className="bg-white rounded-[16px] overflow-hidden flex flex-col lg:flex-row">

              {/* Shatara Board Side */}
              <div className="w-full lg:flex-[2.5] flex flex-col bg-[#AB86B9]">
                {/* Top Player Info */}
                <div className="px-4 py-2.5 flex justify-between items-center text-white text-[11px] font-bold">
                  <div className="flex items-center gap-2">
                    <span className="opacity-80">IM 2343</span>
                    <span>Caissaisabelle</span>
                  </div>
                  <span className="bg-white/20 px-2 py-0.5 rounded">1:43</span>
                </div>

                {/* Board Image (Square on mobile) */}
                <div className="relative aspect-square lg:aspect-auto lg:flex-1 bg-[#E8DCC4] p-3">
                  <div className="relative w-full h-full">
                    <Image
                      src="/assets/images/shatttt.png"
                      alt="لوحة شطارة"
                      fill
                      className="object-contain"
                    />
                  </div>
                </div>

                {/* Bottom Player Info */}
                <div className="px-4 py-2.5 flex justify-between items-center text-white text-[11px] font-bold">
                  <span className="bg-white/20 px-2 py-0.5 rounded">1:43</span>
                  <div className="flex items-center gap-2">
                    <span>Caissaisabelle</span>
                    <span className="opacity-80">IM 2343</span>
                  </div>
                </div>
              </div>

              {/* Moves List Side */}
              <div className="flex w-full lg:flex-[1] flex-col bg-white border-t lg:border-t-0 lg:border-l border-gray-100">
                <div className="p-4 border-b border-gray-100">
                  <div className="flex items-center justify-between">
                    <button className="text-[10px] font-bold bg-white px-2 py-1 rounded border border-gray-200 text-gray-500 flex items-center gap-1 shadow-sm">
                      <HiChevronDown className="w-3 h-3" />
                      <span>بليتز</span>
                    </button>
                    <span className="text-xs font-bold text-gray-600">مباريات قائمة الآن</span>
                  </div>
                </div>
                <div className="max-h-[250px] lg:max-h-none lg:flex-1 overflow-y-auto">
                  {[1, 2, 3, 4, 5, 6, 7, 8].map((i) => (
                    <div
                      key={i}
                      className={`flex items-center justify-between px-5 py-3 text-[11px] font-bold transition-colors ${i % 2 === 0 ? 'bg-gray-50/80' : 'bg-white'
                        }`}
                    >
                      <span className="text-gray-400">32</span>
                      <span className="text-gray-600">Z2_123 {i}</span>
                    </div>
                  ))}
                </div>
                <div className="p-4 bg-white border-t border-gray-100 lg:border-t-0">
                  <button className="w-full py-2.5 rounded-lg bg-gray-100 text-gray-500 font-bold text-[11px] hover:bg-gray-200 transition-colors">
                    عرض الكل
                  </button>
                </div>
              </div>
            </div>

            {/* Bottom Actions */}
            <div className="mt-6 grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-6">
              <button className="bg-white text-gray-500 py-3 px-4 rounded-xl font-bold text-xs sm:text-sm hover:bg-gray-50 shadow-sm flex items-center justify-center gap-3 transition-colors">
                <span className="w-4 h-4 sm:w-5 sm:h-5 rounded border-2 border-[#AB86B9] bg-[#AB86B9]" />
                <span>تحدي أصدقائك</span>
              </button>
              <button className="bg-white text-gray-500 py-3 px-4 rounded-xl font-bold text-xs sm:text-sm hover:bg-gray-50 shadow-sm flex items-center justify-center gap-3 transition-colors">
                <span className="w-4 h-4 sm:w-5 sm:h-5 rounded border-2 border-[#AB86B9] bg-[#AB86B9]" />
                <span>تحدي أصدقائك</span>
              </button>
            </div>
          </div>

        </div>
      </div>
    </section>
  );
}
