import { NextResponse } from 'next/server';
import { CHESS_API_ENDPOINTS } from '@/config/api';
import type { ApiProxyResponse } from '@/types/chess-api';
import type { UploadsResponse } from '@/types/uploads';

export async function GET(request: Request): Promise<NextResponse<ApiProxyResponse<UploadsResponse>>> {
  try {
    const { searchParams } = new URL(request.url);
    const limit = searchParams.get('limit') ?? '5';

    const url = new URL(CHESS_API_ENDPOINTS.uploads);
    url.searchParams.set('limit', limit);

    const response = await fetch(url.toString(), {
      method: 'GET',
      headers: {
        Accept: 'application/json',
      },
      next: { revalidate: 15 },
    });

    if (!response.ok) {
      return NextResponse.json(
        { success: false, error: `External API returned ${response.status}` },
        { status: 502 },
      );
    }

    const raw = (await response.json().catch(async () => response.text())) as unknown;

    if (typeof raw !== 'object' || raw === null || !Array.isArray((raw as Record<string, unknown>).images)) {
      return NextResponse.json(
        { success: false, error: 'Invalid response format from uploads API' },
        { status: 502 },
      );
    }

    const data: UploadsResponse = {
      images: ((raw as Record<string, unknown>).images as unknown[])
        .filter((item): item is string => typeof item === 'string'),
    };

    return NextResponse.json({ success: true, data }, { status: 200 });
  } catch (error) {
    console.error('[chess/uploads] proxy error:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch uploads' },
      { status: 500 },
    );
  }
}
