"use client";

import { useEffect, useRef } from "react";

export function useVisitor() {
  const hasLogged = useRef(false);

  useEffect(() => {
    if (hasLogged.current) return;
    hasLogged.current = true;

    const logVisitor = async () => {
      try {
        await fetch("/api/visitor", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            page: window.location.pathname,
            userAgent: navigator.userAgent,
          }),
        });
      } catch {
        // silently ignore — server may be unavailable in dev
      }
    };

    logVisitor();
  }, []);
}