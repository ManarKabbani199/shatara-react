'use client';

import { useAuth } from '@/features/auth/hooks/use-auth';

export function WelcomeBanner() {
  const { user, isLoading, isLoggedIn } = useAuth();

  const displayName = user?.name || user?.username;

  if (isLoading || !isLoggedIn || !displayName) {
    return null;
  }

  return (
    <section
      className="w-full min-w-0 rounded-xl sm:rounded-2xl bg-white border border-brand-brown/10 shadow-lg shadow-brand-brown/10 px-4 sm:px-5 py-3 sm:py-4 anim-fade-up"
      dir="rtl"
      style={{ '--anim-delay': '0s' } as React.CSSProperties}
    >
      <div className="flex items-center gap-3 min-w-0">
        <span className="inline-flex items-center justify-center w-9 h-9 sm:w-10 sm:h-10 rounded-full bg-brand-purple/15 text-brand-purple font-bold text-base sm:text-lg shrink-0">
          {displayName.charAt(0)}
        </span>
        <div className="flex flex-col min-w-0">
          <h2 className="text-brand-brown font-bold text-sm sm:text-base md:text-lg leading-tight truncate">
            أهلاً بك، {displayName}
          </h2>
          <p className="text-text-secondary text-xs sm:text-sm leading-snug">
            سعداء بعودتك إلى شطارة
          </p>
        </div>
      </div>
    </section>
  );
}
