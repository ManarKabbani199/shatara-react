'use client';

import dynamic from 'next/dynamic';

const JoinGuideSection = dynamic(
  () => import('@/features/home/components/join-guide-section').then((mod) => mod.JoinGuideSection),
  {
    ssr: false,
    loading: () => (
      <div className="w-full bg-surface-light py-4 sm:py-6 px-3 sm:px-4 md:px-6" dir="rtl">
        <div className="max-w-6xl mx-auto flex flex-col lg:flex-row gap-3 sm:gap-4">
          <div className="flex-[7] h-80 sm:h-96 rounded-xl sm:rounded-2xl bg-brand-brown/5 animate-pulse" />
          <div className="flex-[5] h-80 sm:h-96 rounded-xl sm:rounded-2xl bg-brand-brown/5 animate-pulse" />
        </div>
      </div>
    ),
  },
);

export function JoinGuideSectionWrapper() {
  return <JoinGuideSection />;
}
