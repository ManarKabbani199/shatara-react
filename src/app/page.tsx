import { LandingNavbar } from '@/features/landing/components/landing-navbar';
import { LandingHero } from '@/features/landing/components/landing-hero';
import { StatsSection } from '@/features/landing/components/stats-section';
import { RankingSection } from '@/features/landing/components/ranking-section';
import { ShataraPreview } from '@/features/landing/components/shatara-preview';
import { ProductsSection } from '@/features/landing/components/products-section';
import { GuideSection } from '@/features/landing/components/guide-section';
import { LandingFooter } from '@/features/landing/components/landing-footer';
import { VisitorTracker } from '@/features/visitor/components/visitor-tracker';
import { VideoPopup } from '@/features/landing/components/video-popup';

export default function LandingPage() {
  return (
    <main className="flex-1 flex flex-col min-h-screen bg-white">
      <LandingNavbar />
      <VisitorTracker />

      <div className="flex-1 relative">
        <LandingHero />
        <StatsSection />
        <RankingSection />
        <ShataraPreview />
        <ProductsSection />
        <GuideSection />
      </div>

      <LandingFooter />

      {/* Auto-play intro video popup — shown once per session */}
      <VideoPopup />
    </main>
  );
}
