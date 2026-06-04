'use client';

import { useVisitor } from '@/features/visitor/hooks/use-visitor';

export function VisitorTracker() {
  useVisitor();
  return null;
}
