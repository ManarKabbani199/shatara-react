'use client';

import Image from 'next/image';
import Link from 'next/link';
import { HiGlobeAlt, HiChevronDown } from 'react-icons/hi';

interface Player {
  id: number;
  name: string;
  handle: string;
  rank: string;
  color: string;
}

const leaderboard: Player[] = [
  { id: 1, name: 'Nour', handle: '@nour_off', rank: '#1', color: 'bg-[#AB86B9]' },
  { id: 2, name: 'Nour', handle: '@nour_off', rank: '#2', color: 'bg-[#E57373]' },
  { id: 3, name: 'Nour', handle: '@nour_off', rank: '#3', color: 'bg-[#8D6E63]' },
  { id: 4, name: 'Nour', handle: '@nour_off', rank: '#4', color: 'bg-[#F2F2F2]' },
  { id: 5, name: 'Nour', handle: '@nour_off', rank: '#5', color: 'bg-[#F2F2F2]' },
  { id: 6, name: 'Nour', handle: '@nour_off', rank: '#6', color: 'bg-[#F2F2F2]' },
];

export function ShataraPreview() {
  return (
    <section className="py-[70px] bg-white" dir="rtl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-[25px] items-start">

          {/* Right Column: Shatara Board Preview */}
          <div className="lg:col-span-8 bg-[#AB86B9] rounded-[24px] p-4 sm:p-6 shadow-xl">
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

          {/* Left Column: Leaderboard */}
          <div className="lg:col-span-4 bg-[#F8F9FA] rounded-[24px] p-6">
            <div className="flex items-center justify-between mb-8">
              {/* Filter: بليتز (Right in RTL) */}
              <button className="px-3 py-1.5 rounded-lg text-sm font-bold bg-white text-gray-700 border border-gray-100 flex items-center gap-2 shadow-sm">
                <span>بليتز</span>
                <HiChevronDown className="w-4 h-4 text-gray-400" />
              </button>
              {/* Filter: عالمي (Left in RTL) */}
              <button className="px-4 py-1.5 rounded-lg text-sm font-bold bg-white text-gray-700 border border-gray-100 flex items-center gap-2 shadow-sm">
                <span>عالمي</span>
                <HiGlobeAlt className="w-4 h-4 text-gray-400" />
              </button>
            </div>

            <div className="space-y-3">
              {leaderboard.map((player) => (
                <div key={player.id} className="bg-white p-3 rounded-xl flex items-center justify-between border border-gray-100 shadow-sm">
                  {/* Right Group (Rank and Name in RTL) */}
                  <div className="flex items-center gap-3">
                    <div className={`${player.color} ${player.id > 3 ? 'text-gray-400' : 'text-white'} text-[11px] font-bold px-2.5 py-1 rounded-md min-w-[36px] text-center`}>
                      {player.rank}
                    </div>
                    <div className="text-right">
                      <div className="font-bold text-gray-800 text-sm leading-tight">{player.name}</div>
                      <div className="text-[10px] text-gray-400 font-bold">{player.handle}</div>
                    </div>
                  </div>

                  {/* Left Group (Icons in RTL) */}
                  <div className="flex items-center gap-2">
                    {/* Saudi Flag Icon (Closer to name) */}
                    <div className="w-8 h-8 rounded bg-[#06AC2A] flex items-center justify-center overflow-hidden">
                      <Image src="/assets/images/Country flags.png" alt="KSA" width={24} height={16} className="object-contain" />
                    </div>
                    {/* Avatar Icon (Outer left) */}
                    <div className="w-8 h-8 rounded-lg bg-gray-50 flex items-center justify-center border border-gray-100">
                      <Image src="/assets/images/trophy-dynamic-color.png" alt="" width={18} height={18} />
                    </div>
                  </div>
                </div>
              ))}
            </div>

            <button className="w-full mt-6 py-3 rounded-xl bg-gray-200 text-gray-400 font-bold text-xs hover:bg-gray-300 transition-colors">
              عرض الكل
            </button>
          </div>

        </div>
      </div>
    </section>
  );
}
