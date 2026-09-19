"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
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

/** Fired on window after login/logout mutates localStorage, so mounted
 *  components (e.g. the navbar) refresh their auth state without a reload. */
export const AUTH_CHANGED_EVENT = "shatara-auth-changed";

export function notifyAuthChanged() {
  if (typeof window !== "undefined") {
    window.dispatchEvent(new Event(AUTH_CHANGED_EVENT));
  }
}

export function useAuth() {
  const router = useRouter();
  const [user, setUser] = useState<SqlUser | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const load = () => {
      try {
        const savedUser = localStorage.getItem("user");
        setUser(savedUser ? (JSON.parse(savedUser) as SqlUser) : null);
      } catch {
        setUser(null);
      } finally {
        setIsLoading(false);
      }
    };

    load();
    window.addEventListener(AUTH_CHANGED_EVENT, load);
    return () => window.removeEventListener(AUTH_CHANGED_EVENT, load);
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
      notifyAuthChanged();
      router.push("/login");
    }
  };

  return {
    user,
    isLoading,
    isLoggedIn: !!user,
    logout,
  };
}
