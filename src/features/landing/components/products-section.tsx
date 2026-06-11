'use client';

import { useRef, useState, useEffect, useCallback } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { HiShoppingCart, HiChevronLeft, HiChevronRight } from 'react-icons/hi';
import { URLS } from '@/config/constants';

interface Product {
  id: number;
  name: string;
  originalPrice: number;
  price: number;
  discount: number;
  image: string | null;
}

const products: Product[] = [
  { id: 1, name: 'شطرنج شطارة', originalPrice: 349.99, price: 249.99, discount: 30, image: '/assets/images/piece0.png' },
  { id: 2, name: 'شطرنج شطارة', originalPrice: 349.99, price: 249.99, discount: 30, image: '/assets/images/piece0.png' },
  { id: 3, name: 'شطرنج شطارة', originalPrice: 349.99, price: 249.99, discount: 30, image: '/assets/images/piece0.png' },
  { id: 4, name: 'شطرنج شطارة', originalPrice: 349.99, price: 249.99, discount: 30, image: '/assets/images/piece0.png' },
  { id: 5, name: 'شطرنج شطارة', originalPrice: 349.99, price: 249.99, discount: 30, image: '/assets/images/piece0.png' },
];

export function ProductsSection() {
  const scrollRef = useRef<HTMLDivElement>(null);
  const [hoveredId, setHoveredId] = useState<number | null>(null);
  const [canScrollPrev, setCanScrollPrev] = useState(false);
  const [canScrollNext, setCanScrollNext] = useState(true);

  const updateScrollState = useCallback(() => {
    const el = scrollRef.current;
    if (!el) return;
    // In RTL, scrollLeft can be negative in some browsers
    const scrollLeft = Math.abs(el.scrollLeft);
    const maxScroll = el.scrollWidth - el.clientWidth;
    setCanScrollPrev(scrollLeft > 8);
    setCanScrollNext(scrollLeft < maxScroll - 8);
  }, []);

  useEffect(() => {
    const el = scrollRef.current;
    if (!el) return;
    updateScrollState();
    el.addEventListener('scroll', updateScrollState, { passive: true });
    return () => el.removeEventListener('scroll', updateScrollState);
  }, [updateScrollState]);

  const scroll = (direction: 'prev' | 'next') => {
    if (!scrollRef.current) return;
    const amount = 260;
    scrollRef.current.scrollBy({
      left: direction === 'prev' ? amount : -amount,
      behavior: 'smooth',
    });
  };

  return (
    <section className="py-[80px] bg-white" dir="rtl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

        {/* Top row: heading right, cards left */}
        <div className="flex flex-col lg:flex-row items-start gap-8 lg:gap-12">

          {/* ── Heading column (right in RTL) ── */}
          <div className="lg:w-[260px] xl:w-[300px] flex-shrink-0 text-right lg:pt-4">
            <h2 className="text-[2.2rem] font-normal leading-[1.4] text-[#6B4E45]">
              إكتشف
              <div className="flex items-center justify-start gap-2 text-[#AB86B9] my-1">
                <img
                  src="/assets/images/Frame 1000008188.png"
                  alt="لوجو"
                  className="h-[1.1em] w-auto object-contain inline-block"
                />
              </div>
              المميزة
            </h2>

            <Link
              href="/store"
              className="inline-flex items-center gap-1 mt-4 text-base font-bold text-[#AB86B9] border-b border-[#AB86B9] pb-0.5 hover:text-[#6B4E45] hover:border-[#6B4E45] transition-all"
            >
              <span>إلى المتجر</span>
              <span className="text-xs">↗</span>
            </Link>
          </div>

          {/* ── Scrollable cards (left of heading in RTL) ── */}
          <div className="flex-1 min-w-0 overflow-hidden">
            <div
              ref={scrollRef}
              className="flex gap-5 overflow-x-auto snap-x snap-mandatory pb-2"
              style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
            >
              {products.map((product) => (
                <div
                  key={product.id}
                  data-card
                  className="flex-shrink-0 w-[200px] sm:w-[220px] snap-start"
                  onMouseEnter={() => setHoveredId(product.id)}
                  onMouseLeave={() => setHoveredId(null)}
                >
                  <div
                    className="relative rounded-[18px] overflow-hidden bg-cover bg-center cursor-pointer shadow-md hover:shadow-xl transition-all duration-300 hover:-translate-y-1 flex flex-col h-[270px] sm:h-[290px]"
                    style={{ backgroundImage: "url('/assets/images/backg.png')" }}
                  >

                    {product.discount > 0 && (
                      <div className="absolute top-3 right-3 z-10 bg-red-500 text-white text-[10px] font-bold px-2.5 py-1 rounded-full shadow-md">
                        %{product.discount} خصم
                      </div>
                    )}

                    <div className="relative w-full aspect-square bg-transparent overflow-hidden p-2 flex-shrink-0">
                      {product.image ? (
                        <Image
                          src={product.image}
                          alt={product.name}
                          fill
                          className="object-contain transition-transform duration-500 scale-110"
                        />
                      ) : (
                        <div className="absolute inset-0 flex items-end justify-center pb-8">
                          <div className="absolute bottom-10 left-1/2 -translate-x-1/2 w-24 h-6 bg-[#AB86B9]/10 blur-xl rounded-full" />
                          <span className="text-[#AB86B9]/25 text-[80px] leading-none select-none">
                            ♟
                          </span>
                        </div>
                      )}
                    </div>

                    <div className="px-3 pb-3 pt-0.5 flex flex-col flex-1 justify-between text-right">
                      <h3 className="text-white font-bold text-xs leading-snug">
                        {product.name}
                      </h3>
                      <div className="flex items-center justify-between gap-1 flex-row-reverse mt-1">
                        {/* Add to Cart button (Right in RTL flex-row-reverse, or physically on the right side) */}
                        <a
                          href={URLS.store}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="inline-flex items-center justify-center gap-1 px-2.5 py-1.5 bg-[#AB86B9] hover:bg-[#9a73a8] text-white text-[9.5px] font-bold rounded-lg transition-all shadow-sm shrink-0"
                        >
                          <HiShoppingCart className="w-3 h-3" />
                          <span>أضف للسلة</span>
                        </a>

                        {/* Pricing (Left in RTL flex-row-reverse, or physically on the left side) */}
                        <div className="flex flex-col text-right justify-center">
                          <span className="text-gray-400 text-[8.5px] font-bold line-through leading-tight">
                            {product.originalPrice.toFixed(2)} ر.س
                          </span>
                          <span className="text-white text-[12px] font-extrabold leading-none mt-0.5">
                            {product.price.toFixed(2)} ر.س
                          </span>
                        </div>
                      </div>
                    </div>

                  </div>
                </div>
              ))}
            </div>
          </div>

        </div>

        {/* ── Navigation arrows — centered below ── */}
        <div className="flex items-center justify-center gap-3 mt-8">
          {/* Prev (right arrow) — active when we can scroll back */}
          <button
            onClick={() => scroll('prev')}
            aria-label="السابق"
            disabled={!canScrollPrev}
            className={`w-10 h-10 rounded-full flex items-center justify-center active:scale-95 transition-all ${canScrollPrev
              ? 'bg-[#AB86B9] text-white shadow-md hover:bg-[#9a73a8]'
              : 'bg-gray-100 text-gray-300 cursor-not-allowed'
              }`}
          >
            <HiChevronRight className="w-5 h-5" />
          </button>
          {/* Next (left arrow) — active when we can scroll forward */}
          <button
            onClick={() => scroll('next')}
            aria-label="التالي"
            disabled={!canScrollNext}
            className={`w-10 h-10 rounded-full flex items-center justify-center active:scale-95 transition-all ${canScrollNext
              ? 'bg-[#AB86B9] text-white shadow-md hover:bg-[#9a73a8]'
              : 'bg-gray-100 text-gray-300 cursor-not-allowed'
              }`}
          >
            <HiChevronLeft className="w-5 h-5" />
          </button>
        </div>

      </div>
    </section>
  );
}
