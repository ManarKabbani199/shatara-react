"use client";

import { GoogleOAuthProvider } from "@react-oauth/google";

export default function GoogleProvider({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <GoogleOAuthProvider clientId="ضع_GOOGLE_CLIENT_ID_هنا">
      {children}
    </GoogleOAuthProvider>
  );
}