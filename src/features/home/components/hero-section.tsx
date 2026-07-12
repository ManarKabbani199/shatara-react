'use client';

import { useRef, useEffect } from 'react';

export function HeroSection() {
  const videoRef = useRef<HTMLVideoElement>(null);

  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;
    video.play().catch(() => { /* autoplay blocked */ });
  }, []);

  return (
    <section className="w-full min-w-0" dir="rtl" style={{ '--anim-delay': '0.05s' } as React.CSSProperties}>
      <div className="relative overflow-hidden rounded-xl sm:rounded-2xl shadow-xl shadow-brand-brown/15 anim-fade-up">
        <video
          ref={videoRef}
          className="w-full aspect-[4/3] sm:aspect-video object-cover"
          poster="/assets/images/hero.png"
          autoPlay
          muted
          loop
          playsInline
          preload="metadata"
        >
          <source src="/assets/videos/ismall.mp4" type="video/mp4" />
        </video>

        {/* Desktop overlay */}
        <div className="hidden md:block absolute inset-0 bg-gradient-to-t from-black/60 via-black/10 to-transparent pointer-events-none" />
        <div className="hidden md:block absolute bottom-0 start-0 end-0 p-4 md:p-6">
          <p className="text-white font-bold text-sm md:text-base lg:text-lg leading-relaxed font-alexandria drop-shadow-lg">
            شطارة لعبة ذهنية استراتيجية مبتكرة، تعتمد على بناء القرار و إدارة القوة داخل بيئة لعب منضبطة.
          </p>
        </div>
      </div>

      {/* Mobile description card */}
      <div className="md:hidden mt-3 rounded-xl sm:rounded-2xl bg-white/95 backdrop-blur-sm border border-brand-brown/10 p-3 sm:p-4 shadow-lg shadow-brand-brown/10">
        <p className="text-brand-brown font-bold text-xs sm:text-sm leading-relaxed font-alexandria">
          شطارة لعبة ذهنية استراتيجية مبتكرة، تعتمد على بناء القرار و إدارة القوة داخل بيئة لعب منضبطة.
        </p>
      </div>
    </section>
  );
}