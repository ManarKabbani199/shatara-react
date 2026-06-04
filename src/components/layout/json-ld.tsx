export function JsonLd() {
  const schema = {
    '@context': 'https://schema.org',
    '@type': 'Organization',
    name: 'شطارة',
    alternateName: 'Shatara',
    url: 'https://shatara.sa',
    logo: 'https://shatara.sa/assets/images/logon.png',
    contactPoint: {
      '@type': 'ContactPoint',
      email: 'shatara@shatara.sa',
      telephone: '+966548929642',
      contactLanguage: 'Arabic',
      availableLanguage: ['Arabic', 'English'],
    },
    description:
      'شطارة لعبة ذهنية استراتيجية مبتكرة، تعتمد على بناء القرار وإدارة القوة داخل بيئة لعب منضبطة',
    areaServed: {
      '@type': 'Country',
      name: 'Saudi Arabia',
    },
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
    />
  );
}