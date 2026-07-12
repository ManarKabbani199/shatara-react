"use client";

import { GoogleOAuthProvider } from "@react-oauth/google";

export default function GoogleProvider({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <GoogleOAuthProvider clientId="275591974068-em8drl5k3avqt0gkdgl8684jkamdvfek.apps.googleusercontent.com">
      {children}
    </GoogleOAuthProvider>
  );
}