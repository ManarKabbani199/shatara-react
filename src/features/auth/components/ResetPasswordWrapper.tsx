"use client";

import React, { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import LoginInput from "@/features/auth/login/components/LoginInput";

export default function ResetPasswordWrapper() {
    const [password, setPassword] = useState("");
    const [confirmPassword, setConfirmPassword] = useState("");
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState("");

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        if (password.length < 6) {
            setMessage("كلمة المرور يجب أن تكون 6 أحرف على الأقل");
            return;
        }
        if (password !== confirmPassword) {
            setMessage("كلمتا المرور غير متطابقتين");
            return;
        }

        setLoading(true);
        // Simulate API call
        setTimeout(() => {
            setMessage("تم تغيير كلمة المرور بنجاح.");
            setLoading(false);
            setTimeout(() => {
                window.location.href = "/login";
            }, 1500);
        }, 1000);
    };

    return (
        <div className="w-full min-h-screen flex items-center justify-center relative overflow-hidden bg-white lg:bg-[url('/assets/images/Login.png')] lg:bg-cover lg:bg-center lg:bg-no-repeat">
            <div className="relative w-full max-w-[1440px] min-h-screen flex flex-col px-4 pt-6 pb-4 lg:pt-[32px] lg:pr-[48px] lg:pb-[24px] lg:pl-[48px]" dir="ltr">

                <div className="relative z-10 flex flex-row items-center justify-center gap-16 lg:gap-24 w-full max-w-[1344px] mx-auto flex-1" style={{ marginTop: "24px" }}>
                    {/* Image side - desktop only */}
                    <div className="hidden lg:flex items-center justify-center shrink-0" style={{ width: "55%" }}>
                        <img src="/assets/images/image 302.png" alt="Shatara Pieces" className="w-full max-w-[540px] h-auto object-contain" style={{ maxHeight: "430px" }} />
                    </div>

                    {/* Form side */}
                    <div
                        className="w-full lg:w-[480px] shrink-0 flex flex-col justify-center py-6 lg:py-14 px-4 sm:px-6 lg:px-12 lg:rounded-3xl lg:shadow-2xl lg:bg-[url('/assets/images/backhome.png')] lg:bg-cover lg:bg-center lg:bg-no-repeat"
                        dir="rtl"
                    >
                        <div className="w-full flex flex-col items-center mb-6 lg:mb-10 select-none">
                            <Image src="/assets/images/logoapp.png" alt="شطارة" width={220} height={80} priority className="object-contain" />
                        </div>

                        <div className="w-full text-center mb-5">
                            <h1 className="text-[18px] font-bold mb-2 leading-snug" style={{ color: "#5C4033" }}>تعيين كلمة مرور جديدة</h1>
                            <p className="text-[14px] leading-6" style={{ color: "#6B4E45" }}>الرجاء إدخال كلمة المرور الجديدة الخاصة بك</p>
                        </div>

                        <form onSubmit={handleSubmit} className="w-full flex flex-col gap-3" noValidate>
                            <LoginInput
                                icon="password"
                                type="password"
                                placeholder="كلمة المرور الجديدة"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                required
                            />

                            <LoginInput
                                icon="password"
                                type="password"
                                placeholder="تأكيد كلمة المرور"
                                value={confirmPassword}
                                onChange={(e) => setConfirmPassword(e.target.value)}
                                required
                            />

                            {message && (
                                <p className="text-sm text-center font-bold" style={{ color: message.includes("بنجاح") ? "#4A8564" : "#D32F2F" }}>{message}</p>
                            )}

                            <button
                                type="submit"
                                disabled={loading}
                                className="w-full h-11 mt-3 rounded-xl text-white text-sm font-semibold tracking-wide hover:opacity-90 transition-opacity disabled:opacity-60"
                                style={{ backgroundColor: "#A67BC4" }}
                            >
                                {loading ? "جاري الحفظ..." : "تغيير كلمة المرور"}
                            </button>
                        </form>

                        <div className="w-full mt-6 text-center">
                            <Link href="/login" className="text-sm font-bold hover:underline" style={{ color: "#6B4E45" }}>العودة لتسجيل الدخول</Link>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
