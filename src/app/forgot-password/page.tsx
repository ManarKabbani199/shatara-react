import type { Metadata } from "next";
import ForgotPasswordWrapper from "@/features/auth/components/ForgotPasswordWrapper";

export const metadata: Metadata = {
    title: "نسيت كلمة المرور | شطارة",
    description: "أدخل بريدك الإلكتروني لاستعادة كلمة المرور الخاصة بك",
};

export default function ForgotPasswordPage() {
    return <ForgotPasswordWrapper />;
}
