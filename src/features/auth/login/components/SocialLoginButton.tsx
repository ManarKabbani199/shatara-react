"use client";

import { GoogleLogin } from "@react-oauth/google";

export default function SocialLoginButton() {
  return (
    <GoogleLogin
      onSuccess={async (credentialResponse) => {
        const token = credentialResponse.credential;

        if (!token) {
          alert("لم يتم استلام Google Token");
          return;
        }

        try {
          const response = await fetch("https://shatara.sa/chess_api/google_login.php", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({ token: token }),
          });

          const text = await response.text();
          console.log("GOOGLE PHP RESPONSE:", text);

          const data = JSON.parse(text);

          if (data.success) {
            localStorage.setItem("user", JSON.stringify(data.user));
            localStorage.setItem("uid", String(data.user.uid ?? data.user.id));
            window.location.href = "/";
          } else {
            alert(data.message || "فشل تسجيل الدخول بواسطة Google");
          }
        } catch (error) {
          console.error(error);
          alert("حدث خطأ أثناء التسجيل باستخدام Google");
        }
      }}
      onError={() => {
        alert("فشل تسجيل الدخول من Google");
      }}
    />
  );
}