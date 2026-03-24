// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vaccine Tracker';

  @override
  String get childrenTitle => 'Children';

  @override
  String get statistics => 'Statistics';

  @override
  String get totalChildren => 'Total children';

  @override
  String get totalVaccinations => 'Total vaccinations';

  @override
  String get protectionLevel => 'Protection level';

  @override
  String get childAnalytics => 'Children analytics';

  @override
  String get vaccineFilters => 'Vaccine filters';

  @override
  String get children => 'Children';

  @override
  String get all => 'All';

  @override
  String get today => 'Today';

  @override
  String get info => 'Info';

  @override
  String get childCardTitle => 'Child Card';

  @override
  String get emptyChildrenTitle => 'No children yet';

  @override
  String get emptyChildrenSubtitle => 'Add your first child to start tracking vaccinations';

  @override
  String get addFirstChildHint => 'Add your first child to start tracking vaccinations';

  @override
  String get noChildren => 'No children added';

  @override
  String get addChild => 'Add Child';

  @override
  String get addChildTitle => 'Add Child';

  @override
  String get childName => 'Child name';

  @override
  String get age => 'Age';

  @override
  String get birthDate => 'Birth date';

  @override
  String get selectDate => 'Select date';

  @override
  String get save => 'Save';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get vaccinationProgress => 'Vaccination progress';

  @override
  String get ofText => 'of';

  @override
  String get completed => 'completed';

  @override
  String get done => 'Done';

  @override
  String get made => 'Vaccination completed';

  @override
  String get tooEarly => 'Too early';

  @override
  String get overdue => 'Overdue';

  @override
  String get dueNow => 'Due now';

  @override
  String get dueToday => 'Today';

  @override
  String get soon => 'Soon';

  @override
  String get later => 'Later';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get scheduled => 'Scheduled';

  @override
  String inDays(Object days) {
    return 'In $days days';
  }

  @override
  String overdueByDays(Object days) {
    return 'Overdue by $days days';
  }

  @override
  String daysCount(Object count) {
    return '$count days';
  }

  @override
  String get months => 'months';

  @override
  String canBeDoneFrom(Object months) {
    return 'Can be done from $months months';
  }

  @override
  String get history => 'History';

  @override
  String get vaccinationHistory => 'Vaccination History';

  @override
  String get noHistory => 'Vaccination history is empty';

  @override
  String get schedule => 'Schedule';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSettings => 'Notification settings';

  @override
  String get enableNotifications => 'Enable notifications';

  @override
  String get remindBefore => 'Remind before';

  @override
  String get enableOverdueReminders => 'Enable overdue reminders';

  @override
  String get settingsAppliedImmediately => 'Settings are applied immediately.';

  @override
  String get showRecommended => 'Show recommended';

  @override
  String get showOptional => 'Show optional';

  @override
  String get searchVaccine => 'Search vaccine';

  @override
  String get notes => 'Notes';

  @override
  String get enterNotes => 'Enter notes';

  @override
  String get notesSaved => 'Notes saved';

  @override
  String get healthCard => 'Health card';

  @override
  String get editHealthCard => 'Edit health card';

  @override
  String get allergies => 'Allergies';

  @override
  String get enterAllergies => 'Enter allergies';

  @override
  String get chronicDiseases => 'Chronic diseases';

  @override
  String get enterChronicDiseases => 'Enter chronic diseases';

  @override
  String get medicalExemption => 'Medical exemption';

  @override
  String get healthCardSaved => 'Health card saved';

  @override
  String get emptyNotificationsTitle => 'No vaccinations today';

  @override
  String get emptyNotificationsSubtitle => 'You are all caught up for today';

  @override
  String get noVaccinesToday => 'No vaccinations today';

  @override
  String get everythingUpToDate => 'Everything is up to date for today';

  @override
  String get errorLoading => 'Error loading data';

  @override
  String get noUpcomingVaccines => 'No upcoming vaccinations';

  @override
  String get viewSchedule => 'View schedule';

  @override
  String get settings => 'Settings';

  @override
  String get security => 'Security';

  @override
  String get enablePin => 'Enable PIN';

  @override
  String get changePin => 'Change PIN';

  @override
  String get disablePin => 'Disable PIN';

  @override
  String get useBiometrics => 'Use biometrics';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get wrongPin => 'Wrong PIN';

  @override
  String get pinSaved => 'PIN saved successfully';

  @override
  String get pinDisabled => 'PIN disabled';

  @override
  String get logout => 'Logout';

  @override
  String get loginTitle => 'Login';

  @override
  String get email => 'Email';

  @override
  String get name => 'Name';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerTitle => 'Register';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get emailAlreadyRegistered => 'Email is already registered';

  @override
  String get pinProtection => 'App Protection';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get profileTitle => 'Profile';

  @override
  String get changePassword => 'Change password';

  @override
  String get oldPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get oldPasswordRequired => 'Enter your current password';

  @override
  String get newPasswordTooShort => 'Minimum 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get oldPasswordIncorrect => 'Current password is incorrect';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountMessage => 'This action is irreversible. All data will be deleted.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Delete';

  @override
  String get warning => 'Warning';

  @override
  String get invalidData => 'Invalid data';

  @override
  String get dateCannotBeInFuture => 'Date cannot be in the future';

  @override
  String get vaccinationDateTooEarly => 'Vaccination date is too early';

  @override
  String get intervalError => 'Minimum interval between doses is not met';

  @override
  String get medicalExemptionActive => 'Medical exemption is active';

  @override
  String get setMedicalExemption => 'Set medical exemption';

  @override
  String get confirmVaccinationTitle => 'Confirm vaccination';

  @override
  String confirmVaccinationMessage(Object vaccine) {
    return 'Mark \"$vaccine\" as completed?';
  }

  @override
  String get vaccineMarkedDone => 'Vaccination marked as completed';

  @override
  String get undo => 'Undo';

  @override
  String get availableLater => 'Available when child reaches required age';

  @override
  String get deleteAccountConfirm => 'Are you sure you want to delete your account?';

  @override
  String get profile => 'Profile';

  @override
  String get back => 'Back';

  @override
  String get account => 'Account';

  @override
  String get appearance => 'Appearance';

  @override
  String get backupData => 'Backup data';

  @override
  String get backupFailed => 'Backup failed';

  @override
  String get failedToLoadData => 'Failed to load data';

  @override
  String appVersion(Object version) {
    return 'Version $version';
  }

  @override
  String ageMonthsFormat(Object months) {
    return '$months months';
  }

  @override
  String ageYearsFormat(Object years) {
    return '$years years';
  }

  @override
  String ageYearsMonthsFormat(Object years, Object months) {
    return '$years y $months m';
  }

  @override
  String get vaccinesInfoTitle => 'Vaccines information';

  @override
  String get nationalVaccines => 'National vaccines';

  @override
  String get recommendedVaccines => 'Recommended vaccines';

  @override
  String get customVaccines => 'Additional vaccines';

  @override
  String get optionalVaccines => 'Optional vaccines';

  @override
  String get emptyVaccinesTitle => 'No vaccine data';

  @override
  String get emptyVaccinesSubtitle => 'Vaccine list is empty. Add data and try again';

  @override
  String get vaccine => 'Vaccine';

  @override
  String get recommendedAge => 'Recommended age';

  @override
  String get recommendedDate => 'Recommended date';

  @override
  String get pdfTitle => 'Vaccination Report';

  @override
  String get pdfChildName => 'Child name';

  @override
  String get pdfBirthDate => 'Birth date';

  @override
  String get pdfGenerated => 'Generated';

  @override
  String get pdfVaccine => 'Vaccine';

  @override
  String get pdfRecommended => 'Recommended date';

  @override
  String get pdfStatus => 'Status';

  @override
  String get pdfDoneAt => 'Done at';

  @override
  String get pdfCompleted => 'Completed';

  @override
  String get pdfOverdue => 'Overdue';

  @override
  String get pdfUpcoming => 'Upcoming';

  @override
  String get pdfPassportTitle => 'Child Vaccination Passport';

  @override
  String get pdfHealthSection => 'Health information';

  @override
  String get pdfDoctorSignature => 'Doctor signature';

  @override
  String get pdfQrCode => 'QR verification';

  @override
  String get monthsShort => 'months';

  @override
  String get nationalSchedule => 'National vaccination schedule';

  @override
  String get noData => 'No data';

  @override
  String get vaccinesLoadingError => 'Failed to load vaccine list';

  @override
  String get vaccinesProtectsAgainst => 'Protects against';

  @override
  String get protectsAgainst => 'Protects against';

  @override
  String get description => 'Description';

  @override
  String get reactions => 'Possible reactions';

  @override
  String get contraindications => 'Contraindications';

  @override
  String get vaccineBcg => 'BCG';

  @override
  String get bcg => 'BCG';

  @override
  String get vaccineHepatitisB1 => 'Hepatitis B (1)';

  @override
  String get hepatitis_b_1 => 'Hepatitis B (1)';

  @override
  String get vaccineHepatitisB2 => 'Hepatitis B (2)';

  @override
  String get hepatitis_b_2 => 'Hepatitis B (2)';

  @override
  String get vaccineDtp1 => 'DTP (1)';

  @override
  String get akds_1 => 'DTP (1)';

  @override
  String get vaccineDtp2 => 'DTP (2)';

  @override
  String get akds_2 => 'DTP (2)';

  @override
  String get vaccineDtp3 => 'DTP (3)';

  @override
  String get akds_3 => 'DTP (3)';

  @override
  String get vaccineMmr => 'MMR';

  @override
  String get vaccineHepB1 => 'Hepatitis B (1)';

  @override
  String get vaccineHepB2 => 'Hepatitis B (2)';

  @override
  String get vaccineAkds1 => 'DTP (1)';

  @override
  String get vaccineAkds2 => 'DTP (2)';

  @override
  String get vaccineAkds3 => 'DTP (3)';

  @override
  String get vaccineInfluenza => 'Influenza';

  @override
  String get vaccineVaricella => 'Varicella';

  @override
  String get vaccineHpv => 'HPV';

  @override
  String get vaccinePneumococcal => 'Pneumococcal';

  @override
  String get vaccineMeningococcal => 'Meningococcal';

  @override
  String get vaccineRotavirus => 'Rotavirus';

  @override
  String get vaccineHib => 'Hib';

  @override
  String get kpk => 'MMR';

  @override
  String get vaccineDiseasesBcg => 'Tuberculosis';

  @override
  String get vaccineDiseasesHepatitisB => 'Hepatitis B';

  @override
  String get vaccineDiseasesDtp => 'Diphtheria, pertussis, tetanus';

  @override
  String get vaccineDiseasesMmr => 'Measles, mumps, rubella';

  @override
  String get vaccineDescriptionBcg => 'BCG protects children from severe forms of tuberculosis.';

  @override
  String get vaccineDescriptionHepatitisB1 => 'The first dose of hepatitis B vaccine.';

  @override
  String get vaccineDescriptionHepatitisB2 => 'The second dose of hepatitis B vaccine.';

  @override
  String get vaccineDescriptionDtp1 => 'The first dose of combined DTP vaccine.';

  @override
  String get vaccineDescriptionDtp2 => 'The second dose of DTP vaccine.';

  @override
  String get vaccineDescriptionDtp3 => 'The third dose of DTP vaccine.';

  @override
  String get vaccineDescriptionMmr => 'MMR is a combined vaccine against measles, mumps, and rubella.';

  @override
  String get bcgDisease => 'Tuberculosis';

  @override
  String get hepBDisease => 'Hepatitis B';

  @override
  String get hepatitisBDisease => 'Hepatitis B';

  @override
  String get akdsDisease => 'Diphtheria, pertussis, tetanus';

  @override
  String get mmrDisease => 'Measles, mumps, rubella';

  @override
  String get kpkDisease => 'Measles, rubella, mumps';

  @override
  String get influenzaDisease => 'Influenza';

  @override
  String get varicellaDisease => 'Chickenpox';

  @override
  String get hpvDisease => 'HPV infection';

  @override
  String get pneumococcalDisease => 'Pneumococcal infections';

  @override
  String get meningococcalDisease => 'Meningococcal infection';

  @override
  String get rotavirusDisease => 'Rotavirus infection';

  @override
  String get hibDisease => 'Hib infections';

  @override
  String get bcgDescription => 'Protects children from severe forms of tuberculosis.';

  @override
  String get hepBDescription => 'Protects against viral hepatitis B, a liver infection.';

  @override
  String get hepatitisB1Description => 'First dose of the hepatitis B vaccine.';

  @override
  String get hepatitisB2Description => 'Second dose of the hepatitis B vaccine.';

  @override
  String get akdsDescription => 'Combined vaccine against diphtheria, pertussis, and tetanus.';

  @override
  String get akds1Description => 'First dose of combined DTP vaccine.';

  @override
  String get akds2Description => 'Second dose of DTP vaccine.';

  @override
  String get akds3Description => 'Third dose of DTP vaccine.';

  @override
  String get mmrDescription => 'Combined vaccine against measles, mumps, and rubella.';

  @override
  String get kpkDescription => 'Combined vaccine against measles, rubella, and mumps.';

  @override
  String get influenzaDescription => 'Reduces risk of severe influenza and complications.';

  @override
  String get varicellaDescription => 'Protects against chickenpox and related complications.';

  @override
  String get hpvDescription => 'Protects against HPV and related complications.';

  @override
  String get pneumococcalDescription => 'Reduces risk of pneumonia, otitis, and meningitis.';

  @override
  String get meningococcalDescription => 'Protects against severe meningococcal disease.';

  @override
  String get rotavirusDescription => 'Reduces risk of severe dehydration from rotavirus.';

  @override
  String get hibDescription => 'Protects against invasive Hib infections, including meningitis.';

  @override
  String get bcgReactions => 'Redness and swelling at injection site.';

  @override
  String get hepBReactions => 'Mild pain at injection site, possible low fever.';

  @override
  String get hepatitisBReactions => 'Mild pain at injection site, temporary weakness.';

  @override
  String get akdsReactions => 'Short-term fever, irritability.';

  @override
  String get mmrReactions => 'Mild fever or light rash.';

  @override
  String get kpkReactions => 'Mild fever, weakness.';

  @override
  String get influenzaReactions => 'Injection site pain, short-term malaise.';

  @override
  String get varicellaReactions => 'Injection site redness, sometimes mild fever.';

  @override
  String get hpvReactions => 'Injection site soreness, temporary weakness.';

  @override
  String get pneumococcalReactions => 'Injection site redness, short-term fever.';

  @override
  String get meningococcalReactions => 'Soreness, redness, sometimes mild fever.';

  @override
  String get rotavirusReactions => 'Temporary fussiness, rare mild digestive symptoms.';

  @override
  String get hibReactions => 'Redness, moderate soreness, short-term fever.';

  @override
  String get bcgContra => 'High fever, immunodeficiency, acute infections.';

  @override
  String get hepBContra => 'Allergic reaction to a previous dose.';

  @override
  String get akdsContra => 'Severe reaction to previous dose, high fever.';

  @override
  String get mmrContra => 'Pregnancy, immunodeficiency, severe allergy.';

  @override
  String get influenzaContra => 'Allergy to vaccine components, high fever.';

  @override
  String get varicellaContra => 'Pregnancy, immunodeficiency.';

  @override
  String get hpvContra => 'Pregnancy, allergy to vaccine components.';

  @override
  String get pneumococcalContra => 'Allergic reaction to previous dose.';

  @override
  String get meningococcalContra => 'Severe allergy to vaccine components.';

  @override
  String get rotavirusContra => 'Immunodeficiency, intestinal obstruction.';

  @override
  String get hibContra => 'Allergic reaction to previous dose.';

  @override
  String get reminderChannelName => 'Vaccination reminders';

  @override
  String get reminderChannelDescription => 'Daily vaccination reminders';

  @override
  String get reminderTitle => 'Vaccinations today';

  @override
  String reminderBody(Object count) {
    return 'You need to do $count vaccinations today';
  }

  @override
  String get smartReminderSoonTitle => 'Vaccination soon';

  @override
  String get smartReminderDueTitle => 'Vaccination due today';

  @override
  String get smartReminderOverdueTitle => 'Vaccination overdue';

  @override
  String get smartReminderDefaultTitle => 'Vaccination reminder';

  @override
  String smartReminderSoonBody(Object childName, Object vaccineName, Object days) {
    return '$childName: $vaccineName in $days days';
  }

  @override
  String smartReminderDueBody(Object childName, Object vaccineName) {
    return '$childName: $vaccineName is due today';
  }

  @override
  String smartReminderOverdueBody(Object childName, Object vaccineName, Object days) {
    return '$childName: $vaccineName overdue by $days days';
  }

  @override
  String smartReminderDefaultBody(Object childName, Object vaccineName) {
    return '$childName: $vaccineName';
  }
}
