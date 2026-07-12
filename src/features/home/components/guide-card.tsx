'use client';

import { useState, useEffect, useRef } from 'react';
import { URLS } from '@/config/constants';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { MdMenuBook, MdDownload, MdOpenInNew } from 'react-icons/md';

export function GuideCard() {
  const [isVisible, setIsVisible] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
          observer.disconnect();
        }
      },
      { rootMargin: '200px' },
    );

    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  const handleDownload = () => {
    window.open(URLS.guide, '_blank');
  };

  return (
    <div
      ref={ref}
      className="anim-fade-right min-w-0"
      style={{ '--anim-delay': '0.35s' } as React.CSSProperties}
    >
      <Card className="overflow-hidden hover-lift">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 px-3 py-2.5">
          <div className="flex items-center gap-1.5 shrink-0">
            <MdMenuBook className="w-4 h-4 text-brand-brown" />
            <h3 className="text-brand-brown font-bold text-xs font-alexandria">
              دليل شطارة
            </h3>
          </div>

          <div className="flex items-center gap-2 w-full sm:w-auto">
            <a
              href={URLS.store}
              target="_blank"
              rel="noopener noreferrer"
              className="flex-1 sm:flex-initial px-3 py-1.5 rounded-xl bg-[#AB86B9] text-white font-bold text-xs shadow-sm hover:bg-[#AB86B9]/90 transition-all flex items-center justify-center gap-1"
            >
              متجر شطارة
            </a>

            <Button
              variant="green"
              size="sm"
              onClick={handleDownload}
              className="flex-1 sm:flex-initial rounded-xl px-3 py-1.5 text-xs pulse-glow"
            >
              <MdDownload className="w-4 h-4 ms-1" />
              تحميل
            </Button>
          </div>
        </div>

        {/* Desktop: iframe preview */}
        <div className="hidden md:block mt-3 rounded-xl overflow-hidden shadow-inner">
          {isVisible ? (
            <iframe
              src={URLS.guide}
              className="w-full border-0"
              style={{ height: '560px' }}
              title="دليل شطارة"
              loading="lazy"
            />
          ) : (
            <div
              className="w-full flex items-center justify-center bg-surface-light rounded-xl"
              style={{ height: '560px' }}
            >
              <div className="text-center text-brand-brown/60">
                <MdMenuBook className="w-12 h-12 mx-auto mb-2" />
                <p className="text-sm font-alexandria">جارٍ تحميل الدليل...</p>
              </div>
            </div>
          )}
        </div>

        {/* Mobile: clean card UI instead of iframe */}
        <div className="md:hidden mt-3 rounded-xl bg-gradient-to-br from-brand-purple/10 to-brand-brown/5 p-4">
          <div className="flex flex-col items-center text-center gap-3">
            <div className="w-16 h-16 rounded-2xl bg-white shadow-md flex items-center justify-center">
              <MdMenuBook className="w-8 h-8 text-brand-purple" />
            </div>
            <div>
              <p className="text-brand-brown font-bold text-sm font-alexandria mb-1">
                دليل لعبة شطارة
              </p>
              <p className="text-text-secondary text-xs font-alexandria leading-relaxed">
                اكتشف قوانين اللعبة واستراتيجيات الفوز بالتفصيل
              </p>
            </div>
            <Button
              variant="green"
              size="sm"
              onClick={handleDownload}
              className="rounded-xl px-5 py-2 text-sm pulse-glow w-full"
            >
              <MdOpenInNew className="w-4 h-4 ms-1" />
              فتح الدليل
            </Button>
          </div>
        </div>
      </Card>
    </div>
  );
}
