"use client";

import { GoogleLogin } from "@react-oauth/google";

export default function SocialLoginButton() {
  return (
    <GoogleLogin
      onSuccess={async (credentialResponse) => {
        try {
          const token = credentialResponse.credential;

          if (!token) {
            alert("لم يتم استلام بيانات Google");
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

            alert(data.message || "تم تسجيل الدخول بواسطة Google");
            window.location.href = "/";
          } else {
            alert(data.message || "فشل تسجيل الدخول بواسطة Google");
          }
        } catch (error) {
          console.error("GOOGLE SQL LOGIN ERROR:", error);
          alert("حدث خطأ أثناء التسجيل باستخدام Google");
        }
      }}
      onError={() => {
        alert("فشل تسجيل الدخول بواسطة Google");
      }}
    />
  );
}