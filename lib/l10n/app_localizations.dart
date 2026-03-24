import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Tracker'**
  String get appTitle;

  /// No description provided for @childrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get childrenTitle;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @totalChildren.
  ///
  /// In en, this message translates to:
  /// **'Total children'**
  String get totalChildren;

  /// No description provided for @totalVaccinations.
  ///
  /// In en, this message translates to:
  /// **'Total vaccinations'**
  String get totalVaccinations;

  String get protectionLevel;

  String get childAnalytics;

  String get vaccineFilters;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @childCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Child Card'**
  String get childCardTitle;

  /// No description provided for @emptyChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'No children yet'**
  String get emptyChildrenTitle;

  /// No description provided for @emptyChildrenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first child to start tracking vaccinations'**
  String get emptyChildrenSubtitle;

  /// No description provided for @addFirstChildHint.
  ///
  /// In en, this message translates to:
  /// **'Add your first child to start tracking vaccinations'**
  String get addFirstChildHint;

  /// No description provided for @noChildren.
  ///
  /// In en, this message translates to:
  /// **'No children added'**
  String get noChildren;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get addChild;

  /// No description provided for @addChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get addChildTitle;

  /// No description provided for @childName.
  ///
  /// In en, this message translates to:
  /// **'Child name'**
  String get childName;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get birthDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @vaccinationProgress.
  ///
  /// In en, this message translates to:
  /// **'Vaccination progress'**
  String get vaccinationProgress;

  /// No description provided for @ofText.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofText;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get completed;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @made.
  ///
  /// In en, this message translates to:
  /// **'Vaccination completed'**
  String get made;

  /// No description provided for @tooEarly.
  ///
  /// In en, this message translates to:
  /// **'Too early'**
  String get tooEarly;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @dueNow.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get dueNow;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dueToday;

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get soon;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String inDays(Object days);

  /// No description provided for @overdueByDays.
  ///
  /// In en, this message translates to:
  /// **'Overdue by {days} days'**
  String overdueByDays(Object days);

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(Object count);

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @canBeDoneFrom.
  ///
  /// In en, this message translates to:
  /// **'Can be done from {months} months'**
  String canBeDoneFrom(Object months);

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @vaccinationHistory.
  ///
  /// In en, this message translates to:
  /// **'Vaccination History'**
  String get vaccinationHistory;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'Vaccination history is empty'**
  String get noHistory;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettings;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enableNotifications;

  /// No description provided for @remindBefore.
  ///
  /// In en, this message translates to:
  /// **'Remind before'**
  String get remindBefore;

  /// No description provided for @enableOverdueReminders.
  ///
  /// In en, this message translates to:
  /// **'Enable overdue reminders'**
  String get enableOverdueReminders;

  /// No description provided for @settingsAppliedImmediately.
  ///
  /// In en, this message translates to:
  /// **'Settings are applied immediately.'**
  String get settingsAppliedImmediately;

  /// No description provided for @showRecommended.
  ///
  /// In en, this message translates to:
  /// **'Show recommended'**
  String get showRecommended;

  /// No description provided for @showOptional.
  ///
  /// In en, this message translates to:
  /// **'Show optional'**
  String get showOptional;

  /// No description provided for @searchVaccine.
  ///
  /// In en, this message translates to:
  /// **'Search vaccine'**
  String get searchVaccine;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @enterNotes.
  ///
  /// In en, this message translates to:
  /// **'Enter notes'**
  String get enterNotes;

  /// No description provided for @notesSaved.
  ///
  /// In en, this message translates to:
  /// **'Notes saved'**
  String get notesSaved;

  String get healthCard;

  String get editHealthCard;

  String get allergies;

  String get enterAllergies;

  String get chronicDiseases;

  String get enterChronicDiseases;

  String get medicalExemption;

  String get healthCardSaved;

  /// No description provided for @emptyNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No vaccinations today'**
  String get emptyNotificationsTitle;

  /// No description provided for @emptyNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up for today'**
  String get emptyNotificationsSubtitle;

  /// No description provided for @noVaccinesToday.
  ///
  /// In en, this message translates to:
  /// **'No vaccinations today'**
  String get noVaccinesToday;

  /// No description provided for @everythingUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Everything is up to date for today'**
  String get everythingUpToDate;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoading;

  /// No description provided for @noUpcomingVaccines.
  ///
  /// In en, this message translates to:
  /// **'No upcoming vaccinations'**
  String get noUpcomingVaccines;

  /// No description provided for @viewSchedule.
  ///
  /// In en, this message translates to:
  /// **'View schedule'**
  String get viewSchedule;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @enablePin.
  ///
  /// In en, this message translates to:
  /// **'Enable PIN'**
  String get enablePin;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @disablePin.
  ///
  /// In en, this message translates to:
  /// **'Disable PIN'**
  String get disablePin;

  /// No description provided for @useBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get useBiometrics;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @wrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get wrongPin;

  /// No description provided for @pinSaved.
  ///
  /// In en, this message translates to:
  /// **'PIN saved successfully'**
  String get pinSaved;

  /// No description provided for @pinDisabled.
  ///
  /// In en, this message translates to:
  /// **'PIN disabled'**
  String get pinDisabled;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Email is already registered'**
  String get emailAlreadyRegistered;

  /// No description provided for @pinProtection.
  ///
  /// In en, this message translates to:
  /// **'App Protection'**
  String get pinProtection;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @oldPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get oldPasswordRequired;

  /// No description provided for @newPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get newPasswordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @oldPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get oldPasswordIncorrect;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible. All data will be deleted.'**
  String get deleteAccountMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @invalidData.
  ///
  /// In en, this message translates to:
  /// **'Invalid data'**
  String get invalidData;

  /// No description provided for @dateCannotBeInFuture.
  ///
  /// In en, this message translates to:
  /// **'Date cannot be in the future'**
  String get dateCannotBeInFuture;

  /// No description provided for @vaccinationDateTooEarly.
  ///
  /// In en, this message translates to:
  /// **'Vaccination date is too early'**
  String get vaccinationDateTooEarly;

  /// No description provided for @intervalError.
  ///
  /// In en, this message translates to:
  /// **'Minimum interval between doses is not met'**
  String get intervalError;

  /// No description provided for @medicalExemptionActive.
  ///
  /// In en, this message translates to:
  /// **'Medical exemption is active'**
  String get medicalExemptionActive;

  /// No description provided for @setMedicalExemption.
  ///
  /// In en, this message translates to:
  /// **'Set medical exemption'**
  String get setMedicalExemption;

  /// No description provided for @confirmVaccinationTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm vaccination'**
  String get confirmVaccinationTitle;

  /// No description provided for @confirmVaccinationMessage.
  ///
  /// In en, this message translates to:
  /// **'Mark \"{vaccine}\" as completed?'**
  String confirmVaccinationMessage(Object vaccine);

  /// No description provided for @vaccineMarkedDone.
  ///
  /// In en, this message translates to:
  /// **'Vaccination marked as completed'**
  String get vaccineMarkedDone;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @availableLater.
  ///
  /// In en, this message translates to:
  /// **'Available when child reaches required age'**
  String get availableLater;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountConfirm;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @backupData.
  ///
  /// In en, this message translates to:
  /// **'Backup data'**
  String get backupData;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get backupFailed;

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get failedToLoadData;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(Object version);

  /// No description provided for @ageMonthsFormat.
  ///
  /// In en, this message translates to:
  /// **'{months} months'**
  String ageMonthsFormat(Object months);

  /// No description provided for @ageYearsFormat.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String ageYearsFormat(Object years);

  /// No description provided for @ageYearsMonthsFormat.
  ///
  /// In en, this message translates to:
  /// **'{years} y {months} m'**
  String ageYearsMonthsFormat(Object years, Object months);

  /// No description provided for @vaccinesInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccines information'**
  String get vaccinesInfoTitle;

  /// No description provided for @nationalVaccines.
  ///
  /// In en, this message translates to:
  /// **'National vaccines'**
  String get nationalVaccines;

  /// No description provided for @recommendedVaccines.
  ///
  /// In en, this message translates to:
  /// **'Recommended vaccines'**
  String get recommendedVaccines;

  /// No description provided for @customVaccines.
  ///
  /// In en, this message translates to:
  /// **'Additional vaccines'**
  String get customVaccines;

  /// No description provided for @optionalVaccines.
  ///
  /// In en, this message translates to:
  /// **'Optional vaccines'**
  String get optionalVaccines;

  /// No description provided for @emptyVaccinesTitle.
  ///
  /// In en, this message translates to:
  /// **'No vaccine data'**
  String get emptyVaccinesTitle;

  /// No description provided for @emptyVaccinesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccine list is empty. Add data and try again'**
  String get emptyVaccinesSubtitle;

  /// No description provided for @vaccine.
  ///
  /// In en, this message translates to:
  /// **'Vaccine'**
  String get vaccine;

  /// No description provided for @recommendedAge.
  ///
  /// In en, this message translates to:
  /// **'Recommended age'**
  String get recommendedAge;

  /// No description provided for @recommendedDate.
  ///
  /// In en, this message translates to:
  /// **'Recommended date'**
  String get recommendedDate;

  /// No description provided for @pdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Report'**
  String get pdfTitle;

  /// No description provided for @pdfChildName.
  ///
  /// In en, this message translates to:
  /// **'Child name'**
  String get pdfChildName;

  /// No description provided for @pdfBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get pdfBirthDate;

  /// No description provided for @pdfGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get pdfGenerated;

  /// No description provided for @pdfVaccine.
  ///
  /// In en, this message translates to:
  /// **'Vaccine'**
  String get pdfVaccine;

  /// No description provided for @pdfRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended date'**
  String get pdfRecommended;

  /// No description provided for @pdfStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get pdfStatus;

  /// No description provided for @pdfDoneAt.
  ///
  /// In en, this message translates to:
  /// **'Done at'**
  String get pdfDoneAt;

  /// No description provided for @pdfCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get pdfCompleted;

  /// No description provided for @pdfOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get pdfOverdue;

  /// No description provided for @pdfUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get pdfUpcoming;

  String get pdfPassportTitle;

  String get pdfHealthSection;

  String get pdfDoctorSignature;

  String get pdfQrCode;

  /// No description provided for @monthsShort.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get monthsShort;

  /// No description provided for @nationalSchedule.
  ///
  /// In en, this message translates to:
  /// **'National vaccination schedule'**
  String get nationalSchedule;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @vaccinesLoadingError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load vaccine list'**
  String get vaccinesLoadingError;

  /// No description provided for @vaccinesProtectsAgainst.
  ///
  /// In en, this message translates to:
  /// **'Protects against'**
  String get vaccinesProtectsAgainst;

  /// No description provided for @protectsAgainst.
  ///
  /// In en, this message translates to:
  /// **'Protects against'**
  String get protectsAgainst;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @reactions.
  ///
  /// In en, this message translates to:
  /// **'Possible reactions'**
  String get reactions;

  /// No description provided for @contraindications.
  ///
  /// In en, this message translates to:
  /// **'Contraindications'**
  String get contraindications;

  /// No description provided for @vaccineBcg.
  ///
  /// In en, this message translates to:
  /// **'BCG'**
  String get vaccineBcg;

  /// No description provided for @bcg.
  ///
  /// In en, this message translates to:
  /// **'BCG'**
  String get bcg;

  /// No description provided for @vaccineHepatitisB1.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B (1)'**
  String get vaccineHepatitisB1;

  /// No description provided for @hepatitis_b_1.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B (1)'**
  String get hepatitis_b_1;

  /// No description provided for @vaccineHepatitisB2.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B (2)'**
  String get vaccineHepatitisB2;

  /// No description provided for @hepatitis_b_2.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B (2)'**
  String get hepatitis_b_2;

  /// No description provided for @vaccineDtp1.
  ///
  /// In en, this message translates to:
  /// **'DTP (1)'**
  String get vaccineDtp1;

  /// No description provided for @akds_1.
  ///
  /// In en, this message translates to:
  /// **'DTP (1)'**
  String get akds_1;

  /// No description provided for @vaccineDtp2.
  ///
  /// In en, this message translates to:
  /// **'DTP (2)'**
  String get vaccineDtp2;

  /// No description provided for @akds_2.
  ///
  /// In en, this message translates to:
  /// **'DTP (2)'**
  String get akds_2;

  /// No description provided for @vaccineDtp3.
  ///
  /// In en, this message translates to:
  /// **'DTP (3)'**
  String get vaccineDtp3;

  /// No description provided for @akds_3.
  ///
  /// In en, this message translates to:
  /// **'DTP (3)'**
  String get akds_3;

  /// No description provided for @vaccineMmr.
  ///
  /// In en, this message translates to:
  /// **'MMR'**
  String get vaccineMmr;

  /// No description provided for @vaccineHepB1.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B (1)'**
  String get vaccineHepB1;

  /// No description provided for @vaccineHepB2.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B (2)'**
  String get vaccineHepB2;

  /// No description provided for @vaccineAkds1.
  ///
  /// In en, this message translates to:
  /// **'DTP (1)'**
  String get vaccineAkds1;

  /// No description provided for @vaccineAkds2.
  ///
  /// In en, this message translates to:
  /// **'DTP (2)'**
  String get vaccineAkds2;

  /// No description provided for @vaccineAkds3.
  ///
  /// In en, this message translates to:
  /// **'DTP (3)'**
  String get vaccineAkds3;

  /// No description provided for @vaccineInfluenza.
  ///
  /// In en, this message translates to:
  /// **'Influenza'**
  String get vaccineInfluenza;

  /// No description provided for @vaccineVaricella.
  ///
  /// In en, this message translates to:
  /// **'Varicella'**
  String get vaccineVaricella;

  /// No description provided for @vaccineHpv.
  ///
  /// In en, this message translates to:
  /// **'HPV'**
  String get vaccineHpv;

  /// No description provided for @vaccinePneumococcal.
  ///
  /// In en, this message translates to:
  /// **'Pneumococcal'**
  String get vaccinePneumococcal;

  /// No description provided for @vaccineMeningococcal.
  ///
  /// In en, this message translates to:
  /// **'Meningococcal'**
  String get vaccineMeningococcal;

  /// No description provided for @vaccineRotavirus.
  ///
  /// In en, this message translates to:
  /// **'Rotavirus'**
  String get vaccineRotavirus;

  /// No description provided for @vaccineHib.
  ///
  /// In en, this message translates to:
  /// **'Hib'**
  String get vaccineHib;

  /// No description provided for @kpk.
  ///
  /// In en, this message translates to:
  /// **'MMR'**
  String get kpk;

  /// No description provided for @vaccineDiseasesBcg.
  ///
  /// In en, this message translates to:
  /// **'Tuberculosis'**
  String get vaccineDiseasesBcg;

  /// No description provided for @vaccineDiseasesHepatitisB.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B'**
  String get vaccineDiseasesHepatitisB;

  /// No description provided for @vaccineDiseasesDtp.
  ///
  /// In en, this message translates to:
  /// **'Diphtheria, pertussis, tetanus'**
  String get vaccineDiseasesDtp;

  /// No description provided for @vaccineDiseasesMmr.
  ///
  /// In en, this message translates to:
  /// **'Measles, mumps, rubella'**
  String get vaccineDiseasesMmr;

  /// No description provided for @vaccineDescriptionBcg.
  ///
  /// In en, this message translates to:
  /// **'BCG protects children from severe forms of tuberculosis.'**
  String get vaccineDescriptionBcg;

  /// No description provided for @vaccineDescriptionHepatitisB1.
  ///
  /// In en, this message translates to:
  /// **'The first dose of hepatitis B vaccine.'**
  String get vaccineDescriptionHepatitisB1;

  /// No description provided for @vaccineDescriptionHepatitisB2.
  ///
  /// In en, this message translates to:
  /// **'The second dose of hepatitis B vaccine.'**
  String get vaccineDescriptionHepatitisB2;

  /// No description provided for @vaccineDescriptionDtp1.
  ///
  /// In en, this message translates to:
  /// **'The first dose of combined DTP vaccine.'**
  String get vaccineDescriptionDtp1;

  /// No description provided for @vaccineDescriptionDtp2.
  ///
  /// In en, this message translates to:
  /// **'The second dose of DTP vaccine.'**
  String get vaccineDescriptionDtp2;

  /// No description provided for @vaccineDescriptionDtp3.
  ///
  /// In en, this message translates to:
  /// **'The third dose of DTP vaccine.'**
  String get vaccineDescriptionDtp3;

  /// No description provided for @vaccineDescriptionMmr.
  ///
  /// In en, this message translates to:
  /// **'MMR is a combined vaccine against measles, mumps, and rubella.'**
  String get vaccineDescriptionMmr;

  /// No description provided for @bcgDisease.
  ///
  /// In en, this message translates to:
  /// **'Tuberculosis'**
  String get bcgDisease;

  /// No description provided for @hepBDisease.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B'**
  String get hepBDisease;

  /// No description provided for @hepatitisBDisease.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B'**
  String get hepatitisBDisease;

  /// No description provided for @akdsDisease.
  ///
  /// In en, this message translates to:
  /// **'Diphtheria, pertussis, tetanus'**
  String get akdsDisease;

  /// No description provided for @mmrDisease.
  ///
  /// In en, this message translates to:
  /// **'Measles, mumps, rubella'**
  String get mmrDisease;

  /// No description provided for @kpkDisease.
  ///
  /// In en, this message translates to:
  /// **'Measles, rubella, mumps'**
  String get kpkDisease;

  /// No description provided for @influenzaDisease.
  ///
  /// In en, this message translates to:
  /// **'Influenza'**
  String get influenzaDisease;

  /// No description provided for @varicellaDisease.
  ///
  /// In en, this message translates to:
  /// **'Chickenpox'**
  String get varicellaDisease;

  /// No description provided for @hpvDisease.
  ///
  /// In en, this message translates to:
  /// **'HPV infection'**
  String get hpvDisease;

  /// No description provided for @pneumococcalDisease.
  ///
  /// In en, this message translates to:
  /// **'Pneumococcal infections'**
  String get pneumococcalDisease;

  /// No description provided for @meningococcalDisease.
  ///
  /// In en, this message translates to:
  /// **'Meningococcal infection'**
  String get meningococcalDisease;

  /// No description provided for @rotavirusDisease.
  ///
  /// In en, this message translates to:
  /// **'Rotavirus infection'**
  String get rotavirusDisease;

  /// No description provided for @hibDisease.
  ///
  /// In en, this message translates to:
  /// **'Hib infections'**
  String get hibDisease;

  /// No description provided for @bcgDescription.
  ///
  /// In en, this message translates to:
  /// **'Protects children from severe forms of tuberculosis.'**
  String get bcgDescription;

  /// No description provided for @hepBDescription.
  ///
  /// In en, this message translates to:
  /// **'Protects against viral hepatitis B, a liver infection.'**
  String get hepBDescription;

  /// No description provided for @hepatitisB1Description.
  ///
  /// In en, this message translates to:
  /// **'First dose of the hepatitis B vaccine.'**
  String get hepatitisB1Description;

  /// No description provided for @hepatitisB2Description.
  ///
  /// In en, this message translates to:
  /// **'Second dose of the hepatitis B vaccine.'**
  String get hepatitisB2Description;

  /// No description provided for @akdsDescription.
  ///
  /// In en, this message translates to:
  /// **'Combined vaccine against diphtheria, pertussis, and tetanus.'**
  String get akdsDescription;

  /// No description provided for @akds1Description.
  ///
  /// In en, this message translates to:
  /// **'First dose of combined DTP vaccine.'**
  String get akds1Description;

  /// No description provided for @akds2Description.
  ///
  /// In en, this message translates to:
  /// **'Second dose of DTP vaccine.'**
  String get akds2Description;

  /// No description provided for @akds3Description.
  ///
  /// In en, this message translates to:
  /// **'Third dose of DTP vaccine.'**
  String get akds3Description;

  /// No description provided for @mmrDescription.
  ///
  /// In en, this message translates to:
  /// **'Combined vaccine against measles, mumps, and rubella.'**
  String get mmrDescription;

  /// No description provided for @kpkDescription.
  ///
  /// In en, this message translates to:
  /// **'Combined vaccine against measles, rubella, and mumps.'**
  String get kpkDescription;

  /// No description provided for @influenzaDescription.
  ///
  /// In en, this message translates to:
  /// **'Reduces risk of severe influenza and complications.'**
  String get influenzaDescription;

  /// No description provided for @varicellaDescription.
  ///
  /// In en, this message translates to:
  /// **'Protects against chickenpox and related complications.'**
  String get varicellaDescription;

  /// No description provided for @hpvDescription.
  ///
  /// In en, this message translates to:
  /// **'Protects against HPV and related complications.'**
  String get hpvDescription;

  /// No description provided for @pneumococcalDescription.
  ///
  /// In en, this message translates to:
  /// **'Reduces risk of pneumonia, otitis, and meningitis.'**
  String get pneumococcalDescription;

  /// No description provided for @meningococcalDescription.
  ///
  /// In en, this message translates to:
  /// **'Protects against severe meningococcal disease.'**
  String get meningococcalDescription;

  /// No description provided for @rotavirusDescription.
  ///
  /// In en, this message translates to:
  /// **'Reduces risk of severe dehydration from rotavirus.'**
  String get rotavirusDescription;

  /// No description provided for @hibDescription.
  ///
  /// In en, this message translates to:
  /// **'Protects against invasive Hib infections, including meningitis.'**
  String get hibDescription;

  /// No description provided for @bcgReactions.
  ///
  /// In en, this message translates to:
  /// **'Redness and swelling at injection site.'**
  String get bcgReactions;

  /// No description provided for @hepBReactions.
  ///
  /// In en, this message translates to:
  /// **'Mild pain at injection site, possible low fever.'**
  String get hepBReactions;

  /// No description provided for @hepatitisBReactions.
  ///
  /// In en, this message translates to:
  /// **'Mild pain at injection site, temporary weakness.'**
  String get hepatitisBReactions;

  /// No description provided for @akdsReactions.
  ///
  /// In en, this message translates to:
  /// **'Short-term fever, irritability.'**
  String get akdsReactions;

  /// No description provided for @mmrReactions.
  ///
  /// In en, this message translates to:
  /// **'Mild fever or light rash.'**
  String get mmrReactions;

  /// No description provided for @kpkReactions.
  ///
  /// In en, this message translates to:
  /// **'Mild fever, weakness.'**
  String get kpkReactions;

  /// No description provided for @influenzaReactions.
  ///
  /// In en, this message translates to:
  /// **'Injection site pain, short-term malaise.'**
  String get influenzaReactions;

  /// No description provided for @varicellaReactions.
  ///
  /// In en, this message translates to:
  /// **'Injection site redness, sometimes mild fever.'**
  String get varicellaReactions;

  /// No description provided for @hpvReactions.
  ///
  /// In en, this message translates to:
  /// **'Injection site soreness, temporary weakness.'**
  String get hpvReactions;

  /// No description provided for @pneumococcalReactions.
  ///
  /// In en, this message translates to:
  /// **'Injection site redness, short-term fever.'**
  String get pneumococcalReactions;

  /// No description provided for @meningococcalReactions.
  ///
  /// In en, this message translates to:
  /// **'Soreness, redness, sometimes mild fever.'**
  String get meningococcalReactions;

  /// No description provided for @rotavirusReactions.
  ///
  /// In en, this message translates to:
  /// **'Temporary fussiness, rare mild digestive symptoms.'**
  String get rotavirusReactions;

  /// No description provided for @hibReactions.
  ///
  /// In en, this message translates to:
  /// **'Redness, moderate soreness, short-term fever.'**
  String get hibReactions;

  /// No description provided for @bcgContra.
  ///
  /// In en, this message translates to:
  /// **'High fever, immunodeficiency, acute infections.'**
  String get bcgContra;

  /// No description provided for @hepBContra.
  ///
  /// In en, this message translates to:
  /// **'Allergic reaction to a previous dose.'**
  String get hepBContra;

  /// No description provided for @akdsContra.
  ///
  /// In en, this message translates to:
  /// **'Severe reaction to previous dose, high fever.'**
  String get akdsContra;

  /// No description provided for @mmrContra.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy, immunodeficiency, severe allergy.'**
  String get mmrContra;

  /// No description provided for @influenzaContra.
  ///
  /// In en, this message translates to:
  /// **'Allergy to vaccine components, high fever.'**
  String get influenzaContra;

  /// No description provided for @varicellaContra.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy, immunodeficiency.'**
  String get varicellaContra;

  /// No description provided for @hpvContra.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy, allergy to vaccine components.'**
  String get hpvContra;

  /// No description provided for @pneumococcalContra.
  ///
  /// In en, this message translates to:
  /// **'Allergic reaction to previous dose.'**
  String get pneumococcalContra;

  /// No description provided for @meningococcalContra.
  ///
  /// In en, this message translates to:
  /// **'Severe allergy to vaccine components.'**
  String get meningococcalContra;

  /// No description provided for @rotavirusContra.
  ///
  /// In en, this message translates to:
  /// **'Immunodeficiency, intestinal obstruction.'**
  String get rotavirusContra;

  /// No description provided for @hibContra.
  ///
  /// In en, this message translates to:
  /// **'Allergic reaction to previous dose.'**
  String get hibContra;

  /// No description provided for @reminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Vaccination reminders'**
  String get reminderChannelName;

  /// No description provided for @reminderChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Daily vaccination reminders'**
  String get reminderChannelDescription;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations today'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'You need to do {count} vaccinations today'**
  String reminderBody(Object count);

  /// No description provided for @smartReminderSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccination soon'**
  String get smartReminderSoonTitle;

  /// No description provided for @smartReminderDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccination due today'**
  String get smartReminderDueTitle;

  /// No description provided for @smartReminderOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccination overdue'**
  String get smartReminderOverdueTitle;

  /// No description provided for @smartReminderDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccination reminder'**
  String get smartReminderDefaultTitle;

  /// No description provided for @smartReminderSoonBody.
  ///
  /// In en, this message translates to:
  /// **'{childName}: {vaccineName} in {days} days'**
  String smartReminderSoonBody(Object childName, Object vaccineName, Object days);

  /// No description provided for @smartReminderDueBody.
  ///
  /// In en, this message translates to:
  /// **'{childName}: {vaccineName} is due today'**
  String smartReminderDueBody(Object childName, Object vaccineName);

  /// No description provided for @smartReminderOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'{childName}: {vaccineName} overdue by {days} days'**
  String smartReminderOverdueBody(Object childName, Object vaccineName, Object days);

  /// No description provided for @smartReminderDefaultBody.
  ///
  /// In en, this message translates to:
  /// **'{childName}: {vaccineName}'**
  String smartReminderDefaultBody(Object childName, Object vaccineName);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
    case 'uz': return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
