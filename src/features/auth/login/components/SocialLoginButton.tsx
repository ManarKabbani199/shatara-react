"use client";

import { useEffect, useRef, useState } from "react";
import { GoogleLogin } from "@react-oauth/google";

export default function SocialLoginButton() {
  const containerRef = useRef<HTMLDivElement>(null);
  const [buttonWidth, setButtonWidth] = useState(320);

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    const updateWidth = () => {
      const width = el.getBoundingClientRect().width;
      setButtonWidth(Math.max(200, Math.min(width, 400)));
    };

    updateWidth();
    const observer = new ResizeObserver(updateWidth);
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  return (
    <div ref={containerRef} className="w-full">
      <GoogleLogin
        width={buttonWidth}
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
    </div>
  );
}
