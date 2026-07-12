'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import { PROXY_PATHS } from '@/config/api';
import type { ApiProxyResponse, RankingPlayer } from '@/types/chess-api';

interface UseChessRankingReturn {
  players: RankingPlayer[];
  isLoading: boolean;
  error: string | null;
  refetch: () => void;
}

const POLL_INTERVAL = 5 * 60 * 1000; // 5 minutes

export function useChessRanking(): UseChessRankingReturn {
  const [players, setPlayers] = useState<RankingPlayer[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const abortRef = useRef<AbortController | null>(null);
  const intervalRef = useRef<NodeJS.Timeout | null>(null);

  const fetchRanking = useCallback(async (isInitial = false) => {
    if (isInitial) setIsLoading(true);
    abortRef.current?.abort();
    abortRef.current = new AbortController();
    const { signal } = abortRef.current;

    try {
      const response = await fetch(PROXY_PATHS.ranking, {
        method: 'GET',
        headers: { Accept: 'application/json' },
        signal,
      });

      if (signal.aborted) return;

      const result = (await response.json()) as ApiProxyResponse<RankingPlayer[]>;

      if (!response.ok || !result.success) {
        setError(
          !result.success && 'error' in result ? result.error : `HTTP ${response.status}`,
        );
        return;
      }

      setPlayers(result.data);
      setError(null);
    } catch (err) {
      if (err instanceof DOMException && err.name === 'AbortError') return;
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      if (isInitial && !signal.aborted) setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    void fetchRanking(true);

    intervalRef.current = setInterval(() => {
      void fetchRanking(false);
    }, POLL_INTERVAL);

    return () => {
      abortRef.current?.abort();
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, [fetchRanking]);

  const refetch = useCallback(() => {
    void fetchRanking(false);
  }, [fetchRanking]);

  return { players, isLoading, error, refetch };
}
