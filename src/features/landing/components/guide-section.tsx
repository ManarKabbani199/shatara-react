'use client';

import { HiDownload } from 'react-icons/hi';
import { URLS } from '@/config/constants';
import { BoardDiagram } from './board-diagram';

export function GuideSection() {
  return (
    <section
      className="relative min-h-[500px] sm:min-h-[600px] bg-black bg-cover bg-center bg-no-repeat overflow-hidden flex items-center justify-center p-4 sm:p-8 lg:p-12"
      dir="rtl"
      style={{
        backgroundImage: "url('/assets/images/19 1.png')",
      }}
    >
      <div className="relative w-full max-w-5xl">
        <div className="bg-[#F5F3F0] rounded-3xl shadow-2xl overflow-hidden max-h-[85vh] flex flex-col">
          {/* Header */}
          <div className="flex items-center justify-between gap-4 bg-[#1F1F1F] px-5 sm:px-8 py-4 sm:py-5 flex-shrink-0">
            <h2 className="text-xl sm:text-2xl lg:text-3xl font-bold text-white">
              دليل شطارة
            </h2>
            <a
              href={URLS.guide}
              download
              className="inline-flex items-center gap-2 px-4 sm:px-6 py-2 sm:py-2.5 bg-[#06AC2A] hover:bg-[#059622] text-white text-sm sm:text-base font-bold rounded-xl transition-colors shadow-lg"
            >
              <HiDownload className="w-4 h-4 sm:w-5 sm:h-5" />
              <span>تحميل</span>
            </a>
          </div>

          {/* Scrollable content */}
          <div className="overflow-y-auto p-5 sm:p-8 lg:p-10 space-y-8 sm:space-y-10">
            {/* Definition */}
            <article className="bg-white rounded-2xl p-5 sm:p-8 shadow-sm border border-[#E8E4DE]">
              <h3 className="text-lg sm:text-xl lg:text-2xl font-bold text-[#6B4E45] mb-4 text-center">
                تعريف ميدان شطارة
              </h3>
              <div className="space-y-4 text-[#6B4E45] text-sm sm:text-base leading-[1.9] text-justify">
                <p>
                  ميدان شطارة هو لعبة ذهنية استراتيجية تقوم على إدارة وبناء القوة عبر نظام تدريجي، من خلال وجود منطقة داعم، حيث تنقسم الرقعة إلى منطقة اللعب الرئيسية ومنطقة دعم خاصة بكل لاعب.
                </p>
                <p>
                  تمارس اللعبة على رقعة مخصصة ذات بنية هندسية محددة، باستخدام قطع لعب مصنّفة إلى مراتب قوة متتابعة، وتُدار وفق مجموعة من القوانين التي تنظّم الحركة، التدرّج، التعزيز، الترقية، والحسم.
                </p>
                <p>
                  ويُعدّ ميدان شطارة نظام لعب قائم بذاته، له بنية وقواعد وتعريف مستقل، ويتعامل في جميع استخداماته بوصفه لعبة ذهنية.
                </p>
              </div>
            </article>

            {/* Components — Board */}
            <article className="bg-white rounded-2xl p-5 sm:p-8 shadow-sm border border-[#E8E4DE]">
              <div className="flex flex-col sm:flex-row sm:items-center gap-3 mb-5 border-r-4 border-[#AB86B9] pr-4">
                <h3 className="text-lg sm:text-xl lg:text-2xl font-bold text-[#6B4E45]">
                  مكونات اللعبة
                </h3>
                <span className="text-[#AB86B9] font-bold text-base sm:text-lg">
                  / الرقعة
                </span>
              </div>

              <div className="space-y-4 text-[#6B4E45] text-sm sm:text-base leading-[1.9] text-justify mb-8">
                <p>
                  الرقعة هي الساحة الفيزيائية التي تمارس عليها لعبة ميدان شطارة، وتمثّل الإطار المكاني الذي تنتظم فيه جميع الحركات والقرارات.
                </p>
                <p>
                  تتكوّن الرقعة من شبكة مربعات رئيسية ومنطقتي دعم جانبيين، وأضلاع وأبعاد هندسية محددة، وتصميم بصري معتمد تضمن وضوح الحركة وتوازن الرؤية بين اللاعبين.
                </p>
                <p>
                  ولا يُستبعد أي شكل من أشكال الأرضية رسمياً ما لم يطابق للمواصفات الهندسية المعتمدة في هذا الدليل.
                </p>
              </div>

              <div className="bg-[#FAFAF8] rounded-xl p-3 sm:p-5 border border-[#E8E4DE]">
                <BoardDiagram />
                <p className="text-center text-xs sm:text-sm text-[#6B7280] mt-3">
                  الشكل 1: رقعة ميدان شطارة (منطقة اللعب الرئيسية ومنطقتا الدعم)
                </p>
              </div>
            </article>

            {/* Full PDF viewer */}
            <article className="bg-white rounded-2xl p-5 sm:p-8 shadow-sm border border-[#E8E4DE]">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-5">
                <div className="border-r-4 border-[#06AC2A] pr-4">
                  <h3 className="text-lg sm:text-xl lg:text-2xl font-bold text-[#6B4E45]">
                    الدليل الكامل
                  </h3>
                  <p className="text-sm text-[#6B7280] mt-1">
                    تصفح جميع صفحات دليل شطارة مباشرة أدناه
                  </p>
                </div>
                <a
                  href={URLS.guide}
                  download
                  className="inline-flex items-center justify-center gap-2 px-5 py-2.5 bg-[#06AC2A] hover:bg-[#059622] text-white text-sm font-bold rounded-xl transition-colors shadow-md"
                >
                  <HiDownload className="w-4 h-4" />
                  <span>تحميل PDF</span>
                </a>
              </div>

              <div className="rounded-xl overflow-hidden border border-[#E8E4DE] bg-[#F5F3F0]">
                <iframe
                  src={URLS.guide}
                  title="دليل شطارة الكامل"
                  className="w-full h-[60vh] sm:h-[70vh] min-h-[400px]"
                  loading="lazy"
                />
                <p className="text-center text-xs text-[#6B7280] py-3 px-4">
                  إذا لم يظهر الملف أعلاه، يمكنك{' '}
                  <a
                    href={URLS.guide}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-[#06AC2A] font-semibold hover:underline"
                  >
                    فتحه في نافذة جديدة
                  </a>{' '}
                  أو{' '}
                  <a
                    href={URLS.guide}
                    download
                    className="text-[#06AC2A] font-semibold hover:underline"
                  >
                    تحميله
                  </a>
                  .
                </p>
              </div>
            </article>
          </div>
        </div>
      </div>
    </section>
  );
}
