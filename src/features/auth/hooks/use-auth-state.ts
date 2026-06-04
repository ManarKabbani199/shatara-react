"use client";

import { useEffect, useState } from "react";

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
      localStorage.removeItem("user");
      localStorage.removeItem("uid");
      window.location.href = "/login";
    } catch {
      window.location.href = "/login";
    }
  };

  return {
    isLoggedIn,
    isLoading,
    logout,
  };
}