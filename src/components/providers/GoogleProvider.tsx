"use client";

import { GoogleOAuthProvider } from "@react-oauth/google";
import { GOOGLE_CLIENT_ID } from "@/config/constants";

export default function GoogleProvider({
  children,
}: {
  children: React.ReactNode;
}) {
  // Google sign-in is disabled until NEXT_PUBLIC_GOOGLE_CLIENT_ID is set —
  // render children without the provider instead of crashing the app.
  if (!GOOGLE_CLIENT_ID) {
    return <>{children}</>;
  }

  return (
    <GoogleOAuthProvider clientId={GOOGLE_CLIENT_ID}>
      {children}
    </GoogleOAuthProvider>
  );
}
