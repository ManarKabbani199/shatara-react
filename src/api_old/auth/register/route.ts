import { NextResponse } from 'next/server';
import { CHESS_API_ENDPOINTS } from '@/config/api';

export async function POST(request: Request) {
  try {
    const body = await request.json();

    const response = await fetch(CHESS_API_ENDPOINTS.register, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: JSON.stringify(body),
    });

    const text = await response.text();
    let data: unknown;
    try {
      data = JSON.parse(text);
    } catch {
      data = { success: false, message: 'Registration server returned an invalid response' };
    }

    return NextResponse.json(data, { status: response.status });
  } catch (error) {
    console.error('[auth/register] proxy error:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to connect to registration server' },
      { status: 502 },
    );
  }
}
