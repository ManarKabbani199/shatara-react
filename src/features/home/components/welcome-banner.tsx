'use client';

import { useAuth } from '@/features/auth/hooks/use-auth';

export function WelcomeBanner() {
  const { user, isLoading, isLoggedIn } = useAuth();

  if (isLoading || !isLoggedIn || !user?.name) {
    return null;
  }

  return (
    <section
      className="w-full rounded-2xl bg-white border border-brand-brown/10 shadow-lg shadow-brand-brown/10 px-5 py-4 anim-fade-up"
      dir="rtl"
      style={{ '--anim-delay': '0s' } as React.CSSProperties}
    >
      <div className="flex items-center gap-3">
        <span className="inline-flex items-center justify-center w-10 h-10 rounded-full bg-brand-purple/15 text-brand-purple font-bold text-lg shrink-0">
          {user.name.charAt(0)}
        </span>
        <div className="flex flex-col">
          <h2 className="text-brand-brown font-bold text-base md:text-lg leading-tight">
            مرحباً، {user.name}!
          </h2>
          <p className="text-text-secondary text-sm leading-snug">
            سعداء بعودتك إلى شطارة.
          </p>
        </div>
      </div>
    </section>
  );
}
