/// Flavor text (lore) for every conquest territory, shown in the
/// territory detail sheet to give each battle a story.
class TerritoryLore {
  TerritoryLore._();

  static const Map<String, Map<String, String>> byId = {
    'T000': {
      'ar': 'هنا بدأ كل شيء… قلعتك الأولى وبوابة أسطورتك.',
      'en': 'Where it all began — your first castle and the gate of your legend.',
    },
    'T001': {
      'ar': 'سهول خضراء هادئة، لكن جنود الظلام لا يرحمون أحداً.',
      'en': 'Calm green plains, yet the soldiers of darkness spare no one.',
    },
    'T002': {
      'ar': 'مزرعة مسالمة تخفي مقاتلين يدافعون عن أرضهم بشراسة.',
      'en': 'A peaceful farm hiding fierce fighters defending their land.',
    },
    'T003': {
      'ar': 'من أعلى البرج يرى الحارس كل خطوة… حتى خطواتك.',
      'en': 'From atop the tower, the guard sees every step — even yours.',
    },
    'T004': {
      'ar': 'التجار هنا يبيعون كل شيء… إلا الهزيمة بثمن رخيص.',
      'en': 'Merchants here sell everything — except cheap defeat.',
    },
    'T005': {
      'ar': 'في هذا المعسكر يُصنع الأبطال… أو يُسحقون.',
      'en': 'In this camp, heroes are forged — or crushed.',
    },
    'T006': {
      'ar': 'بوابة الفيافي، من يعبرها لا يعود كما كان.',
      'en': 'The desert gate — whoever crosses never returns the same.',
    },
    'T007': {
      'ar': 'واحة خدّاعة؛ ماؤها عذب ورمالها تبتلع الغرباء.',
      'en': 'A deceiving oasis — sweet water, but sands that swallow strangers.',
    },
    'T008': {
      'ar': 'قائد الرمال لا يعرف الرحمة وسط العواصف.',
      'en': 'The sands commander knows no mercy amid the storms.',
    },
    'T009': {
      'ar': 'مقبرة الملوك القدماء… وحرّاسها لا ينامون أبداً.',
      'en': 'Tomb of ancient kings — its guardians never sleep.',
    },
    'T010': {
      'ar': 'سوق يغلي بالصفقات، وخلف كل بسطة سيف مُصلت.',
      'en': 'A market buzzing with deals — and a drawn sword behind every stall.',
    },
    'T011': {
      'ar': '👑 سيد الرياح يحكم الفيافي بعاصفة من الغضب.',
      'en': '👑 The Wind Lord rules the wastes with a storm of fury.',
    },
    'T012': {
      'ar': 'غابة يهمس شجرها بأسرار الممالك القديمة.',
      'en': 'A forest whose trees whisper secrets of ancient kingdoms.',
    },
    'T013': {
      'ar': 'اللصوص هنا يسرقون كل شيء… حتى انتصارك.',
      'en': 'The thieves here steal everything — even your victory.',
    },
    'T014': {
      'ar': 'ضباب البحيرة يخفي الحقيقة ويُضلّل الشجعان.',
      'en': 'The lake mist hides the truth and misleads the brave.',
    },
    'T015': {
      'ar': '👑 كاهن القمر يستمد قوته من ضوء الليل البارد.',
      'en': '👑 The Moon Priest draws his power from the cold night light.',
    },
    'T016': {
      'ar': 'قرية صغيرة بقلوب كبيرة… ومعاول أصغر من خصومها.',
      'en': 'A small village with big hearts — and pickaxes smaller than its foes.',
    },
    'T017': {
      'ar': 'من يدخل الكهف يسمع زئير الوحوش من بعيد… إن عاد.',
      'en': 'Enter the cave and hear the beasts roar — if you return.',
    },
    'T018': {
      'ar': 'ممر ضيق بين الجبال، لا يعبره إلا المقدام.',
      'en': 'A narrow pass between mountains — only the daring cross it.',
    },
    'T019': {
      'ar': '👑 سيد الجليد يجمّد قلوب أعدائه قبل سيوفهم.',
      'en': '👑 The Ice Lord freezes his enemies’ hearts before their swords.',
    },
    'T020': {
      'ar': 'منجم الفضة ثروة المملكة… ومحروس بأسنان فولاذية.',
      'en': 'The silver mine, the kingdom’s fortune — guarded by steel teeth.',
    },
    'T021': {
      'ar': 'جسر الموت: خطوة واحدة خاطئة ولا رجوع.',
      'en': 'The Bridge of Death — one wrong step and no return.',
    },
    'T022': {
      'ar': 'على القمة تتكلم العواصف وحدها… وتتكلم بلغة السيوف.',
      'en': 'At the summit, only storms speak — in the language of swords.',
    },
    'T023': {
      'ar': '👑 التنين العجوز ينام على كنوز العصور… ويستيقظ غاضباً.',
      'en': '👑 The Old Dragon sleeps on ancient treasures — and wakes enraged.',
    },
    'T024': {
      'ar': 'ضواحي العاصمة، أول خطوط الدفاع عن العرش.',
      'en': 'The capital outskirts — the throne’s first line of defense.',
    },
    'T025': {
      'ar': 'سوق العاصمة حيث تُباع الانتصارات قبل أن تُقاتَل.',
      'en': 'The capital market, where victories are sold before they are fought.',
    },
    'T026': {
      'ar': 'ساحة الأبطال لا تتذكر إلا من انتصر فيها.',
      'en': 'The Heroes’ Arena remembers only those who triumphed in it.',
    },
    'T027': {
      'ar': 'قصر الملك شاهد على ألف مؤامرة وألف معركة.',
      'en': 'The King’s Palace has witnessed a thousand plots and battles.',
    },
    'T028': {
      'ar': 'برج السحر تتلألأ نوافذه بقوى لا يفهمها البشر.',
      'en': 'The Magic Tower gleams with powers no human understands.',
    },
    'T029': {
      'ar': '👑 عرش المملكة… هزم ملك الظلام أو تُمحى أسطورتك.',
      'en': '👑 The Kingdom’s Throne — defeat the Dark King or your legend fades.',
    },
  };
}
