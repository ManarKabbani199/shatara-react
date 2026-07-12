import { Navbar } from '@/components/layout/navbar';
import { Footer } from '@/components/layout/footer';
import { HeroSection } from '@/features/home/components/hero-section';
import { StoreSection } from '@/features/home/components/store-section';
import { JoinGuideSectionWrapper } from '@/features/home/components/join-guide-section-wrapper';
import { WelcomeBanner } from '@/features/home/components/welcome-banner';
import { UploadsGallery } from '@/features/home/components/uploads-gallery';

export default function HomePage() {
  return (
    <div className="min-h-screen flex flex-col bg-[#EFF3F7] overflow-x-hidden">
      <Navbar />
      <main className="flex-1 flex flex-col">
        <div className="flex flex-col gap-4 px-3 sm:px-4 md:px-6 py-3 sm:py-4 max-w-6xl mx-auto w-full min-w-0">
          <WelcomeBanner />
          <HeroSection />
          <UploadsGallery limit={5} />
          <StoreSection />
          <JoinGuideSectionWrapper />
        </div>
      </main>
      <Footer />
    </div>
  );
}
