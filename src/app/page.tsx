import { LandingNavbar } from '@/features/landing/components/landing-navbar';
import { LandingHero } from '@/features/landing/components/landing-hero';
import { StatsSection } from '@/features/landing/components/stats-section';
import { RankingSection } from '@/features/landing/components/ranking-section';
import { ShataraPreview } from '@/features/landing/components/shatara-preview';
import { ProductsSection } from '@/features/landing/components/products-section';
import { GuideSection } from '@/features/landing/components/guide-section';
import { LandingFooter } from '@/features/landing/components/landing-footer';
import { VideoPopup } from '@/features/landing/components/video-popup';
import { WelcomeBanner } from '@/features/home/components/welcome-banner';
import VisitorTracker from '@/features/visitor/components/visitor-tracker';

export default function LandingPage() {
  return (
    <main className="flex-1 flex flex-col min-h-screen bg-white">
      <LandingNavbar />

      {/* تسجيل الزائر */}
      <VisitorTracker />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-4 sm:pt-6 w-full">
        <WelcomeBanner />
      </div>

      <div className="flex-1 relative">
        <LandingHero />
        <StatsSection />
        <RankingSection />
        <ShataraPreview />
        <ProductsSection />
        <GuideSection />
      </div>

      <LandingFooter />

      {/* نافذة الفيديو الترحيبية */}
      <VideoPopup />
    </main>
  );
}