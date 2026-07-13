'use client';

import Image from 'next/image';
import { HiRefresh } from 'react-icons/hi';
import { useChessRanking } from '@/features/chess-api/hooks/use-chess-ranking';
import { Skeleton } from '@/components/ui/skeleton';
import { resolvePhotoUrl } from '@/lib/api-utils';
import { cn } from '@/lib/utils';

const BRAND_BROWN = '#644B48';

function rankGradient(rank: number): string {
  if (rank === 1) return 'from-yellow-400 to-yellow-600';
  if (rank === 2) return 'from-gray-300 to-gray-500';
  if (rank === 3) return 'from-amber-400 to-amber-600';
  return 'from-[#AB86B9] to-[#8a6a94]';
}

export function RankingSection() {
  const { players, isLoading, error, refetch } = useChessRanking();

  const topPlayers = players.slice(0, 10);

  return (
    <section className="py-12 sm:py-16 md:py-[70px] relative overflow-hidden bg-white" dir="rtl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-10">
          <div className="flex items-center gap-3">
            <Image
              src="/assets/images/trophy.png"
              alt="كأس"
              width={40}
              height={40}
              className="w-8 h-8 md:w-10 md:h-10 object-contain"
            />
            <div>
              <h2 className="text-2xl sm:text-3xl md:text-[40px] font-bold leading-snug" style={{ color: BRAND_BROWN }}>
                أفضل اللاعبين
              </h2>
              <p className="text-sm md:text-base font-medium text-gray-500 mt-1">
                المتصدرون حسب عدد الفوز
              </p>
            </div>
          </div>

          <button
            onClick={refetch}
            disabled={isLoading}
            className="inline-flex items-center justify-center gap-2 px-4 py-2 rounded-xl border border-gray-200 text-gray-600 hover:bg-gray-50 hover:text-[#644B48] transition-colors disabled:opacity-50 disabled:cursor-not-allowed self-start md:self-auto whitespace-nowrap"
            aria-label="تحديث قائمة المتصدرين"
          >
            <HiRefresh className={cn('w-5 h-5', isLoading && 'animate-spin')} />
            <span className="font-bold text-sm">تحديث</span>
          </button>
        </div>

        {/* Loading state */}
        {isLoading && topPlayers.length === 0 && (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
            {Array.from({ length: 8 }).map((_, i) => (
              <div
                key={i}
                className="flex items-center gap-4 p-4 rounded-2xl border border-gray-100 bg-gray-50/50"
              >
                <Skeleton className="w-14 h-14 rounded-full flex-shrink-0" />
                <div className="flex-1 space-y-2">
                  <Skeleton className="h-4 w-24" />
                  <Skeleton className="h-3 w-16" />
                </div>
                <Skeleton className="w-8 h-8 rounded-lg flex-shrink-0" />
              </div>
            ))}
          </div>
        )}

        {/* Error state */}
        {!isLoading && error && topPlayers.length === 0 && (
          <div className="text-center py-12 rounded-2xl border border-red-100 bg-red-50">
            <p className="text-red-600 font-medium">تعذر تحميل قائمة المتصدرين</p>
            <button
              onClick={refetch}
              className="mt-3 inline-flex items-center gap-2 px-4 py-2 bg-white text-red-600 rounded-lg border border-red-200 hover:bg-red-100 transition-colors font-bold text-sm"
            >
              <HiRefresh className="w-4 h-4" />
              إعادة المحاولة
            </button>
          </div>
        )}

        {/* Players grid */}
        {topPlayers.length > 0 && (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
            {topPlayers.map((player, index) => {
              const rank = index + 1;
              const photoUrl = resolvePhotoUrl(player.photo ?? player.avatar ?? player.image);
              const wins = Number(player.wins ?? 0);

              return (
                <div
                  key={player.id ?? `${player.name}-${rank}`}
                  className="group flex items-center gap-4 p-4 rounded-2xl border border-gray-100 bg-white shadow-sm hover:shadow-md transition-shadow"
                >
                  {/* Avatar */}
                  <div className="relative w-14 h-14 flex-shrink-0 overflow-hidden rounded-full bg-gray-100">
                    <Image
                      src={photoUrl}
                      alt={player.name}
                      fill
                      className="object-cover"
                      sizes="56px"
                      onError={(e) => {
                        const target = e.currentTarget as HTMLImageElement;
                        target.src = '/assets/images/default_profile.png';
                      }}
                    />
                  </div>

                  {/* Info */}
                  <div className="flex-1 min-w-0 text-right">
                    <p className="font-bold text-[#644B48] truncate">{player.name}</p>
                    <p className="text-sm text-gray-500 font-medium">
                      {wins === 1 ? 'فوز واحد' : `${wins} فوز`}
                    </p>
                  </div>

                  {/* Rank badge */}
                  <div
                    className={cn(
                      'w-9 h-9 flex items-center justify-center rounded-lg bg-gradient-to-br text-white font-bold text-sm shadow-sm',
                      rankGradient(rank),
                    )}
                  >
                    {rank}
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* Empty state */}
        {!isLoading && !error && topPlayers.length === 0 && (
          <div className="text-center py-12 rounded-2xl border border-gray-100 bg-gray-50">
            <p className="text-gray-500 font-medium">لا يوجد لاعبون في قائمة المتصدرين حالياً</p>
          </div>
        )}
      </div>
    </section>
  );
}
