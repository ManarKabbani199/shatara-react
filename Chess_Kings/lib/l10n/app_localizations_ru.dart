// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get changeLanguage => 'изменить язык';

  @override
  String get welcomeTo => 'Добро пожаловать в';

  @override
  String get pleaseLoginToContinue => 'Пожалуйста, войдите, чтобы продолжить';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get pleaseEnterCorrectEmail =>
      'Пожалуйста, введите правильный адрес электронной почты';

  @override
  String get passwordMustContainUppercaseAndLowercaseLettersAndNumbers =>
      'Пароль должен содержать заглавные и строчные буквы и цифры';

  @override
  String get lOGIN => 'АВТОРИЗОВАТЬСЯ';

  @override
  String get dontHaveAnAccountClickMe => 'Нет учетной записи? Нажмите «Мне»';

  @override
  String get signInWithGoogle => 'Войти через Google';

  @override
  String get errorInEmailOrPassword =>
      'Ошибка в адресе электронной почты или пароле';

  @override
  String get userName => 'Имя пользователя';

  @override
  String get signUp => 'Sign Up';

  @override
  String get onlyAlphabetsAreAllowedInAUsername =>
      'В имени пользователя допускаются только буквы алфавита';

  @override
  String get someErrorHappen => 'Произошла какая-то ошибка';

  @override
  String get playingWithTheComputer => 'Игра с компьютером';

  @override
  String get playNow => 'Играть сейчас';

  @override
  String get numberOfTimesYouLoginToSite => 'Number Of Times You Login To Site';

  @override
  String get numberOfTimesYouPlayWithTheComputer =>
      'Количество раз, когда вы играете с компьютером';

  @override
  String get numberOfWinsOverTheComputer => 'Количество побед над компьютером';

  @override
  String get playWithSomeone => 'Играть с кем-то';

  @override
  String get loginPage => 'Страница входа';

  @override
  String get or => 'или';

  @override
  String get existingUser => 'Существующий пользователь ?';

  @override
  String get phone => 'Если у вас есть вопросы, свяжитесь с нами';

  @override
  String get whatsapp => 'Или свяжитесь с нами через WhatsApp';

  @override
  String get playOverTheNetwork => 'играть по сети';
}
