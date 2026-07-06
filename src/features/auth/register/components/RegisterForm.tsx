"use client";

import React, { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import LoginInput from "../../login/components/LoginInput";
import SocialLoginButton from "../../login/components/SocialLoginButton";

export default function RegisterForm() {
    const [name, setName] = useState("");
    const [username, setUsername] = useState("");
    const [email, setEmail] = useState("");
    const [phoneNumber, setPhoneNumber] = useState("");
    const [password, setPassword] = useState("");
    const [level, setLevel] = useState("مبتدئ");
    const [loading, setLoading] = useState(false);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        if (!name.trim() || !username.trim() || !email.trim() || !password.trim()) {
            alert("يرجى تعبئة جميع الحقول المطلوبة");
            return;
        }

        if (password.length < 6) {
            alert("كلمة المرور يجب أن تكون 6 أحرف على الأقل");
            return;
        }

        setLoading(true);

        try {
            const response = await fetch("/api/auth/register", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    name: name.trim(),
                    username: username.trim(),
                    email: email.trim(),
                    phone_number: phoneNumber.trim(),
                    password: password.trim(),
                    level: level,
                }),
            });

            const data = await response.json();

            if (data.success === true) {
                localStorage.setItem("user", JSON.stringify(data.user));
                localStorage.setItem("uid", String(data.user.uid ?? data.user.id));

                alert("تم إنشاء الحساب بنجاح");
                window.location.href = "/";
            } else {
                alert(data.message || "فشل إنشاء الحساب");
            }
        } catch (error) {
            console.error("REGISTER ERROR:", error);
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
                    عضو جديد في شطارة!
                </h1>
                <p className="text-[14px] leading-6" style={{ color: "#6B4E45" }}>
                    مرحبًا بك!، يمكنك الإنضمام إلينا عن طريق إنشاء حساب جديد
                </p>
            </div>

            <form onSubmit={handleSubmit} className="w-full flex flex-col gap-3" noValidate>
                <LoginInput
                    icon="name"
                    type="text"
                    placeholder="الاسم الكامل"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    autoComplete="name"
                    required
                />

                <LoginInput
                    icon="username"
                    type="text"
                    placeholder="اسم المستخدم"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    autoComplete="username"
                    required
                />

                <LoginInput
                    icon="email"
                    type="email"
                    placeholder="البريد الإلكتروني"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    autoComplete="email"
                    required
                />

                <LoginInput
                    icon="phone"
                    type="tel"
                    placeholder="رقم الهاتف"
                    value={phoneNumber}
                    onChange={(e) => setPhoneNumber(e.target.value)}
                    autoComplete="tel"
                />

                <LoginInput
                    icon="password"
                    type="password"
                    placeholder="كلمة المرور"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    autoComplete="new-password"
                    required
                />

                <select
                    value={level}
                    onChange={(e) => setLevel(e.target.value)}
                    className="w-full h-11 rounded-xl border border-[#E5D7CE] bg-white/70 backdrop-blur-sm px-3 text-sm outline-none text-right text-[#5C4033]"
                    style={{ color: "#6B4E45" }}
                >
                    <option value="مبتدئ">مبتدئ</option>
                    <option value="متوسط">متوسط</option>
                    <option value="محترف">محترف</option>
                </select>

                <button
                    type="submit"
                    disabled={loading}
                    className="w-full h-11 mt-3 rounded-xl text-white text-sm font-semibold tracking-wide hover:opacity-90 transition-opacity disabled:opacity-60"
                    style={{ backgroundColor: "#A67BC4" }}
                >
                    {loading ? "جاري إنشاء الحساب..." : "إنشاء حساب"}
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
                لديك حساب؟{" "}
                <Link
                    href="/login"
                    className="font-bold hover:underline transition-colors"
                    style={{ color: "#6B4E45" }}
                >
                    تسجيل الدخول
                </Link>
            </p>
        </div>
    );
}
