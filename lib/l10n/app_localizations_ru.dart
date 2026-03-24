// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Трекер прививок';

  @override
  String get childrenTitle => 'Дети';

  @override
  String get statistics => 'Статистика';

  @override
  String get totalChildren => 'Всего детей';

  @override
  String get totalVaccinations => 'Всего вакцинаций';

  @override
  String get protectionLevel => 'Уровень защиты';

  @override
  String get childAnalytics => 'Аналитика по детям';

  @override
  String get vaccineFilters => 'Фильтр вакцин';

  @override
  String get children => 'Дети';

  @override
  String get all => 'Все';

  @override
  String get today => 'Сегодня';

  @override
  String get info => 'Инфо';

  @override
  String get childCardTitle => 'Карточка ребёнка';

  @override
  String get emptyChildrenTitle => 'Пока нет детей';

  @override
  String get emptyChildrenSubtitle => 'Добавьте первого ребёнка, чтобы начать отслеживать прививки';

  @override
  String get addFirstChildHint => 'Добавьте первого ребёнка, чтобы начать отслеживать прививки';

  @override
  String get noChildren => 'Дети не добавлены';

  @override
  String get addChild => 'Добавить ребёнка';

  @override
  String get addChildTitle => 'Добавить ребёнка';

  @override
  String get childName => 'Имя ребёнка';

  @override
  String get age => 'Возраст';

  @override
  String get birthDate => 'Дата рождения';

  @override
  String get selectDate => 'Выберите дату';

  @override
  String get save => 'Сохранить';

  @override
  String get nameRequired => 'Введите имя';

  @override
  String get vaccinationProgress => 'Прогресс вакцинации';

  @override
  String get ofText => 'из';

  @override
  String get completed => 'выполнено';

  @override
  String get done => 'Сделано';

  @override
  String get made => 'Прививка сделана';

  @override
  String get tooEarly => 'Рано';

  @override
  String get overdue => 'Просрочено';

  @override
  String get dueNow => 'Пора делать';

  @override
  String get dueToday => 'Сегодня';

  @override
  String get soon => 'Скоро';

  @override
  String get later => 'Позже';

  @override
  String get upcoming => 'Ожидается';

  @override
  String get scheduled => 'Запланировано';

  @override
  String inDays(Object days) {
    return 'Через $days дней';
  }

  @override
  String overdueByDays(Object days) {
    return 'Просрочено на $days дней';
  }

  @override
  String daysCount(Object count) {
    return '$count дней';
  }

  @override
  String get months => 'мес';

  @override
  String canBeDoneFrom(Object months) {
    return 'Можно сделать с $months мес';
  }

  @override
  String get history => 'История';

  @override
  String get vaccinationHistory => 'История вакцинации';

  @override
  String get noHistory => 'История вакцинации пуста';

  @override
  String get schedule => 'График';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notificationSettings => 'Настройки уведомлений';

  @override
  String get enableNotifications => 'Включить уведомления';

  @override
  String get remindBefore => 'Напоминать заранее';

  @override
  String get enableOverdueReminders => 'Напоминать о просрочке';

  @override
  String get settingsAppliedImmediately => 'Настройки применяются сразу.';

  @override
  String get showRecommended => 'Показывать рекомендуемые';

  @override
  String get showOptional => 'Показывать дополнительные';

  @override
  String get searchVaccine => 'Поиск вакцины';

  @override
  String get notes => 'Заметки';

  @override
  String get enterNotes => 'Введите заметку';

  @override
  String get notesSaved => 'Заметка сохранена';

  @override
  String get healthCard => 'Карта здоровья';

  @override
  String get editHealthCard => 'Редактировать карту здоровья';

  @override
  String get allergies => 'Аллергии';

  @override
  String get enterAllergies => 'Введите аллергии';

  @override
  String get chronicDiseases => 'Хронические заболевания';

  @override
  String get enterChronicDiseases => 'Введите хронические заболевания';

  @override
  String get medicalExemption => 'Медотвод';

  @override
  String get healthCardSaved => 'Карта здоровья сохранена';

  @override
  String get emptyNotificationsTitle => 'На сегодня прививок нет';

  @override
  String get emptyNotificationsSubtitle => 'На сегодня все запланированные прививки выполнены';

  @override
  String get noVaccinesToday => 'Сегодня прививок нет';

  @override
  String get everythingUpToDate => 'Все прививки на сегодня актуальны';

  @override
  String get errorLoading => 'Ошибка загрузки';

  @override
  String get noUpcomingVaccines => 'Ближайших прививок нет';

  @override
  String get viewSchedule => 'Открыть график';

  @override
  String get settings => 'Настройки';

  @override
  String get security => 'Безопасность';

  @override
  String get enablePin => 'Включить PIN';

  @override
  String get changePin => 'Изменить PIN';

  @override
  String get disablePin => 'Отключить PIN';

  @override
  String get useBiometrics => 'Использовать биометрию';

  @override
  String get enterPin => 'Введите PIN';

  @override
  String get confirmPin => 'Подтвердите PIN';

  @override
  String get wrongPin => 'Неверный PIN';

  @override
  String get pinSaved => 'PIN успешно сохранён';

  @override
  String get pinDisabled => 'PIN отключён';

  @override
  String get logout => 'Выйти';

  @override
  String get loginTitle => 'Вход';

  @override
  String get email => 'Электронная почта';

  @override
  String get name => 'Имя';

  @override
  String get password => 'Пароль';

  @override
  String get login => 'Войти';

  @override
  String get noAccount => 'Нет аккаунта?';

  @override
  String get register => 'Регистрация';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get registerTitle => 'Регистрация';

  @override
  String get invalidCredentials => 'Неверный email или пароль';

  @override
  String get emailAlreadyRegistered => 'Этот email уже зарегистрирован';

  @override
  String get pinProtection => 'Защита приложения';

  @override
  String get incorrectPin => 'Неверный PIN';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get lightMode => 'Светлая тема';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get changePassword => 'Изменить пароль';

  @override
  String get oldPassword => 'Текущий пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get oldPasswordRequired => 'Введите текущий пароль';

  @override
  String get newPasswordTooShort => 'Минимум 6 символов';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get passwordChanged => 'Пароль успешно изменён';

  @override
  String get oldPasswordIncorrect => 'Текущий пароль неверный';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountMessage => 'Это действие необратимо. Все данные будут удалены.';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get ok => 'ОК';

  @override
  String get delete => 'Удалить';

  @override
  String get warning => 'Предупреждение';

  @override
  String get invalidData => 'Некорректные данные';

  @override
  String get dateCannotBeInFuture => 'Дата не может быть в будущем';

  @override
  String get vaccinationDateTooEarly => 'Дата вакцинации слишком ранняя';

  @override
  String get intervalError => 'Минимальный интервал между дозами не соблюден';

  @override
  String get medicalExemptionActive => 'Медотвод активен';

  @override
  String get setMedicalExemption => 'Установить медотвод';

  @override
  String get confirmVaccinationTitle => 'Подтвердите вакцинацию';

  @override
  String confirmVaccinationMessage(Object vaccine) {
    return 'Отметить \"$vaccine\" как выполненную?';
  }

  @override
  String get vaccineMarkedDone => 'Вакцина отмечена как выполненная';

  @override
  String get undo => 'Отменить';

  @override
  String get availableLater => 'Станет доступно при достижении нужного возраста';

  @override
  String get deleteAccountConfirm => 'Вы уверены, что хотите удалить аккаунт?';

  @override
  String get profile => 'Профиль';

  @override
  String get back => 'Назад';

  @override
  String get account => 'Аккаунт';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get backupData => 'Резервная копия';

  @override
  String get backupFailed => 'Не удалось создать резервную копию';

  @override
  String get failedToLoadData => 'Не удалось загрузить данные';

  @override
  String appVersion(Object version) {
    return 'Версия $version';
  }

  @override
  String ageMonthsFormat(Object months) {
    return '$months мес.';
  }

  @override
  String ageYearsFormat(Object years) {
    return '$years г.';
  }

  @override
  String ageYearsMonthsFormat(Object years, Object months) {
    return '$years г. $months мес.';
  }

  @override
  String get vaccinesInfoTitle => 'Информация о вакцинах';

  @override
  String get nationalVaccines => 'Государственные вакцины';

  @override
  String get recommendedVaccines => 'Рекомендуемые вакцины';

  @override
  String get customVaccines => 'Дополнительные прививки';

  @override
  String get optionalVaccines => 'Дополнительные вакцины';

  @override
  String get emptyVaccinesTitle => 'Нет данных о вакцинах';

  @override
  String get emptyVaccinesSubtitle => 'Список вакцин пуст. Добавьте данные и повторите';

  @override
  String get vaccine => 'Вакцина';

  @override
  String get recommendedAge => 'Рекомендуемый возраст';

  @override
  String get recommendedDate => 'Рекомендуемая дата';

  @override
  String get pdfTitle => 'Отчёт о вакцинации';

  @override
  String get pdfChildName => 'Имя ребёнка';

  @override
  String get pdfBirthDate => 'Дата рождения';

  @override
  String get pdfGenerated => 'Сформировано';

  @override
  String get pdfVaccine => 'Вакцина';

  @override
  String get pdfRecommended => 'Рекомендуемая дата';

  @override
  String get pdfStatus => 'Статус';

  @override
  String get pdfDoneAt => 'Дата выполнения';

  @override
  String get pdfCompleted => 'Выполнено';

  @override
  String get pdfOverdue => 'Просрочено';

  @override
  String get pdfUpcoming => 'Ожидается';

  @override
  String get pdfPassportTitle => 'Паспорт вакцинации ребенка';

  @override
  String get pdfHealthSection => 'Сведения о здоровье';

  @override
  String get pdfDoctorSignature => 'Подпись врача';

  @override
  String get pdfQrCode => 'QR-проверка';

  @override
  String get monthsShort => 'мес';

  @override
  String get nationalSchedule => 'Национальный календарь вакцинации';

  @override
  String get noData => 'Нет данных';

  @override
  String get vaccinesLoadingError => 'Ошибка загрузки списка вакцин';

  @override
  String get vaccinesProtectsAgainst => 'От чего';

  @override
  String get protectsAgainst => 'Защищает от';

  @override
  String get description => 'Описание';

  @override
  String get reactions => 'Возможные реакции';

  @override
  String get contraindications => 'Противопоказания';

  @override
  String get vaccineBcg => 'БЦЖ';

  @override
  String get bcg => 'БЦЖ';

  @override
  String get vaccineHepatitisB1 => 'Гепатит B (1)';

  @override
  String get hepatitis_b_1 => 'Гепатит B (1)';

  @override
  String get vaccineHepatitisB2 => 'Гепатит B (2)';

  @override
  String get hepatitis_b_2 => 'Гепатит B (2)';

  @override
  String get vaccineDtp1 => 'АКДС (1)';

  @override
  String get akds_1 => 'АКДС (1)';

  @override
  String get vaccineDtp2 => 'АКДС (2)';

  @override
  String get akds_2 => 'АКДС (2)';

  @override
  String get vaccineDtp3 => 'АКДС (3)';

  @override
  String get akds_3 => 'АКДС (3)';

  @override
  String get vaccineMmr => 'КПК';

  @override
  String get vaccineHepB1 => 'Гепатит B (1)';

  @override
  String get vaccineHepB2 => 'Гепатит B (2)';

  @override
  String get vaccineAkds1 => 'АКДС (1)';

  @override
  String get vaccineAkds2 => 'АКДС (2)';

  @override
  String get vaccineAkds3 => 'АКДС (3)';

  @override
  String get vaccineInfluenza => 'Грипп';

  @override
  String get vaccineVaricella => 'Ветряная оспа';

  @override
  String get vaccineHpv => 'ВПЧ';

  @override
  String get vaccinePneumococcal => 'Пневмококковая';

  @override
  String get vaccineMeningococcal => 'Менингококковая';

  @override
  String get vaccineRotavirus => 'Ротавирус';

  @override
  String get vaccineHib => 'Hib';

  @override
  String get kpk => 'КПК';

  @override
  String get vaccineDiseasesBcg => 'Туберкулез';

  @override
  String get vaccineDiseasesHepatitisB => 'Гепатит B';

  @override
  String get vaccineDiseasesDtp => 'Дифтерия, коклюш, столбняк';

  @override
  String get vaccineDiseasesMmr => 'Корь, паротит, краснуха';

  @override
  String get vaccineDescriptionBcg => 'БЦЖ защищает от тяжелых форм туберкулеза у детей.';

  @override
  String get vaccineDescriptionHepatitisB1 => 'Первая доза вакцины против вирусного гепатита B.';

  @override
  String get vaccineDescriptionHepatitisB2 => 'Вторая доза вакцины против вирусного гепатита B.';

  @override
  String get vaccineDescriptionDtp1 => 'Первая доза комбинированной вакцины АКДС.';

  @override
  String get vaccineDescriptionDtp2 => 'Вторая доза вакцины АКДС.';

  @override
  String get vaccineDescriptionDtp3 => 'Третья доза вакцины АКДС.';

  @override
  String get vaccineDescriptionMmr => 'КПК — комбинированная вакцина против кори, паротита и краснухи.';

  @override
  String get bcgDisease => 'Туберкулез';

  @override
  String get hepBDisease => 'Гепатит B';

  @override
  String get hepatitisBDisease => 'Гепатит B';

  @override
  String get akdsDisease => 'Дифтерия, коклюш, столбняк';

  @override
  String get mmrDisease => 'Корь, паротит, краснуха';

  @override
  String get kpkDisease => 'Корь, краснуха, паротит';

  @override
  String get influenzaDisease => 'Грипп';

  @override
  String get varicellaDisease => 'Ветряная оспа';

  @override
  String get hpvDisease => 'Инфекция ВПЧ';

  @override
  String get pneumococcalDisease => 'Пневмококковые инфекции';

  @override
  String get meningococcalDisease => 'Менингококковая инфекция';

  @override
  String get rotavirusDisease => 'Ротавирусная инфекция';

  @override
  String get hibDisease => 'Hib-инфекции';

  @override
  String get bcgDescription => 'Защищает от тяжелых форм туберкулеза у детей.';

  @override
  String get hepBDescription => 'Защищает от вирусного гепатита B — инфекции печени.';

  @override
  String get hepatitisB1Description => 'Первая доза вакцины против вирусного гепатита B.';

  @override
  String get hepatitisB2Description => 'Вторая доза вакцины против вирусного гепатита B.';

  @override
  String get akdsDescription => 'Комбинированная вакцина против дифтерии, коклюша и столбняка.';

  @override
  String get akds1Description => 'Первая доза комбинированной вакцины АКДС.';

  @override
  String get akds2Description => 'Вторая доза вакцины АКДС.';

  @override
  String get akds3Description => 'Третья доза вакцины АКДС.';

  @override
  String get mmrDescription => 'Комбинированная вакцина против кори, паротита и краснухи.';

  @override
  String get kpkDescription => 'Комбинированная вакцина против кори, краснухи и паротита.';

  @override
  String get influenzaDescription => 'Снижает риск тяжелого течения гриппа и осложнений.';

  @override
  String get varicellaDescription => 'Защищает от ветряной оспы и ее осложнений.';

  @override
  String get hpvDescription => 'Защищает от вируса папилломы человека и связанных осложнений.';

  @override
  String get pneumococcalDescription => 'Снижает риск пневмонии, отита и менингита.';

  @override
  String get meningococcalDescription => 'Защищает от тяжелых форм менингококковой инфекции.';

  @override
  String get rotavirusDescription => 'Снижает риск тяжелого обезвоживания при ротавирусе.';

  @override
  String get hibDescription => 'Защищает от инвазивных Hib-инфекций, включая менингит.';

  @override
  String get bcgReactions => 'Покраснение и уплотнение в месте инъекции.';

  @override
  String get hepBReactions => 'Небольшая боль в месте укола, возможна температура.';

  @override
  String get hepatitisBReactions => 'Небольшая болезненность в месте укола, слабость.';

  @override
  String get akdsReactions => 'Кратковременная температура, раздражительность.';

  @override
  String get mmrReactions => 'Лёгкая температура или слабая сыпь.';

  @override
  String get kpkReactions => 'Легкая температура, слабость.';

  @override
  String get influenzaReactions => 'Боль в месте укола, кратковременное недомогание.';

  @override
  String get varicellaReactions => 'Покраснение в месте укола, иногда легкая температура.';

  @override
  String get hpvReactions => 'Болезненность в месте укола, кратковременная слабость.';

  @override
  String get pneumococcalReactions => 'Покраснение в месте инъекции, кратковременная температура.';

  @override
  String get meningococcalReactions => 'Болезненность, покраснение, иногда легкая температура.';

  @override
  String get rotavirusReactions => 'Кратковременное беспокойство, редкие диспепсические явления.';

  @override
  String get hibReactions => 'Покраснение, умеренная болезненность, кратковременная температура.';

  @override
  String get bcgContra => 'Высокая температура, иммунодефицит, острые инфекции.';

  @override
  String get hepBContra => 'Аллергическая реакция на предыдущую дозу вакцины.';

  @override
  String get akdsContra => 'Сильная реакция на предыдущую дозу, высокая температура.';

  @override
  String get mmrContra => 'Беременность, иммунодефицит, тяжелые аллергические реакции.';

  @override
  String get influenzaContra => 'Аллергия на компоненты вакцины, высокая температура.';

  @override
  String get varicellaContra => 'Беременность, иммунодефицит.';

  @override
  String get hpvContra => 'Беременность, аллергия на компоненты вакцины.';

  @override
  String get pneumococcalContra => 'Аллергическая реакция на предыдущую дозу.';

  @override
  String get meningococcalContra => 'Тяжелая аллергия на компоненты вакцины.';

  @override
  String get rotavirusContra => 'Иммунодефицит, кишечная непроходимость.';

  @override
  String get hibContra => 'Аллергия на предыдущую дозу вакцины.';

  @override
  String get reminderChannelName => 'Напоминания о вакцинации';

  @override
  String get reminderChannelDescription => 'Ежедневные напоминания о прививках';

  @override
  String get reminderTitle => 'Вакцинация сегодня';

  @override
  String reminderBody(Object count) {
    return 'Сегодня нужно сделать $count прививок';
  }

  @override
  String get smartReminderSoonTitle => 'Скоро вакцинация';

  @override
  String get smartReminderDueTitle => 'Вакцинация сегодня';

  @override
  String get smartReminderOverdueTitle => 'Вакцинация просрочена';

  @override
  String get smartReminderDefaultTitle => 'Напоминание о вакцинации';

  @override
  String smartReminderSoonBody(Object childName, Object vaccineName, Object days) {
    return '$childName: $vaccineName через $days дня';
  }

  @override
  String smartReminderDueBody(Object childName, Object vaccineName) {
    return '$childName: $vaccineName пора сделать сегодня';
  }

  @override
  String smartReminderOverdueBody(Object childName, Object vaccineName, Object days) {
    return '$childName: $vaccineName просрочено на $days дней';
  }

  @override
  String smartReminderDefaultBody(Object childName, Object vaccineName) {
    return '$childName: $vaccineName';
  }
}
