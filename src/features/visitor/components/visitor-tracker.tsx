"use client";

import { useEffect } from "react";

export default function VisitorTracker() {
  useEffect(() => {
    fetch(
      "https://shatara.sa/chess_api/visitor.php?page=" +
        encodeURIComponent(window.location.pathname),
      {
        method: "GET",
      }
    ).catch(() => {});
  }, []);

  return null;
}