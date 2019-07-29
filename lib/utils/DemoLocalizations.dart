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
      'ficha': 'Forms',
      'sincro': 'Sync Forms',
      'info':'About',
      'ver_ficha':'Review Forms',
      'nueva_ficha':'New Form',
      'editar_ficha':'Edit Forms',
      'eliminar_ficha':'Delete Forms',
      'estado': 'state',
      'Pendiente': 'Pending',
      'Finalizada': 'Finished',
      'Enviada': 'Sent',
      'sincro_mensaje':'The synchronization process will attempt to send the new forms of this phone to the web server, therefore an active internet connection is required for the synchronization to run correctly.',
      'sincro_ahora': 'Sync now',
    },
    'es': {
      'title': 'App para fichas de vulnerabilidad Sismica',
      'ficha': 'Fichas',
      'sincro': 'Sincronización',
      'info': 'Información',
      'ver_ficha':'Revisar Fichas',
      'nueva_ficha':'Nueva Ficha',
      'editar_ficha':'Editar Fichas',
      'eliminar_ficha':'Eliminar Fichas',
      'estado': 'estado',
      'Pendiente': 'pendiente',
      'Finalizada': 'finalizada',
      'Enviada': 'enviada',
      'sincro_mensaje': 'El proceso de sincronización intentara enviar las fichas nuevas de este teléfono al servidor web, por lo tanto se requiere una conexión al internet activa para que la sincronización se ejecute correctamente.',
      'sincro_ahora': 'Sincronizar ahora',
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