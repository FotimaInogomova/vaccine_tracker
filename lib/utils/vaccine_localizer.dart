import '../l10n/app_localizations.dart';

class VaccineLocalizer {
  static String _fallback(AppLocalizations loc) => loc.noData;

  static String contraindicationsTitle(AppLocalizations loc) {
    return loc.contraindications;
  }

  static String name(AppLocalizations loc, String key) {
    switch (key) {
      case 'bcg':
        return loc.vaccineBcg;
      case 'hepatitis_b_1':
        return loc.vaccineHepB1;
      case 'hepatitis_b_2':
        return loc.vaccineHepB2;
      case 'akds_1':
        return loc.vaccineAkds1;
      case 'akds_2':
        return loc.vaccineAkds2;
      case 'akds_3':
        return loc.vaccineAkds3;
      case 'kpk':
      case 'mmr':
        return loc.vaccineMmr;
      case 'influenza':
        return loc.vaccineInfluenza;
      case 'varicella':
        return loc.vaccineVaricella;
      case 'hpv':
        return loc.vaccineHpv;
      case 'pneumococcal':
        return loc.vaccinePneumococcal;
      case 'meningococcal':
        return loc.vaccineMeningococcal;
      case 'rotavirus':
        return loc.vaccineRotavirus;
      case 'hib':
        return loc.vaccineHib;
      default:
        return _fallback(loc);
    }
  }

  static String translate(AppLocalizations loc, String key) => name(loc, key);

  static String disease(AppLocalizations loc, String key) {
    switch (key) {
      case 'bcg':
        return loc.bcgDisease;
      case 'hepatitis_b_1':
      case 'hepatitis_b_2':
        return loc.hepatitisBDisease;
      case 'akds_1':
      case 'akds_2':
      case 'akds_3':
        return loc.akdsDisease;
      case 'kpk':
        return loc.kpkDisease;
      case 'mmr':
        return loc.mmrDisease;
      case 'hpv':
        return loc.hpvDisease;
      case 'influenza':
        return loc.influenzaDisease;
      case 'varicella':
        return loc.varicellaDisease;
      case 'pneumococcal':
        return loc.pneumococcalDisease;
      case 'meningococcal':
        return loc.meningococcalDisease;
      case 'rotavirus':
        return loc.rotavirusDisease;
      case 'hib':
        return loc.hibDisease;
      default:
        return _fallback(loc);
    }
  }

  static String description(AppLocalizations loc, String key) {
    switch (key) {
      case 'bcg':
        return loc.bcgDescription;
      case 'hepatitis_b_1':
        return loc.hepatitisB1Description;
      case 'hepatitis_b_2':
        return loc.hepatitisB2Description;
      case 'akds_1':
        return loc.akds1Description;
      case 'akds_2':
        return loc.akds2Description;
      case 'akds_3':
        return loc.akds3Description;
      case 'kpk':
        return loc.kpkDescription;
      case 'mmr':
        return loc.mmrDescription;
      case 'hpv':
        return loc.hpvDescription;
      case 'influenza':
        return loc.influenzaDescription;
      case 'varicella':
        return loc.varicellaDescription;
      case 'pneumococcal':
        return loc.pneumococcalDescription;
      case 'meningococcal':
        return loc.meningococcalDescription;
      case 'rotavirus':
        return loc.rotavirusDescription;
      case 'hib':
        return loc.hibDescription;
      default:
        return _fallback(loc);
    }
  }

  static String reactions(AppLocalizations loc, String key) {
    switch (key) {
      case 'bcg':
        return loc.bcgReactions;
      case 'hepatitis_b_1':
      case 'hepatitis_b_2':
        return loc.hepatitisBReactions;
      case 'akds_1':
      case 'akds_2':
      case 'akds_3':
        return loc.akdsReactions;
      case 'kpk':
        return loc.kpkReactions;
      case 'mmr':
        return loc.mmrReactions;
      case 'hpv':
        return loc.hpvReactions;
      case 'influenza':
        return loc.influenzaReactions;
      case 'varicella':
        return loc.varicellaReactions;
      case 'pneumococcal':
        return loc.pneumococcalReactions;
      case 'meningococcal':
        return loc.meningococcalReactions;
      case 'rotavirus':
        return loc.rotavirusReactions;
      case 'hib':
        return loc.hibReactions;
      default:
        return _fallback(loc);
    }
  }

  static String contraindications(AppLocalizations loc, String key) {
    switch (key) {
      case 'bcg':
        return loc.bcgContra;
      case 'hepatitis_b_1':
      case 'hepatitis_b_2':
        return loc.hepBContra;
      case 'akds_1':
      case 'akds_2':
      case 'akds_3':
        return loc.akdsContra;
      case 'kpk':
      case 'mmr':
        return loc.mmrContra;
      case 'influenza':
        return loc.influenzaContra;
      case 'varicella':
        return loc.varicellaContra;
      case 'hpv':
        return loc.hpvContra;
      case 'pneumococcal':
        return loc.pneumococcalContra;
      case 'meningococcal':
        return loc.meningococcalContra;
      case 'rotavirus':
        return loc.rotavirusContra;
      case 'hib':
        return loc.hibContra;
      default:
        return _fallback(loc);
    }
  }
}
