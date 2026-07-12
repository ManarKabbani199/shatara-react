import { forwardRef } from 'react';
import { cn } from '@/lib/utils';

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  icon?: React.ReactNode;
  endElement?: React.ReactNode;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, error, icon, endElement, className, id, ...props }, ref) => {
    const inputId = id ?? label?.replace(/\s/g, '-');
    const hasEnd = Boolean(icon || endElement);

    return (
      <div className="flex flex-col gap-1.5">
        {label && (
          <label
            htmlFor={inputId}
            className="text-xs font-semibold text-text-secondary"
          >
            {label}
          </label>
        )}
        <div className="relative">
          <input
            ref={ref}
            id={inputId}
            dir={props.type === 'tel' ? 'rtl' : undefined}
            className={cn(
              'w-full min-w-0 bg-white border border-border-default rounded-lg py-3 ps-3 text-sm font-alexandria text-brand-brown',
              'placeholder:text-text-secondary/60',
              'focus:border-border-focus focus:outline-none focus:ring-1 focus:ring-border-focus',
              error && 'border-red-500 focus:border-red-500 focus:ring-red-500',
              hasEnd ? 'pe-12' : 'pe-3',
              className,
            )}
            {...props}
          />
          {icon && (
            <span className="absolute end-3 top-1/2 -translate-y-1/2 text-text-secondary pointer-events-none">
              {icon}
            </span>
          )}
          {endElement && (
            <span className="absolute end-3 top-1/2 -translate-y-1/2 text-text-secondary">
              {endElement}
            </span>
          )}
        </div>
        {error && <p className="text-xs text-red-500">{error}</p>}
      </div>
    );
  },
);

Input.displayName = 'Input';
