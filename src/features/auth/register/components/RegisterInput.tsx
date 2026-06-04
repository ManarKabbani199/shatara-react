"use client";

import React, { useState, InputHTMLAttributes } from "react";
import { Eye, EyeOff, AtSign, Lock, Mail, User, Phone } from "lucide-react";

interface RegisterInputProps extends InputHTMLAttributes<HTMLInputElement> {
    icon: "name" | "username" | "email" | "phone" | "password";
    placeholder: string;
    leftSlot?: React.ReactNode; // optional element on left side (e.g. country code picker)
}

export default function RegisterInput({
    icon,
    placeholder,
    type: initialType = "text",
    leftSlot,
    ...props
}: RegisterInputProps) {
    const [showPassword, setShowPassword] = useState(false);
    const isPassword = icon === "password";
    const inputType = isPassword
        ? showPassword ? "text" : "password"
        : initialType;

    return (
        <div
            dir="rtl"
            className="flex items-center w-full border border-[#E5D7CE] rounded-xl bg-white/70 backdrop-blur-sm overflow-hidden
                 focus-within:border-[#9A8174] focus-within:ring-1 focus-within:ring-[#9A8174]/20
                 transition-all duration-200 h-11"
        >
            {/* RIGHT: icon */}
            <div className="flex items-center justify-center w-10 h-full shrink-0 text-[#8C7467]">
                {icon === "name"     && <User   size={18} strokeWidth={1.5} />}
                {icon === "username" && <AtSign size={18} strokeWidth={1.5} />}
                {icon === "email"    && <Mail   size={18} strokeWidth={1.5} />}
                {icon === "phone"    && <Phone  size={18} strokeWidth={1.5} />}
                {icon === "password" && <Lock   size={18} strokeWidth={1.5} />}
            </div>

            {/* CENTER: Arabic input */}
            <input
                {...props}
                type={inputType}
                placeholder={placeholder}
                className="flex-1 h-full bg-transparent text-sm text-[#5C4033] placeholder-[#8C7467]/70 outline-none text-right px-2 font-medium"
            />

            {/* LEFT: eye toggle (password) OR custom slot (e.g. country code) */}
            {isPassword ? (
                <button
                    type="button"
                    onClick={() => setShowPassword((v) => !v)}
                    className="flex items-center justify-center w-10 h-full shrink-0 text-[#8C7467] hover:text-[#5C4033] transition-colors"
                    aria-label={showPassword ? "إخفاء كلمة المرور" : "إظهار كلمة المرور"}
                >
                    {showPassword
                        ? <Eye    size={18} strokeWidth={1.5} />
                        : <EyeOff size={18} strokeWidth={1.5} />
                    }
                </button>
            ) : leftSlot ? (
                <div className="shrink-0 h-full flex items-center border-r border-[#E5D7CE]">
                    {leftSlot}
                </div>
            ) : null}
        </div>
    );
}
