"use client";

import React, { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import LoginInput from "./LoginInput";
import SocialLoginButton from "./SocialLoginButton";

export default function LoginForm() {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [loading, setLoading] = useState(false);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        if (!username.trim() || !password.trim()) {
            alert("يرجى إدخال اسم المستخدم وكلمة المرور");
            return;
        }

        setLoading(true);

        try {
            const params = new URLSearchParams({
                username: username.trim(),
                password: password.trim(),
            });
            const response = await fetch(`https://shatara.sa/chess_api/login.php?${params.toString()}`);

            const data = await response.json();

            if (data.success === true) {
                localStorage.setItem("user", JSON.stringify(data.user));
                localStorage.setItem("uid", String(data.user.uid ?? data.user.id));

                alert("تم تسجيل الدخول بنجاح");
                window.location.href = "/";
            } else {
                alert(data.message || "فشل تسجيل الدخول");
            }
        } catch (error) {
            console.error("LOGIN ERROR:", error);
            alert("حدث خطأ في الاتصال بالسيرفر");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="flex flex-col w-full" dir="rtl">
            <div className="w-full hidden lg:flex justify-center mb-10 select-none">
                <Image
                    src="/assets/images/logoapp.png"
                    alt="شطارة"
                    width={220}
                    height={80}
                    priority
                    className="object-contain"
                />
            </div>

            <div className="w-full hidden lg:block text-center mb-5">
                <h1 className="text-[18px] font-bold mb-2 leading-snug" style={{ color: "#5C4033" }}>
                    عضو في شطارة!
                </h1>
                <p className="text-[14px] leading-6" style={{ color: "#6B4E45" }}>
                    أهلاً بعودتك!، إستخدم بياناتك لتسجيل الدخول
                </p>
            </div>

            <form onSubmit={handleSubmit} className="w-full flex flex-col gap-3" noValidate>
                <LoginInput
                    icon="username"
                    type="text"
                    placeholder="إسم المستخدم أو البريد الإلكتروني"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    autoComplete="username"
                    required
                />

                <LoginInput
                    icon="password"
                    type="password"
                    placeholder="كلمة المرور"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    autoComplete="current-password"
                    required
                />

                <div className="w-full lg:hidden flex items-center justify-between mt-1">
                    <label className="flex items-center gap-2 cursor-pointer group">
                        <input
                            type="checkbox"
                            className="w-4 h-4 rounded border-2 border-[#8C7467] cursor-pointer accent-[#A67BC4]"
                        />
                        <span className="text-xs text-[#6B4E45] group-hover:text-[#5C4033] transition-colors">
                            تذكرني
                        </span>
                    </label>

                    <Link
                        href="/forgot-password"
                        className="text-xs hover:underline transition-colors"
                        style={{ color: "#A67BC4" }}
                    >
                        نسيت كلمة المرور؟
                    </Link>
                </div>

                <div className="w-full hidden lg:flex justify-start mt-0.5">
                    <Link
                        href="/forgot-password"
                        className="text-xs hover:underline transition-colors"
                        style={{ color: "#A67BC4" }}
                    >
                        نسيت كلمة المرور؟
                    </Link>
                </div>

                <button
                    type="submit"
                    disabled={loading}
                    className="w-full h-11 mt-3 rounded-xl text-white text-sm font-semibold tracking-wide hover:opacity-90 transition-opacity disabled:opacity-60"
                    style={{ backgroundColor: "#A67BC4" }}
                >
                    {loading ? "جاري تسجيل الدخول..." : "تسجيل الدخول"}
                </button>
            </form>

            <div className="flex items-center w-full my-4 gap-3">
                <div className="flex-1 h-px bg-gray-300" />
                <span className="text-xs text-gray-400 whitespace-nowrap">أو عن طريق</span>
                <div className="flex-1 h-px bg-gray-300" />
            </div>

            <div className="w-full" dir="ltr">
                <SocialLoginButton />
            </div>

            <p className="w-full mt-4 text-[13px] text-[#6B4E45] font-medium text-center">
                ليس لديك حساب؟{" "}
                <Link
                    href="/register"
                    className="font-bold hover:underline transition-colors"
                    style={{ color: "#6B4E45" }}
                >
                    أنشئ حساب جديد
                </Link>
            </p>
        </div>
    );
}