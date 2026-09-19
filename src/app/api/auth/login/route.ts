import { NextResponse } from 'next/server';
import { CHESS_API_ENDPOINTS } from '@/config/api';

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const username = typeof body?.username === 'string' ? body.username : '';
    const password = typeof body?.password === 'string' ? body.password : '';

    if (!username || !password) {
      return NextResponse.json(
        { success: false, message: 'Missing credentials' },
        { status: 400 },
      );
    }

    // login.php expects form-encoded fields (not JSON)
    const response = await fetch(CHESS_API_ENDPOINTS.login, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        Accept: 'application/json',
      },
      body: new URLSearchParams({ username, password }).toString(),
    });

    const text = await response.text();
    let data: unknown;
    try {
      data = JSON.parse(text);
    } catch {
      data = { success: false, message: 'Login server returned an invalid response' };
    }

    return NextResponse.json(data, { status: response.status });
  } catch (error) {
    console.error('[auth/login] proxy error:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to connect to login server' },
      { status: 502 },
    );
  }
}
