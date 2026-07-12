import type { Metadata } from "next";
import MobileAuthWrapper from "@/features/auth/components/MobileAuthWrapper";

export const metadata: Metadata = {
    title: "إنشاء حساب | شطارة",
    description: "أنشئ حسابك في منصة شطارة وانضم إلى مجتمع شطارة",
};

export default function RegisterPage() {
    return <MobileAuthWrapper defaultTab="register" />;
}
