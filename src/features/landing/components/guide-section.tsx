'use client';

export function GuideSection() {
  return (
    <section
      className="relative min-h-[400px] sm:min-h-[500px] bg-black bg-cover bg-center bg-no-repeat overflow-hidden flex items-center justify-center p-6 sm:p-12"
      dir="rtl"
      style={{
        backgroundImage: "url('/assets/images/19 1.png')",
      }}
    >
      <div className="relative max-w-5xl w-full flex justify-center">
        <img
          src="/assets/images/Left side 8 Column.png"
          alt="Panel"
          className="max-h-[80vh] w-auto object-contain rounded-2xl shadow-2xl scale-110 md:scale-115 transition-all duration-300"
        />
      </div>
    </section>
  );
}







