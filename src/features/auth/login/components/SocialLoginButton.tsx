"use client";

import { GoogleLogin } from "@react-oauth/google";
import { useRouter } from "next/navigation";
import toast from "react-hot-toast";
import { CHESS_API_ENDPOINTS } from "@/config/api";
import { isGoogleLoginEnabled } from "@/config/constants";
import { notifyAuthChanged } from "@/features/auth/hooks/use-auth";

export default function SocialLoginButton() {
  const router = useRouter();

  // Hidden unless NEXT_PUBLIC_GOOGLE_CLIENT_ID is configured.
  if (!isGoogleLoginEnabled) {
    return null;
  }

  return (
    <GoogleLogin
      onSuccess={async (credentialResponse) => {
        try {
          const token = credentialResponse.credential;

          if (!token) {
            toast.error("لم يتم استلام بيانات Google");
            return;
          }

          const response = await fetch(CHESS_API_ENDPOINTS.googleLogin, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({ token }),
          });

          const data = await response.json();

          if (data.success === true) {
            localStorage.setItem("user", JSON.stringify(data.user));
            localStorage.setItem("uid", String(data.user.uid ?? data.user.id));

            toast.success(data.message || "تم تسجيل الدخول بواسطة Google");
            notifyAuthChanged();
            router.push("/");
          } else {
            toast.error(data.message || "فشل تسجيل الدخول بواسطة Google");
          }
        } catch (error) {
          console.error("GOOGLE SQL LOGIN ERROR:", error);
          toast.error("حدث خطأ أثناء التسجيل باستخدام Google");
        }
      }}
      onError={() => {
        toast.error("فشل تسجيل الدخول بواسطة Google");
      }}
    />
  );
}
