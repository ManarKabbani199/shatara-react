'use client';

import Image from 'next/image';
import { useUploads } from '@/features/chess-api/hooks/use-uploads';
import { Skeleton } from '@/components/ui/skeleton';

interface UploadsGalleryProps {
  limit?: number;
  title?: string;
  subtitle?: string;
}

export function UploadsGallery({
  limit = 5,
  title = 'آخر اللقطات',
  subtitle = 'شاهد أحدث اللقطات والتحركات من لعبة شطارة',
}: UploadsGalleryProps) {
  const { images, isLoading, error } = useUploads(limit);

  const hasImages = images.length > 0;
  const showSkeleton = isLoading && !hasImages;

  return (
    <section className="w-full rounded-xl sm:rounded-2xl bg-white border border-brand-brown/10 shadow-lg shadow-brand-brown/10 p-4 sm:p-5" dir="rtl">
      <div className="mb-4 sm:mb-5">
        <h2 className="text-brand-brown font-bold text-base sm:text-lg md:text-xl leading-tight">
          {title}
        </h2>
        <p className="text-text-secondary text-xs sm:text-sm leading-snug mt-1">
          {subtitle}
        </p>
      </div>

      {error && !showSkeleton && (
        <div className="rounded-xl bg-red-50 text-red-700 text-sm p-3 text-center">
          لم نتمكن من تحميل الصور. يرجى المحاولة لاحقاً.
        </div>
      )}

      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3 sm:gap-4">
        {showSkeleton ? (
          Array.from({ length: limit }).map((_, index) => (
            <div
              key={`skeleton-${index}`}
              className="relative aspect-square rounded-xl overflow-hidden bg-gray-100"
            >
              <Skeleton className="absolute inset-0" />
            </div>
          ))
        ) : (
          images.map((src, index) => (
            <div
              key={`${src}-${index}`}
              className="relative aspect-square rounded-xl overflow-hidden border border-brand-brown/10 bg-gray-50 group"
            >
              <Image
                src={src}
                alt={`لقطة شطارة ${index + 1}`}
                fill
                sizes="(max-width: 640px) 50vw, (max-width: 768px) 33vw, (max-width: 1024px) 25vw, 20vw"
                className="object-cover transition-transform duration-300 group-hover:scale-105"
                unoptimized
              />
            </div>
          ))
        )}
      </div>

      {!isLoading && !error && !hasImages && (
        <p className="text-text-secondary text-sm text-center py-6">
          لا توجد صور متاحة حالياً.
        </p>
      )}
    </section>
  );
}
