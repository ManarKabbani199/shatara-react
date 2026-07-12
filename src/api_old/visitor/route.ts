import { NextResponse } from 'next/server';

export async function POST(request: Request) {
  try {
    const body = await request.json();

    const response = await fetch('https://shatara.sa/shatara_api/visitor.php', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });

    const data = await response.text();

    return NextResponse.json(
      { success: response.ok, data },
      { status: response.status },
    );
  } catch {
    return NextResponse.json(
      { success: false, message: 'Failed to log visitor' },
      { status: 500 },
    );
  }
}
