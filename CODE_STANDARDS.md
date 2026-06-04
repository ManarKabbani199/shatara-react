# Code Standards — Chess Kings React (Next.js)

## 1. Tech Stack
- **Next.js 15** (App Router, SSG)
- **TypeScript 5+** (strict mode)
- **Tailwind CSS 4** (utility-first, RTL, mobile-first)
- **React Hook Form + Zod** (validation)
- **Firebase Web SDK v10+** (Auth, Firestore, RTDB)
- **react-hot-toast** (notifications)
- **react-icons** (FontAwesome + Material)

## 2. Project Structure
Feature-based under `src/features/`. No cross-feature imports.  
Shared code in `components/`, `hooks/`, `lib/`, `config/`, `types/`.

```
src/
├── app/                    # Next.js App Router pages
├── components/ui/          # Primitives (Button, Input, Card)
├── components/layout/      # Navbar, Footer, MobileDrawer
├── features/home/          # Home page feature
├── features/auth/          # Auth feature
├── features/visitor/       # Visitor tracking
├── lib/                    # Firebase init, utils
├── config/                 # Constants
├── hooks/                  # Shared hooks
└── types/                  # Global types
```

## 3. Naming Conventions
- Files/folders: `kebab-case`
- Components: `PascalCase`
- Hooks: `useKebabCase` files, `useCamelCase` exports
- Constants: `UPPER_SNAKE_CASE`
- Props interfaces: `ComponentNameProps`

## 4. Component Standards
- One component per file
- Max 150 lines — extract beyond that
- Always type props with explicit `interface`
- Regular function declarations, not `React.FC`
- Co-locate related files (tests, types, hooks)

## 5. TypeScript
- Strict mode
- No `any` — use `unknown` or proper types
- Prefer `interface` for objects, `type` for unions
- Zod schemas for runtime form validation

## 6. Styling (Tailwind)
- Mobile-first: base=mobile, `md:`=640px+, `lg:`=1024px+
- RTL: logical properties (`ps:`, `pe:`, `start:`, `end:`)
- Design tokens in `@theme inline` in `globals.css`
- Alexandria font via Google Fonts CDN
- No inline styles except dynamic JS values
- CSS-only animations: `fade-up`, `fade-left`, `fade-right`, `scale-in`, `stagger-children` classes
- Animations triggered once via `ScrollRevealProvider` (IntersectionObserver) — no re-renders
- Hover effects: `hover-lift` class for cards, CSS `transition` only — no Framer Motion

## 7. State Management
- `useState` for local UI state
- React Context for auth (`AuthContext` + `useAuth()`)
- React Hook Form for form state
- No Redux

## 8. Firebase
- Single `src/lib/firebase.ts` — init once, export instances
- `useAuth()` hook for all auth operations
- Never import Firebase directly in components
- Firestore writes: always typed, use `serverTimestamp()`

## 9. Forms
- React Hook Form + Zod
- Schemas co-located with form component
- Arabic error messages inline in schemas

## 10. Error Handling
- React Error Boundaries around major sections
- `react-hot-toast` for user-facing errors
- Form validation errors below inputs
- Never silently swallow errors

## 11. Accessibility
- `<label>` for all inputs
- `alt` attributes on all images (Arabic)
- Keyboard-navigable interactive elements
- Visible focus states (`focus:` ring)
- Semantic HTML (`<nav>`, `<main>`, `<footer>`, `<section>`)
- ARIA labels on icon-only buttons

## 12. Performance
- `next/image` for all images (auto WebP, lazy load)
- `<video poster>` + `preload="none"`
- `font-display: swap` via `next/font`
- Code-split route pages by default
- Lighthouse targets: Performance>=90, SEO>=95, Accessibility>=90

## 13. Code Quality
- ESLint: `airbnb-typescript` + React hooks + import order
- Prettier: printWidth 100, singleQuote, trailingComma 'all'
- Husky + lint-staged: pre-commit (lint + typecheck)
- Import order: React→External→Internal→Relative

## 14. Git Standards
- Branch naming: `feature/...`, `fix/...`, `chore/...`
- Conventional Commits: `feat:`, `fix:`, `chore:`
- No secrets in code — `.env.local` for Firebase config

## 15. SEO
- Per-page metadata via Next.js `metadata` export
- Open Graph + Twitter Cards on every page
- JSON-LD structured data (Organization schema)
- Canonical URLs on every page
- `robots.txt` + `sitemap.xml`
- Semantic HTML heading hierarchy

## 16. Geo-Targeting
- `<html lang="ar" dir="rtl">`
- `hreflang` tags for Arabic
- Geo meta tags: `<meta name="geo.region" content="SA" />`
- `Content-Language: ar-SA`
- Arabic `<title>` with brand pattern: `شطارة | وصف الصفحة`
- Arabic `alt` text on all images
- Google Search Console: target Saudi Arabia

## 17. Color Palette (Tailwind tokens)
```
brand-brown: '#6B4E45'
brand-purple: '#AB86B9'
brand-green: '#06AC2A'
brand-silver: '#C0C0C0'
surface-light: '#EFF3F7'
surface-white: '#FFFFFF'
text-primary: '#6B4E45'
text-secondary: '#6B7280'
border-default: '#E5E7EB'
border-focus: '#CBD5E1'
```

## 18. Responsive Breakpoints
- Mobile: 0–639px (default, no prefix)
- Tablet: 640–1023px (`md:`)
- Desktop: 1024px+ (`lg:`)
