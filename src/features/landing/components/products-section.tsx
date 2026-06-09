'use client';

import { useRef, useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { HiShoppingCart, HiChevronLeft, HiChevronRight } from 'react-icons/hi';

interface Product {
  id: number;
  name: string;
  originalPrice: number;
  price: number;
  discount: number;
  image: string | null;
}

const products: Product[] = [
  { id: 1, name: 'شطرنج شطارة', originalPrice: 349.99, price: 249.99, discount: 30, image: null },
  { id: 2, name: 'شطرنج شطارة', originalPrice: 349.99, price: 249.99, discount: 30, image: null },
  { id: 3, name: 'شطرنج شطارة', originalPrice: 349.99, price: 249.99, discount: 30, image: null },
  { id: 4, name: 'شطرنج شطارة', originalPrice: 349.99, price: 249.99, discount: 30, image: null },
  { id: 5, name: 'شطرنج شطارة', originalPrice: 349.99, price: 249.99, discount: 30, image: null },
];

export function ProductsSection() {
  const scrollRef = useRef<HTMLDivElement>(null);
  const [hoveredId, setHoveredId] = useState<number | null>(null);

  const scroll = (direction: 'prev' | 'next') => {
    if (!scrollRef.current) return;
    // RTL: prev = scroll right (positive), next = scroll left (negative)
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
            <h2 className="text-[2rem] sm:text-[2.4rem] font-bold leading-[1.4] text-[#6B4E45]">
              إكتشف منتجات
              <br />
              <span className="text-[#AB86B9]">شطارة ♞</span>
              <br />
              المميزة
            </h2>

            <Link
              href="/store"
              className="inline-flex items-center gap-1.5 mt-3 text-sm font-bold text-[#AB86B9] hover:text-[#6B4E45] transition-colors group"
            >
              <span>إلى المتجر</span>
              <HiChevronLeft className="w-4 h-4 group-hover:-translate-x-0.5 transition-transform" />
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
                  <div className="relative rounded-[18px] overflow-hidden bg-[#10101e] cursor-pointer shadow-md hover:shadow-xl transition-all duration-300 hover:-translate-y-1">

                    {/* Discount badge */}
                    {product.discount > 0 && (
                      <div className="absolute top-3 right-3 z-10 bg-red-500 text-white text-[10px] font-bold px-2.5 py-1 rounded-full shadow-md">
                        %{product.discount} خصم
                      </div>
                    )}

                    {/* Image area */}
                    <div className="relative w-full aspect-square bg-gradient-to-b from-[#0c0c1d] via-[#181830] to-[#0a0a18] overflow-hidden">
                      {product.image ? (
                        <Image
                          src={product.image}
                          alt={product.name}
                          fill
                          className="object-cover transition-transform duration-500 group-hover:scale-105"
                        />
                      ) : (
                        /* Chess piece placeholder — replace with real product image via product.image */
                        <div className="absolute inset-0 flex items-end justify-center pb-8">
                          {/* Faint glow under piece */}
                          <div className="absolute bottom-10 left-1/2 -translate-x-1/2 w-24 h-6 bg-[#AB86B9]/10 blur-xl rounded-full" />
                          <span className="text-[#AB86B9]/25 text-[80px] leading-none select-none">
                            ♟
                          </span>
                        </div>
                      )}

                      {/* "أضف للسلة" — slides up on hover */}
                      <div
                        className={`absolute inset-x-3 bottom-3 transition-all duration-300 ${
                          hoveredId === product.id
                            ? 'opacity-100 translate-y-0'
                            : 'opacity-0 translate-y-3 pointer-events-none'
                        }`}
                      >
                        <button className="w-full flex items-center justify-center gap-2 bg-[#AB86B9] hover:bg-[#9a73a8] text-white text-xs font-bold py-2.5 rounded-xl transition-colors shadow-lg">
                          <HiShoppingCart className="w-3.5 h-3.5" />
                          <span>أضف للسلة</span>
                        </button>
                      </div>
                    </div>

                    {/* Info row */}
                    <div className="px-4 py-3.5 bg-gradient-to-b from-[#18182e] to-[#0f0f1e] text-right">
                      <h3 className="text-white font-bold text-sm leading-snug">
                        {product.name}
                      </h3>
                      <div className="mt-1.5">
                        <p className="text-gray-500 text-[10px] font-semibold line-through leading-none">
                          {product.originalPrice.toFixed(2)} ر.س
                        </p>
                        <p className="text-white text-[15px] font-bold leading-tight mt-0.5">
                          {product.price.toFixed(2)} ر.س
                        </p>
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
          <button
            onClick={() => scroll('prev')}
            aria-label="السابق"
            className="w-10 h-10 rounded-full bg-[#AB86B9] text-white flex items-center justify-center hover:bg-[#9a73a8] active:scale-95 transition-all shadow-md"
          >
            <HiChevronRight className="w-5 h-5" />
          </button>
          <button
            onClick={() => scroll('next')}
            aria-label="التالي"
            className="w-10 h-10 rounded-full bg-gray-100 text-gray-400 flex items-center justify-center hover:bg-[#AB86B9] hover:text-white active:scale-95 transition-all shadow-sm"
          >
            <HiChevronLeft className="w-5 h-5" />
          </button>
        </div>

      </div>
    </section>
  );
}
