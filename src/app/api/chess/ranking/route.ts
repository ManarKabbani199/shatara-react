import { NextResponse } from 'next/server';
import { CHESS_API_ENDPOINTS } from '@/config/api';
import type { ApiProxyResponse, RankingPlayer } from '@/types/chess-api';

interface RankingRawPlayer {
  id?: string | number;
  name?: string;
  wins?: string | number;
  photo?: string;
  avatar?: string;
  image?: string;
  score?: string | number;
}

interface RankingRawResponse {
  success?: boolean;
  count?: number;
  players?: RankingRawPlayer[];
}

function toStringValue(value: unknown): string {
  if (value === null || value === undefined) return '';
  return String(value);
}

export async function GET(): Promise<NextResponse<ApiProxyResponse<RankingPlayer[]>>> {
  try {
    const response = await fetch(CHESS_API_ENDPOINTS.ranking, {
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

    let players: RankingRawPlayer[] = [];

    if (Array.isArray(raw)) {
      players = raw;
    } else if (raw && typeof raw === 'object') {
      const record = raw as RankingRawResponse;
      if (Array.isArray(record.players)) {
        players = record.players;
      }
    }

    const normalized: RankingPlayer[] = players.map((player, index) => ({
      id: toStringValue(player.id ?? index + 1),
      name: toStringValue(player.name ?? 'لاعب'),
      wins: toStringValue(player.wins ?? '0'),
      photo: toStringValue(player.photo ?? player.avatar ?? player.image),
      score: player.score ?? player.wins ?? '0',
    }));

    return NextResponse.json({ success: true, data: normalized }, { status: 200 });
  } catch (error) {
    console.error('[chess/ranking] proxy error:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch ranking' },
      { status: 500 },
    );
  }
}
