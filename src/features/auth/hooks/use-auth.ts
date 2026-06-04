"use client";

import { useEffect, useState } from "react";

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
    localStorage.removeItem("user");
    localStorage.removeItem("uid");
    setUser(null);
    window.location.href = "/login";
  };

  return {
    user,
    isLoading,
    isLoggedIn: !!user,
    logout,
  };
}