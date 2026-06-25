'use client';

export function BoardDiagram() {
  return (
    <div className="w-full overflow-x-auto">
      <svg
        viewBox="0 0 820 480"
        className="w-full min-w-[600px] h-auto"
        role="img"
        aria-label="رسم توضيحي لرقعة ميدان شطارة مع منطقتي الدعم الجانبيتين"
      >
        <defs>
          <pattern id="grid" width="50" height="50" patternUnits="userSpaceOnUse">
            <path d="M 50 0 L 0 0 0 50" fill="none" stroke="#D1C4B8" strokeWidth="1" />
          </pattern>
        </defs>

        {/* Background */}
        <rect x="0" y="0" width="820" height="480" fill="#FAFAF8" rx="12" />

        {/* Main board frame */}
        <g transform="translate(300, 40)">
          <rect x="0" y="0" width="400" height="400" fill="#FFFFFF" stroke="#6B4E45" strokeWidth="2" rx="4" />
          <rect x="0" y="0" width="400" height="400" fill="url(#grid)" />
          {/* Stronger border for main play zone */}
          <rect x="2" y="2" width="396" height="396" fill="none" stroke="#6B4E45" strokeWidth="2" />

          {/* Main board column labels (A-H) */}
          {['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'].map((label, i) => (
            <text
              key={`col-${label}`}
              x={25 + i * 50}
              y={425}
              textAnchor="middle"
              fontSize="14"
              fill="#6B4E45"
              fontWeight="600"
            >
              {label}
            </text>
          ))}

          {/* Main board row labels (1-8) */}
          {['1', '2', '3', '4', '5', '6', '7', '8'].map((label, i) => (
            <text
              key={`row-${label}`}
              x={-15}
              y={375 - i * 50}
              textAnchor="middle"
              fontSize="14"
              fill="#6B4E45"
              fontWeight="600"
            >
              {label}
            </text>
          ))}

          {/* Center line emphasis */}
          <line x1="0" y1="200" x2="400" y2="200" stroke="#6B4E45" strokeWidth="1.5" opacity="0.6" />
        </g>

        {/* Top support zone */}
        <g transform="translate(40, 40)">
          <rect x="0" y="0" width="200" height="160" fill="#FFFFFF" stroke="#AB86B9" strokeWidth="2" rx="4" />
          <rect x="0" y="0" width="200" height="160" fill="url(#grid)" />
          {['I', 'J', 'K', 'L'].map((label, i) => (
            <text
              key={`top-col-${label}`}
              x={25 + i * 50}
              y={185}
              textAnchor="middle"
              fontSize="13"
              fill="#AB86B9"
              fontWeight="600"
            >
              {label}
            </text>
          ))}
          {['1', '2', '3', '4'].map((label, i) => (
            <text
              key={`top-row-${label}`}
              x={-12}
              y={135 - i * 40}
              textAnchor="middle"
              fontSize="13"
              fill="#AB86B9"
              fontWeight="600"
            >
              {label}
            </text>
          ))}
          <text x="100" y="-18" textAnchor="middle" fontSize="13" fill="#6B4E45" fontWeight="700">
            دعم اللاعب الأول
          </text>
        </g>

        {/* Bottom support zone */}
        <g transform="translate(40, 280)">
          <rect x="0" y="0" width="200" height="160" fill="#FFFFFF" stroke="#AB86B9" strokeWidth="2" rx="4" />
          <rect x="0" y="0" width="200" height="160" fill="url(#grid)" />
          {['I', 'J', 'K', 'L'].map((label, i) => (
            <text
              key={`bot-col-${label}`}
              x={25 + i * 50}
              y={185}
              textAnchor="middle"
              fontSize="13"
              fill="#AB86B9"
              fontWeight="600"
            >
              {label}
            </text>
          ))}
          {['1', '2', '3', '4'].map((label, i) => (
            <text
              key={`bot-row-${label}`}
              x={-12}
              y={135 - i * 40}
              textAnchor="middle"
              fontSize="13"
              fill="#AB86B9"
              fontWeight="600"
            >
              {label}
            </text>
          ))}
          <text x="100" y="-18" textAnchor="middle" fontSize="13" fill="#6B4E45" fontWeight="700">
            دعم اللاعب الثاني
          </text>
        </g>

        {/* Decorative measurement brackets */}
        <g stroke="#E57373" strokeWidth="1.2" fill="none" opacity="0.8">
          {/* Right side measurement */}
          <path d="M 720 40 L 735 40 L 735 440 L 720 440" />
          <line x1="735" y1="240" x2="745" y2="240" />
          <text x="755" y="244" fill="#E57373" stroke="none" fontSize="12" fontWeight="600">
            40 سم
          </text>

          {/* Bottom measurement */}
          <path d="M 300 455 L 300 470 L 700 470 L 700 455" />
          <line x1="500" y1="470" x2="500" y2="480" />
          <text x="500" y="495" fill="#E57373" stroke="none" fontSize="12" fontWeight="600" textAnchor="middle">
            40 سم
          </text>
        </g>
      </svg>
    </div>
  );
}
