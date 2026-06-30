import { API_BASE } from '@/config/api';

export function toNumber(value: unknown): number {
  if (typeof value === 'number') return Number.isFinite(value) ? value : 0;
  if (typeof value === 'string') {
    const cleaned = value.replace(/,/g, '').trim();
    const parsed = Number(cleaned);
    return Number.isFinite(parsed) ? parsed : 0;
  }
  return 0;
}

export function normalizeCountResponse(
  data: unknown,
  keys: string[] = ['count', 'total', 'value'],
): number {
  if (data === null || data === undefined) return 0;

  if (typeof data === 'number') return toNumber(data);
  if (typeof data === 'string') return toNumber(data);

  if (typeof data === 'object' && !Array.isArray(data)) {
    const record = data as Record<string, unknown>;

    // Try known keys first
    for (const key of keys) {
      if (key in record && record[key] !== undefined && record[key] !== null) {
        return toNumber(record[key]);
      }
    }

    // Try any numeric value
    for (const value of Object.values(record)) {
      const num = toNumber(value);
      if (num > 0) return num;
    }
  }

  return 0;
}

export function resolvePhotoUrl(photo?: string | null): string {
  if (!photo) return '/assets/images/default_profile.png';

  const trimmed = photo.trim();
  if (trimmed.length === 0) return '/assets/images/default_profile.png';
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) return trimmed;
  if (trimmed.startsWith('/')) return trimmed;
  return `${API_BASE.origin}/${trimmed}`;
}
