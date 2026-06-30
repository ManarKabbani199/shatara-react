export interface VisitorsResponse {
  success: boolean;
  visitors_count: number;
}

export interface OnlineResponse {
  success: boolean;
  online: number;
}

export interface CountriesResponse {
  success: boolean;
  countries: number;
}

export interface RankingPlayer {
  id: string;
  name: string;
  wins: string;
  photo?: string;
  avatar?: string;
  image?: string;
  score?: string | number;
}

export interface RankingResponse {
  success: boolean;
  count: number;
  players: RankingPlayer[];
}

export type ChessStatsData = {
  visitors: number;
  online: number;
  countries: number;
};

export interface ApiProxySuccess<T> {
  success: true;
  data: T;
}

export interface ApiProxyError {
  success: false;
  error: string;
}

export type ApiProxyResponse<T> = ApiProxySuccess<T> | ApiProxyError;
