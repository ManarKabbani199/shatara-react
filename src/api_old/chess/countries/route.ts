import { NextResponse } from 'next/server';
import { CHESS_API_ENDPOINTS } from '@/config/api';
import { normalizeCountResponse } from '@/lib/api-utils';
import type { ApiProxyResponse } from '@/types/chess-api';

export async function GET(): Promise<NextResponse<ApiProxyResponse<number>>> {
  try {
    const response = await fetch(CHESS_API_ENDPOINTS.countries, {
      method: 'GET',
      headers: {
        Accept: 'application/json',
      },
      next: { revalidate: 300 },
    });

    if (!response.ok) {
      return NextResponse.json(
        { success: false, error: `External API returned ${response.status}` },
        { status: 502 },
      );
    }

    const raw = (await response.json().catch(async () => response.text())) as unknown;
    const count = normalizeCountResponse(raw, ['countries', 'count', 'total']);

    return NextResponse.json({ success: true, data: count }, { status: 200 });
  } catch (error) {
    console.error('[chess/countries] proxy error:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch countries count' },
      { status: 500 },
    );
  }
}
