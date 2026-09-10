export const COLORS = {
  brandBrown: '#6B4E45',
  brandPurple: '#AB86B9',
  brandGreen: '#06AC2A',
  brandSilver: '#C0C0C0',
  surfaceLight: '#EFF3F7',
  surfaceWhite: '#FFFFFF',
  textPrimary: '#6B4E45',
  textSecondary: '#6B7280',
  borderDefault: '#E5E7EB',
  borderFocus: '#CBD5E1',
} as const;

export const URLS = {
  store: 'https://store.shatara.sa',
  guide: '/shatraBooks.pdf',
  club: 'https://hawi.gov.sa/club/club-details/hxsdFo0dsfyUZLqg2bY0ljSyu3yBXW3UvxMl3Jk3P466Por21Ldno4TUsJotNQHdQsw9PqBv40E',
} as const;

export const CONTACT = {
  email: 'shatara@shatara.sa',
  phone: '+966 54 892 9642',
} as const;

// Official social profile URLs. An empty string means the icon stays hidden
// in the footer — paste the real URL here to activate it.
export const SOCIALS = {
  twitter: '', // X (Twitter)
  instagram: '',
  facebook: '',
  youtube: '',
  linkedin: '',
} as const;

// Feature flags for sections pending external decisions.
export const FEATURES = {
  // Newsletter form stays hidden until a mailing service (e.g. Mailchimp) is chosen.
  newsletter: false,
} as const;

export const COUNTRIES_AR = [
  'السعودية',
  'الكويت',
  'قطر',
  'الإمارات',
  'البحرين',
  'عُمان',
  'مصر',
  'الأردن',
  'لبنان',
  'العراق',
  'سوريا',
  'فلسطين',
  'اليمن',
  'المغرب',
  'الجزائر',
  'تونس',
  'ليبيا',
  'السودان',
] as const;

export const SITE = {
  name: 'شطارة',
  nameEn: 'Shatara',
  description: 'شطارة لعبة ذهنية استراتيجية مبتكرة، تعتمد على بناء القرار وإدارة القوة داخل بيئة لعب منضبطة',
  url: 'https://shatara.sa',
  ogImage: '/assets/images/og-image.png',
} as const;