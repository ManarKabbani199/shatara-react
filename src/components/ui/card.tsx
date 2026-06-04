import { cn } from '@/lib/utils';

interface CardProps {
  children: React.ReactNode;
  className?: string;
  borderColor?: string;
}

export function Card({ children, className, borderColor = 'brand-silver' }: CardProps) {
  return (
    <div
      className={cn(
        'p-4 rounded-2xl border transition-all duration-300 hover:shadow-lg hover:shadow-brand-purple/10',
        borderColor === 'brand-silver' ? 'border-brand-silver/80' : `border-${borderColor}`,
        'bg-white',
        className,
      )}
    >
      {children}
    </div>
  );
}