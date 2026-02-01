// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get voiceHelpTitle => 'إرشادات اختبار الصوت';

  @override
  String get voiceHelpFirstMain => '1. تجهيز محيطك';

  @override
  String get voiceHelpFirstMainFirstSubTitle => 'ابحث عن مكان هادئ:';

  @override
  String get voiceHelpFirstMainFirstSubDesc => 'اختر غرفة خالية من الضوضاء أو أي مصادر تشتيت.';

  @override
  String get voiceHelpFirstMainSecondSubTitle => 'ضع الهاتف بشكل صحيح:';

  @override
  String get voiceHelpFirstMainSecondSubDesc => 'أمسك الجهاز على بُعد حوالي 20 سم (8 بوصات) من فمك.';

  @override
  String get voiceHelpSecondMainTitle => '2. إجراء الاختبار';

  @override
  String get voiceHelpSecondMainFirstSubTitle => 'الخطوة 1:';

  @override
  String get voiceHelpSecondMainFirstSubDesc => 'نطق \"AAA\", خذ نفسًا عميقًا واصدر صوت \"AAA\" بثبات (كما في كلمة \"apple\") لمدة 3 ثوانٍ.';

  @override
  String get voiceHelpSecondMainSecondSubTitle => 'الخطوة 2:';

  @override
  String get voiceHelpSecondMainSecondSubDesc => 'نطق \"OOO\", سينتقل التطبيق تلقائيًا. اصدر صوت \"OOO\" بثبات (كما في كلمة \"boot\") لمدة 3 ثوانٍ أخرى.';

  @override
  String get voiceHelpThirdMain => '3. نصائح مهمة للحصول على نتائج دقيقة';

  @override
  String get voiceHelpThirdMainFirstSubTitle => 'كن طبيعيًا:';

  @override
  String get voiceHelpThirdMainFirstSubDesc => 'استخدم مستوى الصوت وطبقة الصوت الطبيعية لديك. لا تحاول \"تصحيح\" صوتك؛ فالذكاء الاصطناعي يحتاج إلى سماع نبرة صوتك الحقيقية لتقديم تقييم موضوعي.';

  @override
  String get voiceHelpThirdMainSecondSubTitle => 'لا تقلق بشأن الإهتزازات:';

  @override
  String get voiceHelpThirdMainSecondSubDesc => 'إذا اهتز صوتك أو انقطع، لا تعيد التسجيل. هذه التغيرات الدقيقة هي ما يستخدمه الذكاء الاصطناعي لقياس الأعراض بدقة.';

  @override
  String get noNameError => 'خطأ، لا يوجد اسم لهذا المسار';

  @override
  String get uploadingLoading => 'جارٍ الرفع';

  @override
  String get analyezedSuccessfully => 'تم التحليل بنجاح';

  @override
  String get uploadFailed => 'فشل الرفع، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get errorOccured => 'حدث خطأ، يرجى التأكد من اتصالك بالإنترنت.';

  @override
  String get failedRecording => 'فشل بدء التسجيل، الأذونات مطلوبة';

  @override
  String get recordOrder => 'انطق الصوت';

  @override
  String get toneA => '”AAA“';

  @override
  String get toneO => '”OOO“';
}
