"use client";

import { useEffect } from "react";

export default function VisitorTracker() {
  useEffect(() => {
    fetch(
      "https://api.shatara.sa/visitor.php?page=" +
        encodeURIComponent(window.location.pathname),
      {
        method: "GET",
      }
    ).catch(() => {});
  }, []);

  return null;
}