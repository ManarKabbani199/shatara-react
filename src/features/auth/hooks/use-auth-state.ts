"use client";

import { useEffect, useState } from "react";
import { CHESS_API_ENDPOINTS } from "@/config/api";

export function useAuthState() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    try {
      const user = localStorage.getItem("user");
      setIsLoggedIn(!!user);
    } catch {
      setIsLoggedIn(false);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const logout = async () => {
    try {
      const savedUser = localStorage.getItem("user");
      const savedUid = localStorage.getItem("uid");
      const parsedUser = savedUser ? (JSON.parse(savedUser) as { id?: number | string; uid?: string }) : null;
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
      setIsLoggedIn(false);
      window.location.href = "/login";
    }
  };

  return {
    isLoggedIn,
    isLoading,
    logout,
  };
}
