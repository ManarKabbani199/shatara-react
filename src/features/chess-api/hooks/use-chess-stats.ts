'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import { PROXY_PATHS } from '@/config/api';
import type { ApiProxyResponse, ChessStatsData } from '@/types/chess-api';

interface UseChessStatsReturn {
  data: ChessStatsData;
  isLoading: boolean;
  error: string | null;
  refetch: () => void;
}

const INITIAL_DATA: ChessStatsData = {
  visitors: 0,
  online: 0,
  countries: 0,
};

const POLL_INTERVALS = {
  online: 30_000,
  visitors: 60_000,
  countries: 120_000,
} as const;

async function fetchStat(
  url: string,
  signal?: AbortSignal,
): Promise<{ ok: true; value: number } | { ok: false; error: string }> {
  try {
    const response = await fetch(url, {
      method: 'GET',
      headers: { Accept: 'application/json' },
      signal,
    });

    const result = (await response.json()) as ApiProxyResponse<number>;

    if (!response.ok || !result.success) {
      return {
        ok: false,
        error: !result.success && 'error' in result ? result.error : `HTTP ${response.status}`,
      };
    }

    return { ok: true, value: result.data };
  } catch (error) {
    if (error instanceof DOMException && error.name === 'AbortError') {
      return { ok: false, error: 'aborted' };
    }
    return { ok: false, error: error instanceof Error ? error.message : 'Unknown error' };
  }
}

export function useChessStats(): UseChessStatsReturn {
  const [data, setData] = useState<ChessStatsData>(INITIAL_DATA);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const abortRef = useRef<AbortController | null>(null);
  const intervalRefs = useRef<Record<string, NodeJS.Timeout | null>>({
    online: null,
    visitors: null,
    countries: null,
  });

  const fetchAll = useCallback(async (isInitial = false) => {
    if (isInitial) setIsLoading(true);
    abortRef.current?.abort();
    abortRef.current = new AbortController();
    const { signal } = abortRef.current;

    const [visitorsResult, onlineResult, countriesResult] = await Promise.all([
      fetchStat(PROXY_PATHS.visitors, signal),
      fetchStat(PROXY_PATHS.online, signal),
      fetchStat(PROXY_PATHS.countries, signal),
    ]);

    if (signal.aborted) return;

    const errors: string[] = [];
    const next: ChessStatsData = { ...data };

    if (visitorsResult.ok) {
      next.visitors = visitorsResult.value;
    } else if (visitorsResult.error !== 'aborted') {
      errors.push(visitorsResult.error);
    }

    if (onlineResult.ok) {
      next.online = onlineResult.value;
    } else if (onlineResult.error !== 'aborted') {
      errors.push(onlineResult.error);
    }

    if (countriesResult.ok) {
      next.countries = countriesResult.value;
    } else if (countriesResult.error !== 'aborted') {
      errors.push(countriesResult.error);
    }

    setData(next);
    setError(errors.length > 0 ? errors.join(' / ') : null);
    if (isInitial) setIsLoading(false);
  }, [data]);

  useEffect(() => {
    void fetchAll(true);
    const intervals = intervalRefs.current;

    intervals.online = setInterval(() => {
      void fetchStat(PROXY_PATHS.online).then((result) => {
        if (result.ok) setData((prev) => ({ ...prev, online: result.value }));
      });
    }, POLL_INTERVALS.online);

    intervals.visitors = setInterval(() => {
      void fetchStat(PROXY_PATHS.visitors).then((result) => {
        if (result.ok) setData((prev) => ({ ...prev, visitors: result.value }));
      });
    }, POLL_INTERVALS.visitors);

    intervals.countries = setInterval(() => {
      void fetchStat(PROXY_PATHS.countries).then((result) => {
        if (result.ok) setData((prev) => ({ ...prev, countries: result.value }));
      });
    }, POLL_INTERVALS.countries);

    return () => {
      abortRef.current?.abort();
      Object.values(intervals).forEach((interval) => {
        if (interval) clearInterval(interval);
      });
    };
  }, [fetchAll]);

  const refetch = useCallback(() => {
    void fetchAll(false);
  }, [fetchAll]);

  return { data, isLoading, error, refetch };
}
