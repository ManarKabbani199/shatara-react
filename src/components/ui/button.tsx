'use client';

import { cn } from '@/lib/utils';

interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'green' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  disabled?: boolean;
  type?: 'button' | 'submit' | 'reset';
  className?: string;
  onClick?: () => void;
  children?: React.ReactNode;
  ariaLabel?: string;
}

export function Button({
  variant = 'primary',
  size = 'md',
  loading = false,
  disabled = false,
  type = 'button',
  className,
  onClick,
  children,
  ariaLabel,
}: ButtonProps) {
  const baseStyles =
    'inline-flex items-center justify-center font-alexandria font-bold transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-brand-purple/50 disabled:opacity-50 disabled:cursor-not-allowed active:scale-[0.97]';

  const variants = {
    primary: 'bg-brand-purple text-white hover:bg-brand-purple/90 shadow-lg shadow-brand-purple/25 hover:shadow-brand-purple/40',
    secondary: 'bg-brand-brown text-white hover:bg-brand-brown/90',
    green: 'bg-brand-green text-white hover:bg-brand-green/90 shadow-lg shadow-brand-green/25',
    outline: 'border-2 border-brand-purple text-brand-purple hover:bg-brand-purple/10',
  };

  const sizes = {
    sm: 'px-3 py-1.5 text-xs rounded-lg',
    md: 'px-4 py-2.5 text-sm rounded-xl',
    lg: 'px-6 py-3 text-base rounded-xl',
  };

  return (
    <button
      className={cn(baseStyles, variants[variant], sizes[size], className)}
      disabled={disabled || loading}
      type={type}
      onClick={onClick}
      aria-label={ariaLabel}
    >
      {loading ? (
        <span className="flex items-center gap-2">
          <svg
            className="animate-spin h-4 w-4"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle
              className="opacity-25"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              strokeWidth="4"
            />
            <path
              className="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
            />
          </svg>
          جارٍ التحميل...
        </span>
      ) : (
        children
      )}
    </button>
  );
}