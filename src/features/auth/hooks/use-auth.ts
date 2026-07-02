"use client";

import { useEffect, useState } from "react";
import { CHESS_API_ENDPOINTS } from "@/config/api";

export type SqlUser = {
  id: number | string;
  uid?: string;
  name?: string;
  username?: string;
  email?: string;
  phone_number?: string;
  level?: string;
  wins?: number;
  login?: number;
  play_computer?: number;
  bio?: string;
  profileImageUrl?: string;
  bannerImageUrl?: string;
  isBanned?: number;
  online?: number;
  ShataID?: string;
};

export function useAuth() {
  const [user, setUser] = useState<SqlUser | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    try {
      const savedUser = localStorage.getItem("user");

      if (savedUser) {
        setUser(JSON.parse(savedUser));
      } else {
        setUser(null);
      }
    } catch {
      setUser(null);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const logout = async () => {
    try {
      const savedUser = localStorage.getItem("user");
      const savedUid = localStorage.getItem("uid");
      const parsedUser = savedUser ? (JSON.parse(savedUser) as SqlUser) : null;
      const userId = parsedUser?.id ?? parsedUser?.uid ?? savedUid;

      if (userId) {
        const params = new URLSearchParams({ id: String(userId) });
        await fetch(`${CHESS_API_ENDPOINTS.logout}?${params.toString()}`, {
          method: "GET",
          headers: { Accept: "application/json" },
        }).catch(() => {
          // Ignore network errors; still clear local state below
        });
      }
    } catch {
      // Ignore parse/network errors and proceed with local logout
    } finally {
      localStorage.removeItem("user");
      localStorage.removeItem("uid");
      setUser(null);
      window.location.href = "/login";
    }
  };

  return {
    user,
    isLoading,
    isLoggedIn: !!user,
    logout,
  };
}
