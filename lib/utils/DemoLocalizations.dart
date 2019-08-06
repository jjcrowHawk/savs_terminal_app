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
      'estado': 'STATE',
      'pendiente': 'Pending',
      'finalizada': 'Finished',
      'enviada': 'Sent',
      'sincro_mensaje':'The synchronization process will attempt to send the new forms of this phone to the web server, therefore an active internet connection is required for the synchronization to run correctly.',
      'sincro_ahora': 'Sync now',
      'titulo_eliminar': 'Are you sure you want to delete this form?',
      'mensaje_eliminar': 'Accepting this dialogue implies that this record will be deleted in its entirety and it will be impossible to recover it.',
      'exito_eliminar': 'The record has been deleted successfully',
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
      'estado': 'ESTADO',
      'pendiente': 'pendiente',
      'finalizada': 'finalizada',
      'enviada': 'enviada',
      'sincro_mensaje': 'El proceso de sincronización intentara enviar las fichas nuevas de este teléfono al servidor web, por lo tanto se requiere una conexión al internet activa para que la sincronización se ejecute correctamente.',
      'sincro_ahora': 'Sincronizar ahora',
      'titulo_eliminar': '¿Está seguro que desea eliminar esta ficha?',
      'mensaje_eliminar': 'Aceptar este dialogo implica que este registro será eliminado en su totalidad y será imposible recuperarlo.',
      'exito_eliminar': 'El registro ha sido eliminado exitosamente',
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