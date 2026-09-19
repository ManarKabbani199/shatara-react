"use client";

import React from "react";
import Image from "next/image";
import Link from "next/link";
import { CONTACT } from "@/config/constants";

export default function ForgotPasswordWrapper() {

    return (
        <div className="w-full min-h-screen flex items-center justify-center relative overflow-hidden bg-white lg:bg-[url('/assets/images/login-bg.webp')] lg:bg-cover lg:bg-center lg:bg-no-repeat">
            <div className="relative w-full max-w-[1440px] min-h-screen flex flex-col px-4 pt-6 pb-4 lg:pt-[32px] lg:pr-[48px] lg:pb-[24px] lg:pl-[48px]" dir="ltr">

                <div className="relative z-10 flex flex-row items-center justify-center gap-16 lg:gap-24 w-full max-w-[1344px] mx-auto flex-1" style={{ marginTop: "24px" }}>
                    {/* Image side - desktop only */}
                    <div className="hidden lg:flex items-center justify-center shrink-0" style={{ width: "55%" }}>
                        <img src="/assets/images/auth-pieces.webp" alt="Shatara Pieces" className="w-full max-w-[540px] h-auto object-contain" style={{ maxHeight: "430px" }} />
                    </div>

                    {/* Form side */}
                    <div
                        className="w-full lg:w-[480px] shrink-0 flex flex-col justify-center py-6 lg:py-14 px-6 lg:px-12 rounded-3xl shadow-2xl"
                        dir="rtl"
                        style={{
                            backgroundImage: "url('/assets/images/backhome.webp')",
                            backgroundSize: "100% 100%",
                            backgroundPosition: "center",
                            backgroundRepeat: "no-repeat",
                        }}
                    >
                        <div className="w-full flex flex-col items-center mb-6 lg:mb-10 select-none">
                            <Image src="/assets/images/logoapp.png" alt="شطارة" width={220} height={80} priority className="object-contain" />
                        </div>

                        <div className="w-full text-center mb-5">
                            <h1 className="text-[18px] font-bold mb-2 leading-snug" style={{ color: "#6B4E45" }}>نسيت كلمة المرور</h1>
                            <p className="text-[14px] leading-6" style={{ color: "#6B4E45" }}>
                                استعادة كلمة المرور عبر البريد الإلكتروني غير متاحة حالياً.
                                لإعادة تعيين كلمة المرور، تواصل معنا على{" "}
                                <a href={`mailto:${CONTACT.email}`} className="font-bold hover:underline" style={{ color: "#AB86B9" }}>
                                    {CONTACT.email}
                                </a>
                            </p>
                        </div>

                        <div className="w-full mt-6 text-center">
                            <Link href="/login" className="text-sm font-bold hover:underline" style={{ color: "#6B4E45" }}>العودة لتسجيل الدخول</Link>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
