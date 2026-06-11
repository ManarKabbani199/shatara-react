"use client";

import React, { useState } from "react";
import Link from "next/link";
import Image from "next/image";
import LoginForm from "@/features/auth/login/components/LoginForm";
import RegisterForm from "@/features/auth/register/components/RegisterForm";

interface MobileAuthWrapperProps {
    defaultTab: "login" | "register";
}

export default function MobileAuthWrapper({ defaultTab }: MobileAuthWrapperProps) {
    const [activeTab, setActiveTab] = useState<"login" | "register">(defaultTab);

    const mobileSubtitle =
        activeTab === "login"
            ? "أهلاً بعودتك!، إستخدم بياناتك لتسجيل الدخول"
            : "مرحبًا بك!، يمكنك الإنضمام إلينا عن طريق إنشاء حساب جديد";

    return (
        <div className="w-full min-h-screen flex items-center justify-center relative overflow-hidden bg-white lg:bg-[url('/assets/images/Login.png')] lg:bg-cover lg:bg-center lg:bg-no-repeat">

            <div
                className="relative w-full max-w-[1440px] min-h-screen flex flex-col px-4 pt-6 pb-4 lg:pt-[32px] lg:pr-[48px] lg:pb-[24px] lg:pl-[48px]"
                dir="ltr"
            >

                {/* ── MAIN LAYOUT ── */}
                <div
                    className="relative z-10 flex flex-row items-center justify-center gap-16 lg:gap-24 w-full max-w-[1344px] mx-auto flex-1"
                    style={{ marginTop: "24px" }}
                >

                    {/* Shatara pieces image — desktop only */}
                    <div className="hidden lg:flex items-center justify-center shrink-0" style={{ width: "55%" }}>
                        <img
                            src="/assets/images/image 302.png"
                            alt="Shatara Pieces"
                            className="w-full max-w-[540px] h-auto object-contain"
                            style={{ maxHeight: "430px" }}
                        />
                    </div>

                    {/* ── DESKTOP CARD ── */}
                    <div
                        className={`hidden lg:flex ${defaultTab === "login" ? "py-14" : "py-10"} w-[390px] shrink-0 flex-col justify-center rounded-3xl shadow-2xl`}
                        style={{
                            backgroundImage: "url('/assets/images/backhome.png')",
                            backgroundSize: "100% 100%",
                            backgroundPosition: "center",
                            backgroundRepeat: "no-repeat",
                            zIndex: 10,
                        }}
                    >
                        <div className="w-full px-8">
                            {defaultTab === "login" ? <LoginForm /> : <RegisterForm />}
                        </div>
                    </div>

                    {/* ── MOBILE LAYOUT — no card background, full width ── */}
                    <div className="flex lg:hidden w-full flex-col">

                        {/* Mobile header: logo + heading + dynamic subtitle */}
                        <div className="w-full flex flex-col items-center mb-6 select-none" dir="rtl">
                            <Image
                                src="/assets/images/logoapp.png"
                                alt="شطارة"
                                width={180}
                                height={65}
                                priority
                                className="object-contain mb-4"
                            />
                            <h1
                                className="text-[20px] font-bold mb-1.5 text-center leading-snug"
                                style={{ color: "#5C4033" }}
                            >
                                {activeTab === "login" ? "مرحبًا بعودتك!" : "عضو جديد في شطارة!"}
                            </h1>
                            <p
                                className="text-[13px] text-center px-4 leading-6"
                                style={{ color: "#6B4E45" }}
                            >
                                {mobileSubtitle}
                            </p>
                        </div>

                        {/* Tab selector — pill / segmented control style */}
                        <div
                            className="flex bg-[#F3EEF7] rounded-2xl p-1 w-full mb-6"
                            dir="rtl"
                        >
                            {/* تسجيل الدخول — appears on the RIGHT in RTL */}
                            <button
                                type="button"
                                onClick={() => setActiveTab("login")}
                                className={`flex-1 py-2.5 text-center text-sm font-bold rounded-xl transition-all duration-200 ${activeTab === "login"
                                        ? "bg-[#A67BC4] text-white shadow-sm"
                                        : "text-[#8C7467] hover:text-[#5C4033]"
                                    }`}
                            >
                                تسجيل الدخول
                            </button>
                            {/* إنشاء حساب — appears on the LEFT in RTL */}
                            <button
                                type="button"
                                onClick={() => setActiveTab("register")}
                                className={`flex-1 py-2.5 text-center text-sm font-bold rounded-xl transition-all duration-200 ${activeTab === "register"
                                        ? "bg-[#A67BC4] text-white shadow-sm"
                                        : "text-[#8C7467] hover:text-[#5C4033]"
                                    }`}
                            >
                                إنشاء حساب
                            </button>
                        </div>

                        {/* Active form — switches on tab click */}
                        <div className="w-full px-4">
                            {activeTab === "login" ? <LoginForm /> : <RegisterForm />}
                        </div>

                    </div>
                </div>

                {/* ── FOOTER — desktop only ── */}
                <footer
                    className="hidden lg:flex relative z-10 flex-col lg:flex-row items-center justify-center gap-4 lg:gap-24 w-full max-w-[1344px] mx-auto pt-6 pb-2 text-[12px] font-medium"
                    style={{ color: "#6b5042", opacity: 0.85 }}
                >
                    {/* Links column — aligns with shatara image */}
                    <div className="w-full lg:w-[55%] flex justify-center shrink-0">
                        <div className="w-full max-w-[540px] flex justify-center lg:justify-start gap-6">
                            <Link href="/privacy" className="hover:underline">
                                سياسة الملكية الفكرية
                            </Link>
                            <Link href="/terms" className="hover:underline">
                                الشروط و الأحكام
                            </Link>
                        </div>
                    </div>

                    {/* Copyright column — aligns with form card */}
                    <div className="w-full lg:w-[390px] shrink-0 flex justify-center lg:justify-end text-center lg:text-right">
                        <div>ميدان شطارة. جميع الحقوق محفوظة © 2026</div>
                    </div>
                </footer>

            </div>
        </div>
    );
}
