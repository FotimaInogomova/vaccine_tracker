// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Emlash Kuzatuvchisi';

  @override
  String get childrenTitle => 'Bolalar';

  @override
  String get statistics => 'Statistika';

  @override
  String get totalChildren => 'Bolalar soni';

  @override
  String get totalVaccinations => 'Jami emlashlar';

  @override
  String get protectionLevel => 'Himoya darajasi';

  @override
  String get childAnalytics => 'Bolalar analitikasi';

  @override
  String get vaccineFilters => 'Vaksina filtrlari';

  @override
  String get children => 'Bolalar';

  @override
  String get all => 'Barchasi';

  @override
  String get today => 'Bugun';

  @override
  String get info => 'Ma’lumot';

  @override
  String get childCardTitle => 'Bola kartasi';

  @override
  String get emptyChildrenTitle => 'Hozircha bolalar yo‘q';

  @override
  String get emptyChildrenSubtitle => 'Emlashlarni kuzatishni boshlash uchun birinchi bolani qo‘shing';

  @override
  String get addFirstChildHint => 'Emlashlarni kuzatishni boshlash uchun birinchi bolani qo‘shing';

  @override
  String get noChildren => 'Bolalar qo\'shilmagan';

  @override
  String get addChild => 'Bola qo\'shish';

  @override
  String get addChildTitle => 'Bola qo\'shish';

  @override
  String get childName => 'Bola ismi';

  @override
  String get age => 'Yoshi';

  @override
  String get birthDate => 'Tug\'ilgan sana';

  @override
  String get selectDate => 'Sanani tanlang';

  @override
  String get save => 'Saqlash';

  @override
  String get nameRequired => 'Ism kiritilishi shart';

  @override
  String get vaccinationProgress => 'Emlash jarayoni';

  @override
  String get ofText => 'dan';

  @override
  String get completed => 'bajarilgan';

  @override
  String get done => 'Bajarildi';

  @override
  String get made => 'Emlash bajarilgan';

  @override
  String get tooEarly => 'Hali erta';

  @override
  String get overdue => 'Kechikkan';

  @override
  String get dueNow => 'Vaqti keldi';

  @override
  String get dueToday => 'Bugun';

  @override
  String get soon => 'Yaqinda';

  @override
  String get later => 'Keyinroq';

  @override
  String get upcoming => 'Kutilmoqda';

  @override
  String get scheduled => 'Rejalashtirilgan';

  @override
  String inDays(Object days) {
    return '$days kundan keyin';
  }

  @override
  String overdueByDays(Object days) {
    return '$days kunga kechikkan';
  }

  @override
  String daysCount(Object count) {
    return '$count kun';
  }

  @override
  String get months => 'oy';

  @override
  String canBeDoneFrom(Object months) {
    return '$months oydan boshlab mumkin';
  }

  @override
  String get history => 'Tarix';

  @override
  String get vaccinationHistory => 'Emlash tarixi';

  @override
  String get noHistory => 'Emlash tarixi bo\'sh';

  @override
  String get schedule => 'Jadval';

  @override
  String get notifications => 'Bildirishnomalar';

  @override
  String get notificationSettings => 'Bildirishnoma sozlamalari';

  @override
  String get enableNotifications => 'Bildirishnomalarni yoqish';

  @override
  String get remindBefore => 'Oldindan eslatish';

  @override
  String get enableOverdueReminders => 'Kechikish haqida eslatish';

  @override
  String get settingsAppliedImmediately => 'Sozlamalar darhol qo‘llaniladi.';

  @override
  String get showRecommended => 'Tavsiya etilganlarni ko‘rsatish';

  @override
  String get showOptional => 'Qo‘shimchalarni ko‘rsatish';

  @override
  String get searchVaccine => 'Vaksinani qidirish';

  @override
  String get notes => 'Izohlar';

  @override
  String get enterNotes => 'Izoh kiriting';

  @override
  String get notesSaved => 'Izoh saqlandi';

  @override
  String get healthCard => 'Sog\'liq kartasi';

  @override
  String get editHealthCard => 'Sog\'liq kartasini tahrirlash';

  @override
  String get allergies => 'Allergiyalar';

  @override
  String get enterAllergies => 'Allergiyalarni kiriting';

  @override
  String get chronicDiseases => 'Surunkali kasalliklar';

  @override
  String get enterChronicDiseases => 'Surunkali kasalliklarni kiriting';

  @override
  String get medicalExemption => 'Tibbiy cheklov';

  @override
  String get healthCardSaved => 'Sog\'liq kartasi saqlandi';

  @override
  String get emptyNotificationsTitle => 'Bugun emlashlar yo‘q';

  @override
  String get emptyNotificationsSubtitle => 'Bugungi rejalashtirilgan emlashlar bajarilgan';

  @override
  String get noVaccinesToday => 'Bugun emlash yo‘q';

  @override
  String get everythingUpToDate => 'Bugungi emlashlar dolzarb holatda';

  @override
  String get errorLoading => 'Yuklashda xatolik';

  @override
  String get noUpcomingVaccines => 'Yaqin emlashlar yo‘q';

  @override
  String get viewSchedule => 'Jadvalni ochish';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get security => 'Xavfsizlik';

  @override
  String get enablePin => 'PIN yoqish';

  @override
  String get changePin => 'PIN o\'zgartirish';

  @override
  String get disablePin => 'PIN o\'chirish';

  @override
  String get useBiometrics => 'Biometriyadan foydalanish';

  @override
  String get enterPin => 'PIN kiriting';

  @override
  String get confirmPin => 'PIN tasdiqlang';

  @override
  String get wrongPin => 'Noto\'g\'ri PIN';

  @override
  String get pinSaved => 'PIN saqlandi';

  @override
  String get pinDisabled => 'PIN o\'chirildi';

  @override
  String get logout => 'Chiqish';

  @override
  String get loginTitle => 'Kirish';

  @override
  String get email => 'Elektron pochta';

  @override
  String get name => 'Ism';

  @override
  String get password => 'Parol';

  @override
  String get login => 'Kirish';

  @override
  String get noAccount => 'Akkauntingiz yo\'qmi?';

  @override
  String get register => 'Ro\'yxatdan o\'tish';

  @override
  String get createAccount => 'Akkaunt yaratish';

  @override
  String get registerTitle => 'Ro\'yxatdan o\'tish';

  @override
  String get invalidCredentials => 'Email yoki parol noto\'g\'ri';

  @override
  String get emailAlreadyRegistered => 'Bu email allaqachon ro\'yxatdan o\'tgan';

  @override
  String get pinProtection => 'Ilova himoyasi';

  @override
  String get incorrectPin => 'PIN noto\'g\'ri';

  @override
  String get language => 'Til';

  @override
  String get theme => 'Mavzu';

  @override
  String get darkMode => 'Qorong‘i tema';

  @override
  String get lightMode => 'Yorug‘ tema';

  @override
  String get profileTitle => 'Profil';

  @override
  String get changePassword => 'Parolni o‘zgartirish';

  @override
  String get oldPassword => 'Joriy parol';

  @override
  String get newPassword => 'Yangi parol';

  @override
  String get confirmPassword => 'Parolni tasdiqlang';

  @override
  String get oldPasswordRequired => 'Joriy parolni kiriting';

  @override
  String get newPasswordTooShort => 'Kamida 6 ta belgi';

  @override
  String get passwordsDoNotMatch => 'Parollar mos kelmadi';

  @override
  String get passwordChanged => 'Parol muvaffaqiyatli o\'zgartirildi';

  @override
  String get oldPasswordIncorrect => 'Joriy parol noto\'g\'ri';

  @override
  String get deleteAccount => 'Hisobni o‘chirish';

  @override
  String get deleteAccountTitle => 'Hisobni o‘chirish?';

  @override
  String get deleteAccountMessage => 'Bu amalni bekor qilib bo‘lmaydi. Barcha ma’lumotlar o‘chadi.';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get confirm => 'Tasdiqlash';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'O‘chirish';

  @override
  String get warning => 'Ogohlantirish';

  @override
  String get invalidData => 'Noto\'g\'ri ma\'lumotlar';

  @override
  String get dateCannotBeInFuture => 'Sana kelajakda bo\'lishi mumkin emas';

  @override
  String get vaccinationDateTooEarly => 'Emlash sanasi juda erta';

  @override
  String get intervalError => 'Dozalar orasidagi minimal intervalga rioya qilinmadi';

  @override
  String get medicalExemptionActive => 'Tibbiy cheklov faol';

  @override
  String get setMedicalExemption => 'Tibbiy cheklovni o‘rnatish';

  @override
  String get confirmVaccinationTitle => 'Emlashni tasdiqlang';

  @override
  String confirmVaccinationMessage(Object vaccine) {
    return '\"$vaccine\" ni bajarilgan deb belgilansinmi?';
  }

  @override
  String get vaccineMarkedDone => 'Emlash bajarilgan deb belgilandi';

  @override
  String get undo => 'Bekor qilish';

  @override
  String get availableLater => 'Kerakli yoshga yetganda mavjud bo‘ladi';

  @override
  String get deleteAccountConfirm => 'Akkountni o\'chirishni tasdiqlaysizmi?';

  @override
  String get profile => 'Profil';

  @override
  String get back => 'Orqaga';

  @override
  String get account => 'Hisob';

  @override
  String get appearance => 'Ko‘rinish';

  @override
  String get backupData => 'Zaxira nusxasi';

  @override
  String get backupFailed => 'Zaxira nusxasini yaratib bo\'lmadi';

  @override
  String get failedToLoadData => 'Ma\'lumotlarni yuklab bo\'lmadi';

  @override
  String appVersion(Object version) {
    return 'Versiya $version';
  }

  @override
  String ageMonthsFormat(Object months) {
    return '$months oy';
  }

  @override
  String ageYearsFormat(Object years) {
    return '$years yosh';
  }

  @override
  String ageYearsMonthsFormat(Object years, Object months) {
    return '$years yosh $months oy';
  }

  @override
  String get vaccinesInfoTitle => 'Vaksinalar haqida ma’lumot';

  @override
  String get nationalVaccines => 'Davlat emlashlari';

  @override
  String get recommendedVaccines => 'Tavsiya etilgan emlashlar';

  @override
  String get customVaccines => 'Qo‘shimcha emlashlar';

  @override
  String get optionalVaccines => 'Qo‘shimcha vaksinalar';

  @override
  String get emptyVaccinesTitle => 'Vaksina ma’lumotlari yo‘q';

  @override
  String get emptyVaccinesSubtitle => 'Vaksinalar ro‘yxati bo‘sh. Ma’lumot qo‘shib qayta urinib ko‘ring';

  @override
  String get vaccine => 'Vaksina';

  @override
  String get recommendedAge => 'Tavsiya etilgan yosh';

  @override
  String get recommendedDate => 'Tavsiya etilgan sana';

  @override
  String get pdfTitle => 'Emlash hisoboti';

  @override
  String get pdfChildName => 'Bolaning ismi';

  @override
  String get pdfBirthDate => 'Tug‘ilgan sana';

  @override
  String get pdfGenerated => 'Yaratilgan sana';

  @override
  String get pdfVaccine => 'Emlash';

  @override
  String get pdfRecommended => 'Tavsiya etilgan sana';

  @override
  String get pdfStatus => 'Holati';

  @override
  String get pdfDoneAt => 'Bajarilgan sana';

  @override
  String get pdfCompleted => 'Bajarilgan';

  @override
  String get pdfOverdue => 'Kechikkan';

  @override
  String get pdfUpcoming => 'Kutilmoqda';

  @override
  String get pdfPassportTitle => 'Bolaning emlash pasporti';

  @override
  String get pdfHealthSection => 'Sog\'liq ma\'lumotlari';

  @override
  String get pdfDoctorSignature => 'Shifokor imzosi';

  @override
  String get pdfQrCode => 'QR tekshiruv';

  @override
  String get monthsShort => 'oy';

  @override
  String get nationalSchedule => 'Milliy emlash taqvimi';

  @override
  String get noData => 'Ma’lumot yo‘q';

  @override
  String get vaccinesLoadingError => 'Emlashlar ro\'yxatini yuklashda xatolik';

  @override
  String get vaccinesProtectsAgainst => 'Qaysi kasallikdan';

  @override
  String get protectsAgainst => 'Himoya qiladi';

  @override
  String get description => 'Tavsif';

  @override
  String get reactions => 'Mumkin bo\'lgan reaksiyalar';

  @override
  String get contraindications => 'Qarshi ko\'rsatmalar';

  @override
  String get vaccineBcg => 'BCG';

  @override
  String get bcg => 'BCG';

  @override
  String get vaccineHepatitisB1 => 'Gepatit B (1)';

  @override
  String get hepatitis_b_1 => 'Gepatit B (1)';

  @override
  String get vaccineHepatitisB2 => 'Gepatit B (2)';

  @override
  String get hepatitis_b_2 => 'Gepatit B (2)';

  @override
  String get vaccineDtp1 => 'AKDS (1)';

  @override
  String get akds_1 => 'AKDS (1)';

  @override
  String get vaccineDtp2 => 'AKDS (2)';

  @override
  String get akds_2 => 'AKDS (2)';

  @override
  String get vaccineDtp3 => 'AKDS (3)';

  @override
  String get akds_3 => 'AKDS (3)';

  @override
  String get vaccineMmr => 'KPK';

  @override
  String get vaccineHepB1 => 'Gepatit B (1)';

  @override
  String get vaccineHepB2 => 'Gepatit B (2)';

  @override
  String get vaccineAkds1 => 'AKDS (1)';

  @override
  String get vaccineAkds2 => 'AKDS (2)';

  @override
  String get vaccineAkds3 => 'AKDS (3)';

  @override
  String get vaccineInfluenza => 'Gripp';

  @override
  String get vaccineVaricella => 'Suvchechak';

  @override
  String get vaccineHpv => 'HPV';

  @override
  String get vaccinePneumococcal => 'Pnevmokokk';

  @override
  String get vaccineMeningococcal => 'Meningokokk';

  @override
  String get vaccineRotavirus => 'Rotavirus';

  @override
  String get vaccineHib => 'Hib';

  @override
  String get kpk => 'KPK';

  @override
  String get vaccineDiseasesBcg => 'Sil';

  @override
  String get vaccineDiseasesHepatitisB => 'Gepatit B';

  @override
  String get vaccineDiseasesDtp => 'Difteriya, ko\'k yo\'tal, qoqshol';

  @override
  String get vaccineDiseasesMmr => 'Qizamiq, epidemik parotit, qizilcha';

  @override
  String get vaccineDescriptionBcg => 'BCG bolalarni silning og\'ir shakllaridan himoya qiladi.';

  @override
  String get vaccineDescriptionHepatitisB1 => 'Gepatit B ga qarshi vaksinatsiyaning birinchi dozasi.';

  @override
  String get vaccineDescriptionHepatitisB2 => 'Gepatit B ga qarshi vaksinatsiyaning ikkinchi dozasi.';

  @override
  String get vaccineDescriptionDtp1 => 'AKDS kombinatsiyalangan vaksinasining birinchi dozasi.';

  @override
  String get vaccineDescriptionDtp2 => 'AKDS vaksinasining ikkinchi dozasi.';

  @override
  String get vaccineDescriptionDtp3 => 'AKDS vaksinasining uchinchi dozasi.';

  @override
  String get vaccineDescriptionMmr => 'KPK qizamiq, parotit va qizilchaga qarshi kombinatsiyalangan vaksina.';

  @override
  String get bcgDisease => 'Sil';

  @override
  String get hepBDisease => 'Gepatit B';

  @override
  String get hepatitisBDisease => 'Gepatit B';

  @override
  String get akdsDisease => 'Difteriya, ko\'k yo\'tal, qoqshol';

  @override
  String get mmrDisease => 'Qizamiq, epidemik parotit, qizilcha';

  @override
  String get kpkDisease => 'Qizamiq, qizilcha, epidemik parotit';

  @override
  String get influenzaDisease => 'Gripp';

  @override
  String get varicellaDisease => 'Suvchechak';

  @override
  String get hpvDisease => 'HPV infeksiyasi';

  @override
  String get pneumococcalDisease => 'Pnevmokokk infeksiyalari';

  @override
  String get meningococcalDisease => 'Meningokokk infeksiyasi';

  @override
  String get rotavirusDisease => 'Rotavirus infeksiyasi';

  @override
  String get hibDisease => 'Hib infeksiyalari';

  @override
  String get bcgDescription => 'Bolalarni silning og\'ir shakllaridan himoya qiladi.';

  @override
  String get hepBDescription => 'Jigar infeksiyasi bo\'lgan virusli gepatit B dan himoya qiladi.';

  @override
  String get hepatitisB1Description => 'Gepatit B vaksinasining birinchi dozasi.';

  @override
  String get hepatitisB2Description => 'Gepatit B vaksinasining ikkinchi dozasi.';

  @override
  String get akdsDescription => 'Difteriya, ko\'k yo\'tal va qoqsholga qarshi kombinatsiyalangan vaksina.';

  @override
  String get akds1Description => 'AKDS kombinatsiyalangan vaksinasining birinchi dozasi.';

  @override
  String get akds2Description => 'AKDS vaksinasining ikkinchi dozasi.';

  @override
  String get akds3Description => 'AKDS vaksinasining uchinchi dozasi.';

  @override
  String get mmrDescription => 'Qizamiq, parotit va qizilchaga qarshi kombinatsiyalangan vaksina.';

  @override
  String get kpkDescription => 'Qizamiq, qizilcha va parotitga qarshi kombinatsiyalangan vaksina.';

  @override
  String get influenzaDescription => 'Grippning og\'ir kechishi va asoratlari xavfini kamaytiradi.';

  @override
  String get varicellaDescription => 'Suvchechak va uning asoratlaridan himoya qiladi.';

  @override
  String get hpvDescription => 'HPV va unga bog\'liq asoratlardan himoya qiladi.';

  @override
  String get pneumococcalDescription => 'Pnevmoniya, otit va meningit xavfini kamaytiradi.';

  @override
  String get meningococcalDescription => 'Meningokokk infeksiyasining og\'ir shakllaridan himoya qiladi.';

  @override
  String get rotavirusDescription => 'Rotavirusda og\'ir suvsizlanish xavfini kamaytiradi.';

  @override
  String get hibDescription => 'Invaziv Hib infeksiyalari, jumladan meningitdan himoya qiladi.';

  @override
  String get bcgReactions => 'Inyeksiya joyida qizarish va qotish.';

  @override
  String get hepBReactions => 'Ukol joyida yengil og\'riq, isitma bo\'lishi mumkin.';

  @override
  String get hepatitisBReactions => 'Ukol joyida yengil og\'riq, vaqtinchalik holsizlik.';

  @override
  String get akdsReactions => 'Qisqa muddatli isitma, bezovtalik.';

  @override
  String get mmrReactions => 'Yengil isitma yoki yengil toshma.';

  @override
  String get kpkReactions => 'Yengil isitma, holsizlik.';

  @override
  String get influenzaReactions => 'Ukol joyida og\'riq, qisqa muddatli noxushlik.';

  @override
  String get varicellaReactions => 'Ukol joyida qizarish, ba\'zan yengil isitma.';

  @override
  String get hpvReactions => 'Ukol joyida og\'riq, vaqtinchalik holsizlik.';

  @override
  String get pneumococcalReactions => 'Inyeksiya joyida qizarish, qisqa muddatli isitma.';

  @override
  String get meningococcalReactions => 'Og\'riq, qizarish, ba\'zan yengil isitma.';

  @override
  String get rotavirusReactions => 'Qisqa muddatli bezovtalik, kamdan-kam hazm buzilishi.';

  @override
  String get hibReactions => 'Qizarish, o\'rtacha og\'riq, qisqa muddatli isitma.';

  @override
  String get bcgContra => 'Yuqori harorat, immunitet yetishmovchiligi.';

  @override
  String get hepBContra => 'Oldingi dozaga allergik reaktsiya.';

  @override
  String get akdsContra => 'Oldingi dozaga kuchli reaktsiya.';

  @override
  String get mmrContra => 'Homiladorlik, immunitet yetishmovchiligi.';

  @override
  String get influenzaContra => 'Vaksina komponentlariga allergiya.';

  @override
  String get varicellaContra => 'Homiladorlik, immunitet yetishmovchiligi.';

  @override
  String get hpvContra => 'Homiladorlik, vaksina komponentlariga allergiya.';

  @override
  String get pneumococcalContra => 'Oldingi dozaga allergik reaktsiya.';

  @override
  String get meningococcalContra => 'Vaksina komponentlariga kuchli allergiya.';

  @override
  String get rotavirusContra => 'Immunitet yetishmovchiligi.';

  @override
  String get hibContra => 'Oldingi dozaga allergiya.';

  @override
  String get reminderChannelName => 'Emlash eslatmalari';

  @override
  String get reminderChannelDescription => 'Har kunlik emlash eslatmalari';

  @override
  String get reminderTitle => 'Bugungi emlashlar';

  @override
  String reminderBody(Object count) {
    return 'Bugun $count ta emlash qilish kerak';
  }

  @override
  String get smartReminderSoonTitle => 'Emlash yaqinlashmoqda';

  @override
  String get smartReminderDueTitle => 'Emlash kuni bugun';

  @override
  String get smartReminderOverdueTitle => 'Emlash kechikkan';

  @override
  String get smartReminderDefaultTitle => 'Emlash eslatmasi';

  @override
  String smartReminderSoonBody(Object childName, Object vaccineName, Object days) {
    return '$childName: $vaccineName $days kundan keyin';
  }

  @override
  String smartReminderDueBody(Object childName, Object vaccineName) {
    return '$childName: $vaccineName bugun qilish kerak';
  }

  @override
  String smartReminderOverdueBody(Object childName, Object vaccineName, Object days) {
    return '$childName: $vaccineName $days kunga kechikkan';
  }

  @override
  String smartReminderDefaultBody(Object childName, Object vaccineName) {
    return '$childName: $vaccineName';
  }
}
