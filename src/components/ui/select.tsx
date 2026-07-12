import { forwardRef } from 'react';
import { cn } from '@/lib/utils';

interface SelectProps extends React.SelectHTMLAttributes<HTMLSelectElement> {
  label?: string;
  error?: string;
  icon?: React.ReactNode;
  options: { value: string; label: string }[];
}

export const Select = forwardRef<HTMLSelectElement, SelectProps>(
  ({ label, error, icon, options, className, id, ...props }, ref) => {
    const selectId = id ?? label?.replace(/\s/g, '-');

    return (
      <div className="flex flex-col gap-1.5">
        {label && (
          <label
            htmlFor={selectId}
            className="text-xs font-semibold text-text-secondary"
          >
            {label}
          </label>
        )}
        <div className="relative">
          <select
            ref={ref}
            id={selectId}
            className={cn(
              'w-full min-w-0 appearance-none bg-white border border-border-default rounded-lg py-3 text-sm font-alexandria text-brand-brown',
              'focus:border-border-focus focus:outline-none focus:ring-1 focus:ring-border-focus',
              error && 'border-red-500',
              icon ? 'ps-12 pe-12' : 'px-3 pe-12',
              className,
            )}
            {...props}
          >
            <option value="">اختر...</option>
            {options.map((opt) => (
              <option key={opt.value} value={opt.value}>
                {opt.label}
              </option>
            ))}
          </select>
          {icon && (
            <span className="absolute start-3 top-1/2 -translate-y-1/2 text-text-secondary pointer-events-none">
              {icon}
            </span>
          )}
          <span className="absolute end-3 top-1/2 -translate-y-1/2 pointer-events-none text-brand-brown">
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
            </svg>
          </span>
        </div>
        {error && <p className="text-xs text-red-500">{error}</p>}
      </div>
    );
  },
);

Select.displayName = 'Select';
