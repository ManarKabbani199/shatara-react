'use client';

import type React from 'react';
import Image from 'next/image';

export function LandingHero() {
  return (
    <section className="relative pt-12 pb-16 overflow-hidden bg-white" dir="rtl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-20">
        <div className="text-center space-y-6 anim-fade-up">
          {/* Saudi Patent Badge */}
          <div className="inline-flex items-center px-2 py-1 bg-white text-[#4A8564] border border-[#4A8564] shadow-sm">
            <span className="text-[13px] font-bold">براءة اختراع سعودية</span>
            <div className="mr-2 w-5 h-4 bg-[#4A8564] flex items-center justify-center">
              <span className="text-[8px] text-white font-bold">SA</span>
            </div>
          </div>

          {/* Heading */}
          <h1 className="text-4xl md:text-[52px] font-bold text-[#644B48] leading-[1.2] max-w-5xl mx-auto tracking-tight">
            المعركة بدأت، وجيشك بانتظار أوامرك
          </h1>

          {/* Description */}
          <div className="max-w-2xl mx-auto">
            <p className="text-lg text-gray-500 font-medium leading-relaxed">
              اختبر شطارتك في أقوى تجربة شطارة عالمية ومجتمع متكامل
              <br className="hidden md:block" />
              للتواصل معه.
            </p>
          </div>

          {/* CTA Button */}
          <div className="flex justify-center pt-4">
            <a
              href="https://shatara.sa/play/"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-3 px-8 py-3 bg-[#AB86B9] text-white text-lg font-bold shadow hover:bg-[#AB86B9]/90 transition-all rounded-xl"
            >
              <Image
                src="/assets/images/Group.png"
                alt="شعار اللعب"
                width={20}
                height={20}
                className="w-5 h-5 object-contain"
              />
              <span>إلعب الآن</span>
            </a>
          </div>
        </div>
      </div>

      {/* Hero Image Area - Carefully blending the sides and bottom */}
      <div className="relative w-full h-[320px] sm:h-[420px] md:h-[750px] lg:h-[850px] -mt-12 sm:-mt-16 md:-mt-32 lg:-mt-40 anim-fade-up">
        {/* Subtle Edge Overlays */}
        <div className="absolute inset-0 z-10 pointer-events-none">
          {/* Top fade to blend with content above */}
          <div className="absolute inset-x-0 top-0 h-32 bg-gradient-to-b from-white to-transparent" />
          {/* Bottom fade */}
          <div className="absolute inset-x-0 bottom-0 h-20 bg-gradient-to-t from-white to-transparent" />
          {/* Side fades - Wider to blend the shatara board edges */}
          <div className="absolute inset-y-0 left-0 w-24 md:w-48 bg-gradient-to-r from-white to-transparent" />
          <div className="absolute inset-y-0 right-0 w-24 md:w-48 bg-gradient-to-l from-white to-transparent" />
        </div>

        <div className="relative w-full h-full">
          <Image
            src="/assets/images/looog.png"
            alt="شطارة"
            fill
            className="object-contain object-center"
            priority
          />
        </div>
      </div>
    </section>
  );
}
