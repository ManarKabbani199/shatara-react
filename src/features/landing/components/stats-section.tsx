'use client';

import type React from 'react';
import Image from 'next/image';
import { HiOutlineUser, HiOutlineGlobeAlt, HiUserGroup } from 'react-icons/hi';

interface StatItem {
  label: string;
  value: string;
  icon: React.ComponentType<{ className?: string }>;
  isOnline?: boolean;
}

const stats: StatItem[] = [
  {
    label: 'متواجد حاليا',
    value: '12',
    icon: HiOutlineUser,
    isOnline: true,
  },
  {
    label: 'زائر',
    value: '128',
    icon: HiUserGroup,
  },
  {
    label: 'بلدا',
    value: '20',
    icon: HiOutlineGlobeAlt,
  },
];

export function StatsSection() {
  return (
    <section className="py-[70px] relative overflow-hidden bg-white" dir="rtl">
      {/* World Map Background */}
      <div className="absolute inset-0 flex items-center justify-center pointer-events-none overflow-hidden">
        <div className="relative w-full h-[600px] max-w-7xl opacity-90">
          <Image
            src="/assets/images/stat.png"
            alt="World Map"
            fill
            className="object-cover md:object-contain object-center"
          />
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 mt-12">
        <div className="flex flex-col md:flex-row items-center justify-between gap-12 md:gap-24">

          {/* Text Content */}
          <div className="md:w-auto text-right">
            <h2 className="text-3xl md:text-[40px] font-bold text-[#644B48] leading-snug">
              أرقامنا هي من تتحدث عنا
            </h2>
          </div>

          {/* Stats Grid */}
          <div className="flex-1 flex flex-row items-center justify-end gap-10 sm:gap-16 md:gap-20">
            {stats.map((stat) => {
              const Icon = stat.icon;
              return (
                <div key={stat.label} className="flex items-center gap-3">
                  {/* Icon Container (Right in RTL) */}
                  <div className="relative text-[#644B48]">
                    <Icon className="w-8 h-8 md:w-10 md:h-10" />
                    {stat.isOnline && (
                      <span className="absolute -bottom-0.5 -left-0.5 w-3 h-3 bg-[#06AC2A] border-2 border-white rounded-full"></span>
                    )}
                  </div>

                  {/* Text Container (Left in RTL) */}
                  <div className="flex flex-col text-right">
                    <span className="text-3xl md:text-[38px] font-bold text-[#644B48] leading-none">
                      {stat.value}
                    </span>
                    <span className="text-sm font-bold text-gray-500 mt-2">
                      {stat.label}
                    </span>
                  </div>
                </div>
              );
            })}
          </div>

        </div>
      </div>
    </section>
  );
}
