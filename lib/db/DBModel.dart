import 'SqfEntityBase.dart';

/*
TABLA VIVIENDA
 */
class TableVivienda extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableVivienda();
    return _instance;
  }

  TableVivienda() {
    tableName = "Vivienda";
    modelName = null;
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityField("inspeccion_id", DbType.text),
      SqfEntityField("edad_construccion",DbType.integer,defaultValue: "0"),
      SqfEntityField("elevacion",DbType.real,defaultValue: "null"),
      SqfEntityField("sector",DbType.text,defaultValue: ""),
      SqfEntityField("direccion", DbType.text,defaultValue: ""),
      SqfEntityField("ubicacion", DbType.text,defaultValue: "")
    ];

    super.init();
  }
}

/*
TABLA FICHA
 */
class TableFicha extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableFicha();
    return _instance;
  }

  TableFicha() {
    tableName = "Ficha";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityField("inspector", DbType.text),
      SqfEntityField("fecha_inspeccion", DbType.text),
      SqfEntityField("estado", DbType.text, defaultValue: "Pendiente"),
      SqfEntityField("activo", DbType.bool, defaultValue: "true"),
      SqfEntityFieldRelationship(TableVivienda.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
    ];
    super.init();
  }
}

/*
TABLA ANEXO
 */
class TableAnexo extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableAnexo();
    return _instance;
  }

  TableAnexo() {
    tableName = "Anexo";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityField("url_anexo", DbType.text),
      SqfEntityField("tipo", DbType.text),
      SqfEntityFieldRelationship(TableFicha.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
    ];
    super.init();
  }
}


/*
TABLA SECCION
 */
class TableSeccion extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableSeccion();
    return _instance;
  }

  TableSeccion() {
    tableName = "Seccion";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityField("nombre", DbType.text),
      SqfEntityField("activo", DbType.bool,defaultValue: "true"),
    ];
    super.init();
  }
}

/*
TABLA VARIABLE
 */
class TableVariable extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableVariable();
    return _instance;
  }

  TableVariable() {
    tableName = "Variable";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityField("nombre", DbType.text),
      SqfEntityField("obligatoria", DbType.bool,defaultValue: "true"),
      SqfEntityField("activo", DbType.bool,defaultValue: "true"),
      SqfEntityFieldRelationship(TableSeccion.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
    ];
    super.init();
  }
}

/*
TABLA ITEMVARIABLE
 */
class TableItemVariable extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableItemVariable();
    return _instance;
  }

  TableItemVariable() {
    tableName = "ItemVariable";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityField("nombre", DbType.text),
      SqfEntityField("tipo", DbType.text),
      SqfEntityField("activo", DbType.bool,defaultValue: "true"),
      SqfEntityFieldRelationship(TableVariable.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
    ];
    super.init();
  }
}

/*
TABLA OPCION
 */
class TableOpcion extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableOpcion();
    return _instance;
  }

  TableOpcion() {
    tableName = "Opcion";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityField("nombre", DbType.text),
      SqfEntityField("activo", DbType.bool,defaultValue: "true"),
      SqfEntityFieldRelationship(TableItemVariable.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
    ];
    super.init();
  }
}

/*
TABLA RESPUESTA
 */
class TableRespuesta extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableRespuesta();
    return _instance;
  }

  TableRespuesta() {
    tableName = "Respuesta";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityField("nota", DbType.text),
      SqfEntityField("activo", DbType.bool,defaultValue: "true"),
      SqfEntityFieldRelationship(TableItemVariable.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
      SqfEntityFieldRelationship(TableFicha.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
    ];
    super.init();
  }
}

/*
TABLA RESPUESTA TEXTO (TABLA HIJA DE RESPUESTA)
 */
class TableRespuestaTexto extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableRespuestaTexto();
    return _instance;
  }

  TableRespuestaTexto() {
    tableName = "RespuestaTexto";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityField("texto", DbType.text),
      SqfEntityFieldRelationship(TableRespuesta.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
    ];
    super.init();
  }
}

/*
TABLA RESPUESTA OPCION SIMPLE(TABLA HIJA DE RESPUESTA)
 */
class TableRespuestaOpcionSimple extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableRespuestaOpcionSimple();
    return _instance;
  }

  TableRespuestaOpcionSimple() {
    tableName = "RespuestaOpcionSimple";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityFieldRelationship(TableOpcion.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
      SqfEntityFieldRelationship(TableRespuesta.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
    ];
    super.init();
  }
}

/*
TABLA RESPUESTA OPCION MULTIPLE (TABLA HIJA DE RESPUESTA)
 */
class TableRespuestaOpcionMultiple extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableRespuestaOpcionMultiple();
    return _instance;
  }

  TableRespuestaOpcionMultiple() {
    tableName = "RespuestaOpcionMultiple";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityFieldRelationship(TableRespuesta.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
    ];
    super.init();
  }
}

/*
TABLA OPCION RESPUESTA (TABLA INTERMEDIA DE RESPUESTAOPCIONMULTIPLE-OPCION)
 */
class TableOpcionRespuesta extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableOpcionRespuesta();
    return _instance;
  }

  TableOpcionRespuesta() {
    tableName = "RespuestaOpcionRespuesta";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    fields = [
      SqfEntityFieldRelationship(TableRespuestaOpcionMultiple.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
      SqfEntityFieldRelationship(TableOpcion.getInstance,
          DeleteRule.CASCADE, defaultValue: "0"),
    ];
    super.init();
  }
}

/*
DBCONTEXT HELPER
 */
class DbModel extends SqfEntityModel {
  DbModel() {
    databaseName = "fichas.db";
    databaseTables = [
      TableVivienda.getInstance,
      TableFicha.getInstance,
      TableAnexo.getInstance,
      TableSeccion.getInstance,
      TableVariable.getInstance,
      TableItemVariable.getInstance,
      TableOpcion.getInstance,
      TableRespuesta.getInstance,
      TableRespuestaTexto.getInstance,
      TableRespuestaOpcionSimple.getInstance,
      TableRespuestaOpcionMultiple.getInstance,
      TableOpcionRespuesta.getInstance,
    ];
    bundledDatabasePath = null;
  }
}