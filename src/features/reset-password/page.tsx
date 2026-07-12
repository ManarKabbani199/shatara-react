import type { Metadata } from "next";
import ResetPasswordWrapper from "@/features/auth/components/ResetPasswordWrapper";

export const metadata: Metadata = {
    title: "تعيين كلمة مرور جديدة | شطارة",
    description: "قم بتعيين كلمة مرور جديدة لحسابك في شطارة",
};

export default function ResetPasswordPage() {
    return <ResetPasswordWrapper />;
}
