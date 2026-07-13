export const API_BASE = {
  origin: 'https://shatara.sa',
  chess: 'https://shatara.sa/chess_api',
  shataraGame: 'https://shatara.sa/ShataraGame',
} as const;

export const CHESS_API_ENDPOINTS = {
  visitors: `${API_BASE.chess}/get_visitors_count.php`,
  online: `${API_BASE.chess}/online_users.php`,
  countries: `${API_BASE.chess}/count_countries.php`,
  ranking: `${API_BASE.chess}/get_ranking.php`,
  logout: `${API_BASE.chess}/logout.php`,
  uploads: `${API_BASE.shataraGame}/list_uploads.php`,
  register: `${API_BASE.chess}/register.php`,
} as const;

export const PROXY_PATHS = {
  // Trailing slashes required: next.config.ts has trailingSlash: true,
  // otherwise every request gets a 308 redirect first
  visitors: '/api/chess/visitors/',
  online: '/api/chess/online/',
  countries: '/api/chess/countries/',
  ranking: '/api/chess/ranking/',
  uploads: '/api/chess/uploads/',
  register: '/api/auth/register/',
} as const;
