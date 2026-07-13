import Image from 'next/image';
import { URLS } from '@/config/constants';

const STORE_IMAGES = [
  { src: '/assets/images/st1.png', alt: 'منتج شطارة 1' },
  { src: '/assets/images/st2.png', alt: 'منتج شطارة 2' },
  { src: '/assets/images/st3.png', alt: 'منتج شطارة 3' },
  { src: '/assets/images/st4.png', alt: 'منتج شطارة 4' },
];

export function StoreSection() {
  return (
    <section className="w-full min-w-0" dir="rtl">
      <div className="flex items-center justify-between mb-3 px-1 anim-fade-up gap-2">
        <div className="flex items-center gap-2">
          <img
            src="/assets/images/iconh.png"
            alt="أيقونة المتجر"
            width="20"
            height="20"
            className="w-auto"
            style={{ height: '20px', display: 'block' }}
          />
          <h2 className="text-brand-brown font-bold text-base md:text-lg font-alexandria">
            متجر شطاره
          </h2>
        </div>

        <a
          href={URLS.store}
          target="_blank"
          rel="noopener noreferrer"
          aria-label="زيارة المتجر"
          className="inline-block transition-transform hover:scale-105 active:scale-95"
        >
          <img
            src="/assets/images/btnstore.png"
            alt="زر المتجر"
            width="96"
            height="30"
            className="w-auto"
            style={{ height: '30px', display: 'block' }}
          />
        </a>
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-2 sm:gap-3 anim-stagger">
        {STORE_IMAGES.map((img, idx) => (
          <div
            key={idx}
            className="aspect-square overflow-hidden rounded-lg sm:rounded-xl bg-surface-light shadow-sm hover-lift cursor-pointer"
          >
            <Image
              src={img.src}
              alt={img.alt}
              width={300}
              height={300}
              className="w-full h-full object-contain p-1.5 sm:p-2"
              loading="lazy"
            />
          </div>
        ))}
      </div>
    </section>
  );
}