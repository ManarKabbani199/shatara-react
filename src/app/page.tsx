import { Navbar } from '@/components/layout/navbar';
import { Footer } from '@/components/layout/footer';
import { HeroSection } from '@/features/home/components/hero-section';
import { StoreSection } from '@/features/home/components/store-section';
import { JoinGuideSectionWrapper } from '@/features/home/components/join-guide-section-wrapper';

export default function RootPage() {
  return (
    <div className="min-h-screen flex flex-col bg-[#EFF3F7]">
      <Navbar />
      <main className="flex-1 flex flex-col">
        <div className="flex flex-col gap-4 px-4 md:px-6 py-4 max-w-6xl mx-auto w-full">
          <HeroSection />
          <StoreSection />
          <JoinGuideSectionWrapper />
        </div>
      </main>
      <Footer />
    </div>
  );
}
