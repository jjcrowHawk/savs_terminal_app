import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter_localizations/flutter_localizations.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Seismic Vulnerability Terminal App',
      'ficha': 'Files',
      'sincro': 'Sync Files',
      'info':'About',
      'ver_ficha':'View Files',
      'nueva_ficha':'New File',
      'editar_ficha':'Edit Files',
      'eliminar_ficha':'Delete Files',
    },
    'es': {
      'title': 'App para fichas de vulnerabilidad Sismica',
      'ficha': 'Fichas',
      'sincro': 'Sincronización',
      'info': 'Información',
      'ver_ficha':'Ver Fichas',
      'nueva_ficha':'Nueva Ficha',
      'editar_ficha':'Editar Fichas',
      'eliminar_ficha':'Eliminar Fichas',
    },
  };

  Map<String, String> get localizedValues =>
      _localizedValues[locale.languageCode];

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get ficha{
    return _localizedValues[locale.languageCode]['ficha'];
  }
}

class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}