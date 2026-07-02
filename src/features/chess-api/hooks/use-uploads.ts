'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import { PROXY_PATHS } from '@/config/api';
import type { ApiProxyResponse } from '@/types/chess-api';
import type { UploadsResponse } from '@/types/uploads';

interface UseUploadsReturn {
  images: string[];
  isLoading: boolean;
  error: string | null;
  refetch: () => void;
}

const DEFAULT_LIMIT = 5;
const POLL_INTERVAL = 60_000;

export function useUploads(limit: number = DEFAULT_LIMIT): UseUploadsReturn {
  const [images, setImages] = useState<string[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const abortRef = useRef<AbortController | null>(null);
  const intervalRef = useRef<NodeJS.Timeout | null>(null);

  const fetchUploads = useCallback(
    async (isInitial = false) => {
      if (isInitial) setIsLoading(true);
      abortRef.current?.abort();
      abortRef.current = new AbortController();
      const { signal } = abortRef.current;

      try {
        const url = new URL(PROXY_PATHS.uploads, window.location.origin);
        url.searchParams.set('limit', String(limit));

        const response = await fetch(url.toString(), {
          method: 'GET',
          headers: { Accept: 'application/json' },
          signal,
        });

        const result = (await response.json()) as ApiProxyResponse<UploadsResponse>;

        if (signal.aborted) return;

        if (!response.ok || !result.success) {
          setError(!result.success && 'error' in result ? result.error : `HTTP ${response.status}`);
          setImages([]);
          return;
        }

        setImages(result.data.images);
        setError(null);
      } catch (err) {
        if (err instanceof DOMException && err.name === 'AbortError') return;
        setError(err instanceof Error ? err.message : 'Unknown error');
        setImages([]);
      } finally {
        if (isInitial) setIsLoading(false);
      }
    },
    [limit],
  );

  useEffect(() => {
    void fetchUploads(true);

    intervalRef.current = setInterval(() => {
      void fetchUploads(false);
    }, POLL_INTERVAL);

    return () => {
      abortRef.current?.abort();
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, [fetchUploads]);

  const refetch = useCallback(() => {
    void fetchUploads(false);
  }, [fetchUploads]);

  return { images, isLoading, error, refetch };
}
