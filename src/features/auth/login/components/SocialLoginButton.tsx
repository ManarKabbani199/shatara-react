"use client";

import { GoogleLogin } from "@react-oauth/google";
import toast from "react-hot-toast";

export default function SocialLoginButton() {
  return (
    <GoogleLogin
      onSuccess={async (credentialResponse) => {
        try {
          const token = credentialResponse.credential;

          if (!token) {
            toast.error("لم يتم استلام بيانات Google");
            return;
          }

          const response = await fetch("https://shatara.sa/shatara_api/google_login.php", {
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
            window.location.href = "/";
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