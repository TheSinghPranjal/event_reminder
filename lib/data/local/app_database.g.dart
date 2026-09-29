// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, EventCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    name,
    iconKey,
    color,
    isBuiltIn,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class EventCategory extends DataClass implements Insertable<EventCategory> {
  final int id;

  /// Stable key for built-in categories (e.g. `birthdays`), used when mapping
  /// imported events to a category. Null for custom categories.
  final String? slug;
  final String name;

  /// Key into the category icon registry (see `category_icons.dart`).
  final String iconKey;

  /// ARGB color value.
  final int color;
  final bool isBuiltIn;
  final int sortOrder;
  final DateTime createdAt;
  const EventCategory({
    required this.id,
    this.slug,
    required this.name,
    required this.iconKey,
    required this.color,
    required this.isBuiltIn,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || slug != null) {
      map['slug'] = Variable<String>(slug);
    }
    map['name'] = Variable<String>(name);
    map['icon_key'] = Variable<String>(iconKey);
    map['color'] = Variable<int>(color);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      slug: slug == null && nullToAbsent ? const Value.absent() : Value(slug),
      name: Value(name),
      iconKey: Value(iconKey),
      color: Value(color),
      isBuiltIn: Value(isBuiltIn),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory EventCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventCategory(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String?>(json['slug']),
      name: serializer.fromJson<String>(json['name']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      color: serializer.fromJson<int>(json['color']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String?>(slug),
      'name': serializer.toJson<String>(name),
      'iconKey': serializer.toJson<String>(iconKey),
      'color': serializer.toJson<int>(color),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EventCategory copyWith({
    int? id,
    Value<String?> slug = const Value.absent(),
    String? name,
    String? iconKey,
    int? color,
    bool? isBuiltIn,
    int? sortOrder,
    DateTime? createdAt,
  }) => EventCategory(
    id: id ?? this.id,
    slug: slug.present ? slug.value : this.slug,
    name: name ?? this.name,
    iconKey: iconKey ?? this.iconKey,
    color: color ?? this.color,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  EventCategory copyWithCompanion(CategoriesCompanion data) {
    return EventCategory(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      color: data.color.present ? data.color.value : this.color,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventCategory(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('iconKey: $iconKey, ')
          ..write('color: $color, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    slug,
    name,
    iconKey,
    color,
    isBuiltIn,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventCategory &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.iconKey == this.iconKey &&
          other.color == this.color &&
          other.isBuiltIn == this.isBuiltIn &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<EventCategory> {
  final Value<int> id;
  final Value<String?> slug;
  final Value<String> name;
  final Value<String> iconKey;
  final Value<int> color;
  final Value<bool> isBuiltIn;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.color = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    required String name,
    required String iconKey,
    required int color,
    this.isBuiltIn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       iconKey = Value(iconKey),
       color = Value(color);
  static Insertable<EventCategory> custom({
    Expression<int>? id,
    Expression<String>? slug,
    Expression<String>? name,
    Expression<String>? iconKey,
    Expression<int>? color,
    Expression<bool>? isBuiltIn,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (iconKey != null) 'icon_key': iconKey,
      if (color != null) 'color': color,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String?>? slug,
    Value<String>? name,
    Value<String>? iconKey,
    Value<int>? color,
    Value<bool>? isBuiltIn,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      color: color ?? this.color,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('iconKey: $iconKey, ')
          ..write('color: $color, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LinkedAccountsTable extends LinkedAccounts
    with TableInfo<$LinkedAccountsTable, LinkedAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LinkedAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isStubMeta = const VerificationMeta('isStub');
  @override
  late final GeneratedColumn<bool> isStub = GeneratedColumn<bool>(
    'is_stub',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_stub" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _calendarAccessGrantedMeta =
      const VerificationMeta('calendarAccessGranted');
  @override
  late final GeneratedColumn<bool> calendarAccessGranted =
      GeneratedColumn<bool>(
        'calendar_access_granted',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("calendar_access_granted" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _connectedAtMeta = const VerificationMeta(
    'connectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> connectedAt = GeneratedColumn<DateTime>(
    'connected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastSyncSuccessAtMeta = const VerificationMeta(
    'lastSyncSuccessAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncSuccessAt =
      GeneratedColumn<DateTime>(
        'last_sync_success_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSyncAttemptAtMeta = const VerificationMeta(
    'lastSyncAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAttemptAt =
      GeneratedColumn<DateTime>(
        'last_sync_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSyncErrorMeta = const VerificationMeta(
    'lastSyncError',
  );
  @override
  late final GeneratedColumn<String> lastSyncError = GeneratedColumn<String>(
    'last_sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    displayName,
    photoUrl,
    isStub,
    calendarAccessGranted,
    connectedAt,
    lastSyncSuccessAt,
    lastSyncAttemptAt,
    lastSyncError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'linked_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LinkedAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('is_stub')) {
      context.handle(
        _isStubMeta,
        isStub.isAcceptableOrUnknown(data['is_stub']!, _isStubMeta),
      );
    }
    if (data.containsKey('calendar_access_granted')) {
      context.handle(
        _calendarAccessGrantedMeta,
        calendarAccessGranted.isAcceptableOrUnknown(
          data['calendar_access_granted']!,
          _calendarAccessGrantedMeta,
        ),
      );
    }
    if (data.containsKey('connected_at')) {
      context.handle(
        _connectedAtMeta,
        connectedAt.isAcceptableOrUnknown(
          data['connected_at']!,
          _connectedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_success_at')) {
      context.handle(
        _lastSyncSuccessAtMeta,
        lastSyncSuccessAt.isAcceptableOrUnknown(
          data['last_sync_success_at']!,
          _lastSyncSuccessAtMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_attempt_at')) {
      context.handle(
        _lastSyncAttemptAtMeta,
        lastSyncAttemptAt.isAcceptableOrUnknown(
          data['last_sync_attempt_at']!,
          _lastSyncAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_error')) {
      context.handle(
        _lastSyncErrorMeta,
        lastSyncError.isAcceptableOrUnknown(
          data['last_sync_error']!,
          _lastSyncErrorMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinkedAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LinkedAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      isStub: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_stub'],
      )!,
      calendarAccessGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}calendar_access_granted'],
      )!,
      connectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}connected_at'],
      )!,
      lastSyncSuccessAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_success_at'],
      ),
      lastSyncAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_attempt_at'],
      ),
      lastSyncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_error'],
      ),
    );
  }

  @override
  $LinkedAccountsTable createAlias(String alias) {
    return $LinkedAccountsTable(attachedDatabase, alias);
  }
}

class LinkedAccount extends DataClass implements Insertable<LinkedAccount> {
  /// Google account (subject) ID.
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  /// True when the account came from the developer stub, not real Google.
  final bool isStub;

  /// Calendar access is authorized separately from sign-in.
  final bool calendarAccessGranted;
  final DateTime connectedAt;

  /// Last time a sync finished successfully.
  final DateTime? lastSyncSuccessAt;

  /// Last attempt (successful or not), with its outcome.
  final DateTime? lastSyncAttemptAt;
  final String? lastSyncError;
  const LinkedAccount({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.isStub,
    required this.calendarAccessGranted,
    required this.connectedAt,
    this.lastSyncSuccessAt,
    this.lastSyncAttemptAt,
    this.lastSyncError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['is_stub'] = Variable<bool>(isStub);
    map['calendar_access_granted'] = Variable<bool>(calendarAccessGranted);
    map['connected_at'] = Variable<DateTime>(connectedAt);
    if (!nullToAbsent || lastSyncSuccessAt != null) {
      map['last_sync_success_at'] = Variable<DateTime>(lastSyncSuccessAt);
    }
    if (!nullToAbsent || lastSyncAttemptAt != null) {
      map['last_sync_attempt_at'] = Variable<DateTime>(lastSyncAttemptAt);
    }
    if (!nullToAbsent || lastSyncError != null) {
      map['last_sync_error'] = Variable<String>(lastSyncError);
    }
    return map;
  }

  LinkedAccountsCompanion toCompanion(bool nullToAbsent) {
    return LinkedAccountsCompanion(
      id: Value(id),
      email: Value(email),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      isStub: Value(isStub),
      calendarAccessGranted: Value(calendarAccessGranted),
      connectedAt: Value(connectedAt),
      lastSyncSuccessAt: lastSyncSuccessAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncSuccessAt),
      lastSyncAttemptAt: lastSyncAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAttemptAt),
      lastSyncError: lastSyncError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncError),
    );
  }

  factory LinkedAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinkedAccount(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      isStub: serializer.fromJson<bool>(json['isStub']),
      calendarAccessGranted: serializer.fromJson<bool>(
        json['calendarAccessGranted'],
      ),
      connectedAt: serializer.fromJson<DateTime>(json['connectedAt']),
      lastSyncSuccessAt: serializer.fromJson<DateTime?>(
        json['lastSyncSuccessAt'],
      ),
      lastSyncAttemptAt: serializer.fromJson<DateTime?>(
        json['lastSyncAttemptAt'],
      ),
      lastSyncError: serializer.fromJson<String?>(json['lastSyncError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String?>(displayName),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'isStub': serializer.toJson<bool>(isStub),
      'calendarAccessGranted': serializer.toJson<bool>(calendarAccessGranted),
      'connectedAt': serializer.toJson<DateTime>(connectedAt),
      'lastSyncSuccessAt': serializer.toJson<DateTime?>(lastSyncSuccessAt),
      'lastSyncAttemptAt': serializer.toJson<DateTime?>(lastSyncAttemptAt),
      'lastSyncError': serializer.toJson<String?>(lastSyncError),
    };
  }

  LinkedAccount copyWith({
    String? id,
    String? email,
    Value<String?> displayName = const Value.absent(),
    Value<String?> photoUrl = const Value.absent(),
    bool? isStub,
    bool? calendarAccessGranted,
    DateTime? connectedAt,
    Value<DateTime?> lastSyncSuccessAt = const Value.absent(),
    Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
    Value<String?> lastSyncError = const Value.absent(),
  }) => LinkedAccount(
    id: id ?? this.id,
    email: email ?? this.email,
    displayName: displayName.present ? displayName.value : this.displayName,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    isStub: isStub ?? this.isStub,
    calendarAccessGranted: calendarAccessGranted ?? this.calendarAccessGranted,
    connectedAt: connectedAt ?? this.connectedAt,
    lastSyncSuccessAt: lastSyncSuccessAt.present
        ? lastSyncSuccessAt.value
        : this.lastSyncSuccessAt,
    lastSyncAttemptAt: lastSyncAttemptAt.present
        ? lastSyncAttemptAt.value
        : this.lastSyncAttemptAt,
    lastSyncError: lastSyncError.present
        ? lastSyncError.value
        : this.lastSyncError,
  );
  LinkedAccount copyWithCompanion(LinkedAccountsCompanion data) {
    return LinkedAccount(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      isStub: data.isStub.present ? data.isStub.value : this.isStub,
      calendarAccessGranted: data.calendarAccessGranted.present
          ? data.calendarAccessGranted.value
          : this.calendarAccessGranted,
      connectedAt: data.connectedAt.present
          ? data.connectedAt.value
          : this.connectedAt,
      lastSyncSuccessAt: data.lastSyncSuccessAt.present
          ? data.lastSyncSuccessAt.value
          : this.lastSyncSuccessAt,
      lastSyncAttemptAt: data.lastSyncAttemptAt.present
          ? data.lastSyncAttemptAt.value
          : this.lastSyncAttemptAt,
      lastSyncError: data.lastSyncError.present
          ? data.lastSyncError.value
          : this.lastSyncError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LinkedAccount(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('isStub: $isStub, ')
          ..write('calendarAccessGranted: $calendarAccessGranted, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncSuccessAt: $lastSyncSuccessAt, ')
          ..write('lastSyncAttemptAt: $lastSyncAttemptAt, ')
          ..write('lastSyncError: $lastSyncError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    displayName,
    photoUrl,
    isStub,
    calendarAccessGranted,
    connectedAt,
    lastSyncSuccessAt,
    lastSyncAttemptAt,
    lastSyncError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinkedAccount &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.photoUrl == this.photoUrl &&
          other.isStub == this.isStub &&
          other.calendarAccessGranted == this.calendarAccessGranted &&
          other.connectedAt == this.connectedAt &&
          other.lastSyncSuccessAt == this.lastSyncSuccessAt &&
          other.lastSyncAttemptAt == this.lastSyncAttemptAt &&
          other.lastSyncError == this.lastSyncError);
}

class LinkedAccountsCompanion extends UpdateCompanion<LinkedAccount> {
  final Value<String> id;
  final Value<String> email;
  final Value<String?> displayName;
  final Value<String?> photoUrl;
  final Value<bool> isStub;
  final Value<bool> calendarAccessGranted;
  final Value<DateTime> connectedAt;
  final Value<DateTime?> lastSyncSuccessAt;
  final Value<DateTime?> lastSyncAttemptAt;
  final Value<String?> lastSyncError;
  final Value<int> rowid;
  const LinkedAccountsCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.isStub = const Value.absent(),
    this.calendarAccessGranted = const Value.absent(),
    this.connectedAt = const Value.absent(),
    this.lastSyncSuccessAt = const Value.absent(),
    this.lastSyncAttemptAt = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LinkedAccountsCompanion.insert({
    required String id,
    required String email,
    this.displayName = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.isStub = const Value.absent(),
    this.calendarAccessGranted = const Value.absent(),
    this.connectedAt = const Value.absent(),
    this.lastSyncSuccessAt = const Value.absent(),
    this.lastSyncAttemptAt = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email);
  static Insertable<LinkedAccount> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? photoUrl,
    Expression<bool>? isStub,
    Expression<bool>? calendarAccessGranted,
    Expression<DateTime>? connectedAt,
    Expression<DateTime>? lastSyncSuccessAt,
    Expression<DateTime>? lastSyncAttemptAt,
    Expression<String>? lastSyncError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (isStub != null) 'is_stub': isStub,
      if (calendarAccessGranted != null)
        'calendar_access_granted': calendarAccessGranted,
      if (connectedAt != null) 'connected_at': connectedAt,
      if (lastSyncSuccessAt != null) 'last_sync_success_at': lastSyncSuccessAt,
      if (lastSyncAttemptAt != null) 'last_sync_attempt_at': lastSyncAttemptAt,
      if (lastSyncError != null) 'last_sync_error': lastSyncError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LinkedAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String?>? displayName,
    Value<String?>? photoUrl,
    Value<bool>? isStub,
    Value<bool>? calendarAccessGranted,
    Value<DateTime>? connectedAt,
    Value<DateTime?>? lastSyncSuccessAt,
    Value<DateTime?>? lastSyncAttemptAt,
    Value<String?>? lastSyncError,
    Value<int>? rowid,
  }) {
    return LinkedAccountsCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isStub: isStub ?? this.isStub,
      calendarAccessGranted:
          calendarAccessGranted ?? this.calendarAccessGranted,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSyncSuccessAt: lastSyncSuccessAt ?? this.lastSyncSuccessAt,
      lastSyncAttemptAt: lastSyncAttemptAt ?? this.lastSyncAttemptAt,
      lastSyncError: lastSyncError ?? this.lastSyncError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (isStub.present) {
      map['is_stub'] = Variable<bool>(isStub.value);
    }
    if (calendarAccessGranted.present) {
      map['calendar_access_granted'] = Variable<bool>(
        calendarAccessGranted.value,
      );
    }
    if (connectedAt.present) {
      map['connected_at'] = Variable<DateTime>(connectedAt.value);
    }
    if (lastSyncSuccessAt.present) {
      map['last_sync_success_at'] = Variable<DateTime>(lastSyncSuccessAt.value);
    }
    if (lastSyncAttemptAt.present) {
      map['last_sync_attempt_at'] = Variable<DateTime>(lastSyncAttemptAt.value);
    }
    if (lastSyncError.present) {
      map['last_sync_error'] = Variable<String>(lastSyncError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LinkedAccountsCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('isStub: $isStub, ')
          ..write('calendarAccessGranted: $calendarAccessGranted, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncSuccessAt: $lastSyncSuccessAt, ')
          ..write('lastSyncAttemptAt: $lastSyncAttemptAt, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalendarsTable extends Calendars
    with TableInfo<$CalendarsTable, SyncedCalendar> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES linked_accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _googleCalendarIdMeta = const VerificationMeta(
    'googleCalendarId',
  );
  @override
  late final GeneratedColumn<String> googleCalendarId = GeneratedColumn<String>(
    'google_calendar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accessRoleMeta = const VerificationMeta(
    'accessRole',
  );
  @override
  late final GeneratedColumn<String> accessRole = GeneratedColumn<String>(
    'access_role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSelectedMeta = const VerificationMeta(
    'isSelected',
  );
  @override
  late final GeneratedColumn<bool> isSelected = GeneratedColumn<bool>(
    'is_selected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_selected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isVisibleMeta = const VerificationMeta(
    'isVisible',
  );
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
    'is_visible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_visible" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncTokenMeta = const VerificationMeta(
    'syncToken',
  );
  @override
  late final GeneratedColumn<String> syncToken = GeneratedColumn<String>(
    'sync_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    googleCalendarId,
    name,
    color,
    accessRole,
    isPrimary,
    isSelected,
    isVisible,
    syncToken,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendars';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncedCalendar> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('google_calendar_id')) {
      context.handle(
        _googleCalendarIdMeta,
        googleCalendarId.isAcceptableOrUnknown(
          data['google_calendar_id']!,
          _googleCalendarIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_googleCalendarIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('access_role')) {
      context.handle(
        _accessRoleMeta,
        accessRole.isAcceptableOrUnknown(data['access_role']!, _accessRoleMeta),
      );
    } else if (isInserting) {
      context.missing(_accessRoleMeta);
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    if (data.containsKey('is_selected')) {
      context.handle(
        _isSelectedMeta,
        isSelected.isAcceptableOrUnknown(data['is_selected']!, _isSelectedMeta),
      );
    }
    if (data.containsKey('is_visible')) {
      context.handle(
        _isVisibleMeta,
        isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta),
      );
    }
    if (data.containsKey('sync_token')) {
      context.handle(
        _syncTokenMeta,
        syncToken.isAcceptableOrUnknown(data['sync_token']!, _syncTokenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {accountId, googleCalendarId},
  ];
  @override
  SyncedCalendar map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncedCalendar(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      googleCalendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_calendar_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      accessRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_role'],
      )!,
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
      isSelected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_selected'],
      )!,
      isVisible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_visible'],
      )!,
      syncToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_token'],
      ),
    );
  }

  @override
  $CalendarsTable createAlias(String alias) {
    return $CalendarsTable(attachedDatabase, alias);
  }
}

class SyncedCalendar extends DataClass implements Insertable<SyncedCalendar> {
  final int id;
  final String accountId;

  /// Google Calendar ID (e.g. `primary@gmail.com`).
  final String googleCalendarId;
  final String name;

  /// Google's background color for the calendar (ARGB).
  final int color;

  /// Google access role: owner, writer, reader or freeBusyReader.
  final String accessRole;
  final bool isPrimary;

  /// Chosen for sync by the user.
  final bool isSelected;

  /// Shown in calendar views (filters can hide a synced calendar).
  final bool isVisible;

  /// Incremental sync token from the Google Calendar API.
  final String? syncToken;
  const SyncedCalendar({
    required this.id,
    required this.accountId,
    required this.googleCalendarId,
    required this.name,
    required this.color,
    required this.accessRole,
    required this.isPrimary,
    required this.isSelected,
    required this.isVisible,
    this.syncToken,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<String>(accountId);
    map['google_calendar_id'] = Variable<String>(googleCalendarId);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['access_role'] = Variable<String>(accessRole);
    map['is_primary'] = Variable<bool>(isPrimary);
    map['is_selected'] = Variable<bool>(isSelected);
    map['is_visible'] = Variable<bool>(isVisible);
    if (!nullToAbsent || syncToken != null) {
      map['sync_token'] = Variable<String>(syncToken);
    }
    return map;
  }

  CalendarsCompanion toCompanion(bool nullToAbsent) {
    return CalendarsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      googleCalendarId: Value(googleCalendarId),
      name: Value(name),
      color: Value(color),
      accessRole: Value(accessRole),
      isPrimary: Value(isPrimary),
      isSelected: Value(isSelected),
      isVisible: Value(isVisible),
      syncToken: syncToken == null && nullToAbsent
          ? const Value.absent()
          : Value(syncToken),
    );
  }

  factory SyncedCalendar.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncedCalendar(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      googleCalendarId: serializer.fromJson<String>(json['googleCalendarId']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      accessRole: serializer.fromJson<String>(json['accessRole']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      isSelected: serializer.fromJson<bool>(json['isSelected']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
      syncToken: serializer.fromJson<String?>(json['syncToken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<String>(accountId),
      'googleCalendarId': serializer.toJson<String>(googleCalendarId),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'accessRole': serializer.toJson<String>(accessRole),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'isSelected': serializer.toJson<bool>(isSelected),
      'isVisible': serializer.toJson<bool>(isVisible),
      'syncToken': serializer.toJson<String?>(syncToken),
    };
  }

  SyncedCalendar copyWith({
    int? id,
    String? accountId,
    String? googleCalendarId,
    String? name,
    int? color,
    String? accessRole,
    bool? isPrimary,
    bool? isSelected,
    bool? isVisible,
    Value<String?> syncToken = const Value.absent(),
  }) => SyncedCalendar(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    googleCalendarId: googleCalendarId ?? this.googleCalendarId,
    name: name ?? this.name,
    color: color ?? this.color,
    accessRole: accessRole ?? this.accessRole,
    isPrimary: isPrimary ?? this.isPrimary,
    isSelected: isSelected ?? this.isSelected,
    isVisible: isVisible ?? this.isVisible,
    syncToken: syncToken.present ? syncToken.value : this.syncToken,
  );
  SyncedCalendar copyWithCompanion(CalendarsCompanion data) {
    return SyncedCalendar(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      googleCalendarId: data.googleCalendarId.present
          ? data.googleCalendarId.value
          : this.googleCalendarId,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      accessRole: data.accessRole.present
          ? data.accessRole.value
          : this.accessRole,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      isSelected: data.isSelected.present
          ? data.isSelected.value
          : this.isSelected,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
      syncToken: data.syncToken.present ? data.syncToken.value : this.syncToken,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncedCalendar(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('accessRole: $accessRole, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('isSelected: $isSelected, ')
          ..write('isVisible: $isVisible, ')
          ..write('syncToken: $syncToken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    googleCalendarId,
    name,
    color,
    accessRole,
    isPrimary,
    isSelected,
    isVisible,
    syncToken,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncedCalendar &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.googleCalendarId == this.googleCalendarId &&
          other.name == this.name &&
          other.color == this.color &&
          other.accessRole == this.accessRole &&
          other.isPrimary == this.isPrimary &&
          other.isSelected == this.isSelected &&
          other.isVisible == this.isVisible &&
          other.syncToken == this.syncToken);
}

class CalendarsCompanion extends UpdateCompanion<SyncedCalendar> {
  final Value<int> id;
  final Value<String> accountId;
  final Value<String> googleCalendarId;
  final Value<String> name;
  final Value<int> color;
  final Value<String> accessRole;
  final Value<bool> isPrimary;
  final Value<bool> isSelected;
  final Value<bool> isVisible;
  final Value<String?> syncToken;
  const CalendarsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.googleCalendarId = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.accessRole = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.isSelected = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.syncToken = const Value.absent(),
  });
  CalendarsCompanion.insert({
    this.id = const Value.absent(),
    required String accountId,
    required String googleCalendarId,
    required String name,
    required int color,
    required String accessRole,
    this.isPrimary = const Value.absent(),
    this.isSelected = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.syncToken = const Value.absent(),
  }) : accountId = Value(accountId),
       googleCalendarId = Value(googleCalendarId),
       name = Value(name),
       color = Value(color),
       accessRole = Value(accessRole);
  static Insertable<SyncedCalendar> custom({
    Expression<int>? id,
    Expression<String>? accountId,
    Expression<String>? googleCalendarId,
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? accessRole,
    Expression<bool>? isPrimary,
    Expression<bool>? isSelected,
    Expression<bool>? isVisible,
    Expression<String>? syncToken,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (googleCalendarId != null) 'google_calendar_id': googleCalendarId,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (accessRole != null) 'access_role': accessRole,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (isSelected != null) 'is_selected': isSelected,
      if (isVisible != null) 'is_visible': isVisible,
      if (syncToken != null) 'sync_token': syncToken,
    });
  }

  CalendarsCompanion copyWith({
    Value<int>? id,
    Value<String>? accountId,
    Value<String>? googleCalendarId,
    Value<String>? name,
    Value<int>? color,
    Value<String>? accessRole,
    Value<bool>? isPrimary,
    Value<bool>? isSelected,
    Value<bool>? isVisible,
    Value<String?>? syncToken,
  }) {
    return CalendarsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      googleCalendarId: googleCalendarId ?? this.googleCalendarId,
      name: name ?? this.name,
      color: color ?? this.color,
      accessRole: accessRole ?? this.accessRole,
      isPrimary: isPrimary ?? this.isPrimary,
      isSelected: isSelected ?? this.isSelected,
      isVisible: isVisible ?? this.isVisible,
      syncToken: syncToken ?? this.syncToken,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (googleCalendarId.present) {
      map['google_calendar_id'] = Variable<String>(googleCalendarId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (accessRole.present) {
      map['access_role'] = Variable<String>(accessRole.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (isSelected.present) {
      map['is_selected'] = Variable<bool>(isSelected.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    if (syncToken.present) {
      map['sync_token'] = Variable<String>(syncToken.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('accessRole: $accessRole, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('isSelected: $isSelected, ')
          ..write('isVisible: $isVisible, ')
          ..write('syncToken: $syncToken')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, CalendarEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _calendarIdMeta = const VerificationMeta(
    'calendarId',
  );
  @override
  late final GeneratedColumn<int> calendarId = GeneratedColumn<int>(
    'calendar_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calendars (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _googleEventIdMeta = const VerificationMeta(
    'googleEventId',
  );
  @override
  late final GeneratedColumn<String> googleEventId = GeneratedColumn<String>(
    'google_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endsAtMeta = const VerificationMeta('endsAt');
  @override
  late final GeneratedColumn<DateTime> endsAt = GeneratedColumn<DateTime>(
    'ends_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAllDayMeta = const VerificationMeta(
    'isAllDay',
  );
  @override
  late final GeneratedColumn<bool> isAllDay = GeneratedColumn<bool>(
    'is_all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('default'),
  );
  static const VerificationMeta _reminderMinutesMeta = const VerificationMeta(
    'reminderMinutes',
  );
  @override
  late final GeneratedColumn<int> reminderMinutes = GeneratedColumn<int>(
    'reminder_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderNotifiedAtMeta =
      const VerificationMeta('reminderNotifiedAt');
  @override
  late final GeneratedColumn<DateTime> reminderNotifiedAt =
      GeneratedColumn<DateTime>(
        'reminder_notified_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    calendarId,
    googleEventId,
    title,
    description,
    location,
    startsAt,
    endsAt,
    isAllDay,
    eventType,
    reminderMinutes,
    reminderNotifiedAt,
    categoryId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('calendar_id')) {
      context.handle(
        _calendarIdMeta,
        calendarId.isAcceptableOrUnknown(data['calendar_id']!, _calendarIdMeta),
      );
    }
    if (data.containsKey('google_event_id')) {
      context.handle(
        _googleEventIdMeta,
        googleEventId.isAcceptableOrUnknown(
          data['google_event_id']!,
          _googleEventIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('ends_at')) {
      context.handle(
        _endsAtMeta,
        endsAt.isAcceptableOrUnknown(data['ends_at']!, _endsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endsAtMeta);
    }
    if (data.containsKey('is_all_day')) {
      context.handle(
        _isAllDayMeta,
        isAllDay.isAcceptableOrUnknown(data['is_all_day']!, _isAllDayMeta),
      );
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    }
    if (data.containsKey('reminder_minutes')) {
      context.handle(
        _reminderMinutesMeta,
        reminderMinutes.isAcceptableOrUnknown(
          data['reminder_minutes']!,
          _reminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('reminder_notified_at')) {
      context.handle(
        _reminderNotifiedAtMeta,
        reminderNotifiedAt.isAcceptableOrUnknown(
          data['reminder_notified_at']!,
          _reminderNotifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {calendarId, googleEventId},
  ];
  @override
  CalendarEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      calendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calendar_id'],
      ),
      googleEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_event_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
      endsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ends_at'],
      )!,
      isAllDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_all_day'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      reminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes'],
      ),
      reminderNotifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_notified_at'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class CalendarEvent extends DataClass implements Insertable<CalendarEvent> {
  final int id;

  /// Null for local-only events.
  final int? calendarId;

  /// Google event ID; together with [calendarId] (which belongs to one
  /// account) this identifies a synced event.
  final String? googleEventId;
  final String title;
  final String? description;
  final String? location;
  final DateTime startsAt;
  final DateTime endsAt;

  /// All-day events have no meaningful time; never render artificial times.
  final bool isAllDay;

  /// Google's event type (`default`, `birthday`, `focusTime`, ...). Birthdays
  /// are recognized from this, not from the calendar's name.
  final String eventType;

  /// Remind this many minutes before [startsAt]; null for no reminder.
  final int? reminderMinutes;

  /// When the in-app reminder was shown, so it only fires once.
  final DateTime? reminderNotifiedAt;
  final int? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CalendarEvent({
    required this.id,
    this.calendarId,
    this.googleEventId,
    required this.title,
    this.description,
    this.location,
    required this.startsAt,
    required this.endsAt,
    required this.isAllDay,
    required this.eventType,
    this.reminderMinutes,
    this.reminderNotifiedAt,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || calendarId != null) {
      map['calendar_id'] = Variable<int>(calendarId);
    }
    if (!nullToAbsent || googleEventId != null) {
      map['google_event_id'] = Variable<String>(googleEventId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['starts_at'] = Variable<DateTime>(startsAt);
    map['ends_at'] = Variable<DateTime>(endsAt);
    map['is_all_day'] = Variable<bool>(isAllDay);
    map['event_type'] = Variable<String>(eventType);
    if (!nullToAbsent || reminderMinutes != null) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes);
    }
    if (!nullToAbsent || reminderNotifiedAt != null) {
      map['reminder_notified_at'] = Variable<DateTime>(reminderNotifiedAt);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      calendarId: calendarId == null && nullToAbsent
          ? const Value.absent()
          : Value(calendarId),
      googleEventId: googleEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(googleEventId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      startsAt: Value(startsAt),
      endsAt: Value(endsAt),
      isAllDay: Value(isAllDay),
      eventType: Value(eventType),
      reminderMinutes: reminderMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderMinutes),
      reminderNotifiedAt: reminderNotifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderNotifiedAt),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CalendarEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarEvent(
      id: serializer.fromJson<int>(json['id']),
      calendarId: serializer.fromJson<int?>(json['calendarId']),
      googleEventId: serializer.fromJson<String?>(json['googleEventId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      location: serializer.fromJson<String?>(json['location']),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
      endsAt: serializer.fromJson<DateTime>(json['endsAt']),
      isAllDay: serializer.fromJson<bool>(json['isAllDay']),
      eventType: serializer.fromJson<String>(json['eventType']),
      reminderMinutes: serializer.fromJson<int?>(json['reminderMinutes']),
      reminderNotifiedAt: serializer.fromJson<DateTime?>(
        json['reminderNotifiedAt'],
      ),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'calendarId': serializer.toJson<int?>(calendarId),
      'googleEventId': serializer.toJson<String?>(googleEventId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'location': serializer.toJson<String?>(location),
      'startsAt': serializer.toJson<DateTime>(startsAt),
      'endsAt': serializer.toJson<DateTime>(endsAt),
      'isAllDay': serializer.toJson<bool>(isAllDay),
      'eventType': serializer.toJson<String>(eventType),
      'reminderMinutes': serializer.toJson<int?>(reminderMinutes),
      'reminderNotifiedAt': serializer.toJson<DateTime?>(reminderNotifiedAt),
      'categoryId': serializer.toJson<int?>(categoryId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CalendarEvent copyWith({
    int? id,
    Value<int?> calendarId = const Value.absent(),
    Value<String?> googleEventId = const Value.absent(),
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> location = const Value.absent(),
    DateTime? startsAt,
    DateTime? endsAt,
    bool? isAllDay,
    String? eventType,
    Value<int?> reminderMinutes = const Value.absent(),
    Value<DateTime?> reminderNotifiedAt = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CalendarEvent(
    id: id ?? this.id,
    calendarId: calendarId.present ? calendarId.value : this.calendarId,
    googleEventId: googleEventId.present
        ? googleEventId.value
        : this.googleEventId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    location: location.present ? location.value : this.location,
    startsAt: startsAt ?? this.startsAt,
    endsAt: endsAt ?? this.endsAt,
    isAllDay: isAllDay ?? this.isAllDay,
    eventType: eventType ?? this.eventType,
    reminderMinutes: reminderMinutes.present
        ? reminderMinutes.value
        : this.reminderMinutes,
    reminderNotifiedAt: reminderNotifiedAt.present
        ? reminderNotifiedAt.value
        : this.reminderNotifiedAt,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CalendarEvent copyWithCompanion(EventsCompanion data) {
    return CalendarEvent(
      id: data.id.present ? data.id.value : this.id,
      calendarId: data.calendarId.present
          ? data.calendarId.value
          : this.calendarId,
      googleEventId: data.googleEventId.present
          ? data.googleEventId.value
          : this.googleEventId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      location: data.location.present ? data.location.value : this.location,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      endsAt: data.endsAt.present ? data.endsAt.value : this.endsAt,
      isAllDay: data.isAllDay.present ? data.isAllDay.value : this.isAllDay,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      reminderMinutes: data.reminderMinutes.present
          ? data.reminderMinutes.value
          : this.reminderMinutes,
      reminderNotifiedAt: data.reminderNotifiedAt.present
          ? data.reminderNotifiedAt.value
          : this.reminderNotifiedAt,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEvent(')
          ..write('id: $id, ')
          ..write('calendarId: $calendarId, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('eventType: $eventType, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('reminderNotifiedAt: $reminderNotifiedAt, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    calendarId,
    googleEventId,
    title,
    description,
    location,
    startsAt,
    endsAt,
    isAllDay,
    eventType,
    reminderMinutes,
    reminderNotifiedAt,
    categoryId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarEvent &&
          other.id == this.id &&
          other.calendarId == this.calendarId &&
          other.googleEventId == this.googleEventId &&
          other.title == this.title &&
          other.description == this.description &&
          other.location == this.location &&
          other.startsAt == this.startsAt &&
          other.endsAt == this.endsAt &&
          other.isAllDay == this.isAllDay &&
          other.eventType == this.eventType &&
          other.reminderMinutes == this.reminderMinutes &&
          other.reminderNotifiedAt == this.reminderNotifiedAt &&
          other.categoryId == this.categoryId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EventsCompanion extends UpdateCompanion<CalendarEvent> {
  final Value<int> id;
  final Value<int?> calendarId;
  final Value<String?> googleEventId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> location;
  final Value<DateTime> startsAt;
  final Value<DateTime> endsAt;
  final Value<bool> isAllDay;
  final Value<String> eventType;
  final Value<int?> reminderMinutes;
  final Value<DateTime?> reminderNotifiedAt;
  final Value<int?> categoryId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.calendarId = const Value.absent(),
    this.googleEventId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.eventType = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.reminderNotifiedAt = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    this.calendarId = const Value.absent(),
    this.googleEventId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    required DateTime startsAt,
    required DateTime endsAt,
    this.isAllDay = const Value.absent(),
    this.eventType = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.reminderNotifiedAt = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title),
       startsAt = Value(startsAt),
       endsAt = Value(endsAt);
  static Insertable<CalendarEvent> custom({
    Expression<int>? id,
    Expression<int>? calendarId,
    Expression<String>? googleEventId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? location,
    Expression<DateTime>? startsAt,
    Expression<DateTime>? endsAt,
    Expression<bool>? isAllDay,
    Expression<String>? eventType,
    Expression<int>? reminderMinutes,
    Expression<DateTime>? reminderNotifiedAt,
    Expression<int>? categoryId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calendarId != null) 'calendar_id': calendarId,
      if (googleEventId != null) 'google_event_id': googleEventId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (isAllDay != null) 'is_all_day': isAllDay,
      if (eventType != null) 'event_type': eventType,
      if (reminderMinutes != null) 'reminder_minutes': reminderMinutes,
      if (reminderNotifiedAt != null)
        'reminder_notified_at': reminderNotifiedAt,
      if (categoryId != null) 'category_id': categoryId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EventsCompanion copyWith({
    Value<int>? id,
    Value<int?>? calendarId,
    Value<String?>? googleEventId,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? location,
    Value<DateTime>? startsAt,
    Value<DateTime>? endsAt,
    Value<bool>? isAllDay,
    Value<String>? eventType,
    Value<int?>? reminderMinutes,
    Value<DateTime?>? reminderNotifiedAt,
    Value<int?>? categoryId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      calendarId: calendarId ?? this.calendarId,
      googleEventId: googleEventId ?? this.googleEventId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      isAllDay: isAllDay ?? this.isAllDay,
      eventType: eventType ?? this.eventType,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      reminderNotifiedAt: reminderNotifiedAt ?? this.reminderNotifiedAt,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (calendarId.present) {
      map['calendar_id'] = Variable<int>(calendarId.value);
    }
    if (googleEventId.present) {
      map['google_event_id'] = Variable<String>(googleEventId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (endsAt.present) {
      map['ends_at'] = Variable<DateTime>(endsAt.value);
    }
    if (isAllDay.present) {
      map['is_all_day'] = Variable<bool>(isAllDay.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (reminderMinutes.present) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes.value);
    }
    if (reminderNotifiedAt.present) {
      map['reminder_notified_at'] = Variable<DateTime>(
        reminderNotifiedAt.value,
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('calendarId: $calendarId, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('eventType: $eventType, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('reminderNotifiedAt: $reminderNotifiedAt, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $LinkedAccountsTable linkedAccounts = $LinkedAccountsTable(this);
  late final $CalendarsTable calendars = $CalendarsTable(this);
  late final $EventsTable events = $EventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    appSettings,
    linkedAccounts,
    calendars,
    events,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'linked_accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('calendars', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'calendars',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('events', kind: UpdateKind.update)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String?> slug,
      required String name,
      required String iconKey,
      required int color,
      Value<bool> isBuiltIn,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String?> slug,
      Value<String> name,
      Value<String> iconKey,
      Value<int> color,
      Value<bool> isBuiltIn,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, EventCategory> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EventsTable, List<CalendarEvent>>
  _eventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'categories__id__events__category_id',
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          EventCategory,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (EventCategory, $$CategoriesTableReferences),
          EventCategory,
          PrefetchHooks Function({bool eventsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> slug = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                slug: slug,
                name: name,
                iconKey: iconKey,
                color: color,
                isBuiltIn: isBuiltIn,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> slug = const Value.absent(),
                required String name,
                required String iconKey,
                required int color,
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                slug: slug,
                name: name,
                iconKey: iconKey,
                color: color,
                isBuiltIn: isBuiltIn,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (eventsRefs) db.events],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventsRefs)
                    await $_getPrefetchedData<
                      EventCategory,
                      $CategoriesTable,
                      CalendarEvent
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._eventsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(db, table, p0).eventsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      EventCategory,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (EventCategory, $$CategoriesTableReferences),
      EventCategory,
      PrefetchHooks Function({bool eventsRefs})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$LinkedAccountsTableCreateCompanionBuilder =
    LinkedAccountsCompanion Function({
      required String id,
      required String email,
      Value<String?> displayName,
      Value<String?> photoUrl,
      Value<bool> isStub,
      Value<bool> calendarAccessGranted,
      Value<DateTime> connectedAt,
      Value<DateTime?> lastSyncSuccessAt,
      Value<DateTime?> lastSyncAttemptAt,
      Value<String?> lastSyncError,
      Value<int> rowid,
    });
typedef $$LinkedAccountsTableUpdateCompanionBuilder =
    LinkedAccountsCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String?> displayName,
      Value<String?> photoUrl,
      Value<bool> isStub,
      Value<bool> calendarAccessGranted,
      Value<DateTime> connectedAt,
      Value<DateTime?> lastSyncSuccessAt,
      Value<DateTime?> lastSyncAttemptAt,
      Value<String?> lastSyncError,
      Value<int> rowid,
    });

final class $$LinkedAccountsTableReferences
    extends BaseReferences<_$AppDatabase, $LinkedAccountsTable, LinkedAccount> {
  $$LinkedAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CalendarsTable, List<SyncedCalendar>>
  _calendarsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.calendars,
    aliasName: 'linked_accounts__id__calendars__account_id',
  );

  $$CalendarsTableProcessedTableManager get calendarsRefs {
    final manager = $$CalendarsTableTableManager(
      $_db,
      $_db.calendars,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_calendarsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LinkedAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $LinkedAccountsTable> {
  $$LinkedAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStub => $composableBuilder(
    column: $table.isStub,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get calendarAccessGranted => $composableBuilder(
    column: $table.calendarAccessGranted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncSuccessAt => $composableBuilder(
    column: $table.lastSyncSuccessAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAttemptAt => $composableBuilder(
    column: $table.lastSyncAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> calendarsRefs(
    Expression<bool> Function($$CalendarsTableFilterComposer f) f,
  ) {
    final $$CalendarsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.calendars,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarsTableFilterComposer(
            $db: $db,
            $table: $db.calendars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LinkedAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $LinkedAccountsTable> {
  $$LinkedAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStub => $composableBuilder(
    column: $table.isStub,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get calendarAccessGranted => $composableBuilder(
    column: $table.calendarAccessGranted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncSuccessAt => $composableBuilder(
    column: $table.lastSyncSuccessAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAttemptAt => $composableBuilder(
    column: $table.lastSyncAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LinkedAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LinkedAccountsTable> {
  $$LinkedAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<bool> get isStub =>
      $composableBuilder(column: $table.isStub, builder: (column) => column);

  GeneratedColumn<bool> get calendarAccessGranted => $composableBuilder(
    column: $table.calendarAccessGranted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncSuccessAt => $composableBuilder(
    column: $table.lastSyncSuccessAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAttemptAt => $composableBuilder(
    column: $table.lastSyncAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncError => $composableBuilder(
    column: $table.lastSyncError,
    builder: (column) => column,
  );

  Expression<T> calendarsRefs<T extends Object>(
    Expression<T> Function($$CalendarsTableAnnotationComposer a) f,
  ) {
    final $$CalendarsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.calendars,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarsTableAnnotationComposer(
            $db: $db,
            $table: $db.calendars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LinkedAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LinkedAccountsTable,
          LinkedAccount,
          $$LinkedAccountsTableFilterComposer,
          $$LinkedAccountsTableOrderingComposer,
          $$LinkedAccountsTableAnnotationComposer,
          $$LinkedAccountsTableCreateCompanionBuilder,
          $$LinkedAccountsTableUpdateCompanionBuilder,
          (LinkedAccount, $$LinkedAccountsTableReferences),
          LinkedAccount,
          PrefetchHooks Function({bool calendarsRefs})
        > {
  $$LinkedAccountsTableTableManager(
    _$AppDatabase db,
    $LinkedAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LinkedAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LinkedAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LinkedAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<bool> isStub = const Value.absent(),
                Value<bool> calendarAccessGranted = const Value.absent(),
                Value<DateTime> connectedAt = const Value.absent(),
                Value<DateTime?> lastSyncSuccessAt = const Value.absent(),
                Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LinkedAccountsCompanion(
                id: id,
                email: email,
                displayName: displayName,
                photoUrl: photoUrl,
                isStub: isStub,
                calendarAccessGranted: calendarAccessGranted,
                connectedAt: connectedAt,
                lastSyncSuccessAt: lastSyncSuccessAt,
                lastSyncAttemptAt: lastSyncAttemptAt,
                lastSyncError: lastSyncError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                Value<String?> displayName = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<bool> isStub = const Value.absent(),
                Value<bool> calendarAccessGranted = const Value.absent(),
                Value<DateTime> connectedAt = const Value.absent(),
                Value<DateTime?> lastSyncSuccessAt = const Value.absent(),
                Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
                Value<String?> lastSyncError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LinkedAccountsCompanion.insert(
                id: id,
                email: email,
                displayName: displayName,
                photoUrl: photoUrl,
                isStub: isStub,
                calendarAccessGranted: calendarAccessGranted,
                connectedAt: connectedAt,
                lastSyncSuccessAt: lastSyncSuccessAt,
                lastSyncAttemptAt: lastSyncAttemptAt,
                lastSyncError: lastSyncError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LinkedAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({calendarsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (calendarsRefs) db.calendars],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (calendarsRefs)
                    await $_getPrefetchedData<
                      LinkedAccount,
                      $LinkedAccountsTable,
                      SyncedCalendar
                    >(
                      currentTable: table,
                      referencedTable: $$LinkedAccountsTableReferences
                          ._calendarsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LinkedAccountsTableReferences(
                            db,
                            table,
                            p0,
                          ).calendarsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.accountId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LinkedAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LinkedAccountsTable,
      LinkedAccount,
      $$LinkedAccountsTableFilterComposer,
      $$LinkedAccountsTableOrderingComposer,
      $$LinkedAccountsTableAnnotationComposer,
      $$LinkedAccountsTableCreateCompanionBuilder,
      $$LinkedAccountsTableUpdateCompanionBuilder,
      (LinkedAccount, $$LinkedAccountsTableReferences),
      LinkedAccount,
      PrefetchHooks Function({bool calendarsRefs})
    >;
typedef $$CalendarsTableCreateCompanionBuilder =
    CalendarsCompanion Function({
      Value<int> id,
      required String accountId,
      required String googleCalendarId,
      required String name,
      required int color,
      required String accessRole,
      Value<bool> isPrimary,
      Value<bool> isSelected,
      Value<bool> isVisible,
      Value<String?> syncToken,
    });
typedef $$CalendarsTableUpdateCompanionBuilder =
    CalendarsCompanion Function({
      Value<int> id,
      Value<String> accountId,
      Value<String> googleCalendarId,
      Value<String> name,
      Value<int> color,
      Value<String> accessRole,
      Value<bool> isPrimary,
      Value<bool> isSelected,
      Value<bool> isVisible,
      Value<String?> syncToken,
    });

final class $$CalendarsTableReferences
    extends BaseReferences<_$AppDatabase, $CalendarsTable, SyncedCalendar> {
  $$CalendarsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LinkedAccountsTable _accountIdTable(_$AppDatabase db) => db
      .linkedAccounts
      .createAlias('calendars__account_id__linked_accounts__id');

  $$LinkedAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$LinkedAccountsTableTableManager(
      $_db,
      $_db.linkedAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EventsTable, List<CalendarEvent>>
  _eventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'calendars__id__events__calendar_id',
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.calendarId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CalendarsTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarsTable> {
  $$CalendarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessRole => $composableBuilder(
    column: $table.accessRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncToken => $composableBuilder(
    column: $table.syncToken,
    builder: (column) => ColumnFilters(column),
  );

  $$LinkedAccountsTableFilterComposer get accountId {
    final $$LinkedAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.linkedAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LinkedAccountsTableFilterComposer(
            $db: $db,
            $table: $db.linkedAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.calendarId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalendarsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarsTable> {
  $$CalendarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessRole => $composableBuilder(
    column: $table.accessRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncToken => $composableBuilder(
    column: $table.syncToken,
    builder: (column) => ColumnOrderings(column),
  );

  $$LinkedAccountsTableOrderingComposer get accountId {
    final $$LinkedAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.linkedAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LinkedAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.linkedAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarsTable> {
  $$CalendarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get accessRole => $composableBuilder(
    column: $table.accessRole,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVisible =>
      $composableBuilder(column: $table.isVisible, builder: (column) => column);

  GeneratedColumn<String> get syncToken =>
      $composableBuilder(column: $table.syncToken, builder: (column) => column);

  $$LinkedAccountsTableAnnotationComposer get accountId {
    final $$LinkedAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.linkedAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LinkedAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.linkedAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.calendarId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalendarsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarsTable,
          SyncedCalendar,
          $$CalendarsTableFilterComposer,
          $$CalendarsTableOrderingComposer,
          $$CalendarsTableAnnotationComposer,
          $$CalendarsTableCreateCompanionBuilder,
          $$CalendarsTableUpdateCompanionBuilder,
          (SyncedCalendar, $$CalendarsTableReferences),
          SyncedCalendar,
          PrefetchHooks Function({bool accountId, bool eventsRefs})
        > {
  $$CalendarsTableTableManager(_$AppDatabase db, $CalendarsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> googleCalendarId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> accessRole = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<bool> isSelected = const Value.absent(),
                Value<bool> isVisible = const Value.absent(),
                Value<String?> syncToken = const Value.absent(),
              }) => CalendarsCompanion(
                id: id,
                accountId: accountId,
                googleCalendarId: googleCalendarId,
                name: name,
                color: color,
                accessRole: accessRole,
                isPrimary: isPrimary,
                isSelected: isSelected,
                isVisible: isVisible,
                syncToken: syncToken,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String accountId,
                required String googleCalendarId,
                required String name,
                required int color,
                required String accessRole,
                Value<bool> isPrimary = const Value.absent(),
                Value<bool> isSelected = const Value.absent(),
                Value<bool> isVisible = const Value.absent(),
                Value<String?> syncToken = const Value.absent(),
              }) => CalendarsCompanion.insert(
                id: id,
                accountId: accountId,
                googleCalendarId: googleCalendarId,
                name: name,
                color: color,
                accessRole: accessRole,
                isPrimary: isPrimary,
                isSelected: isSelected,
                isVisible: isVisible,
                syncToken: syncToken,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CalendarsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false, eventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (eventsRefs) db.events],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$CalendarsTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$CalendarsTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventsRefs)
                    await $_getPrefetchedData<
                      SyncedCalendar,
                      $CalendarsTable,
                      CalendarEvent
                    >(
                      currentTable: table,
                      referencedTable: $$CalendarsTableReferences
                          ._eventsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CalendarsTableReferences(db, table, p0).eventsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.calendarId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CalendarsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarsTable,
      SyncedCalendar,
      $$CalendarsTableFilterComposer,
      $$CalendarsTableOrderingComposer,
      $$CalendarsTableAnnotationComposer,
      $$CalendarsTableCreateCompanionBuilder,
      $$CalendarsTableUpdateCompanionBuilder,
      (SyncedCalendar, $$CalendarsTableReferences),
      SyncedCalendar,
      PrefetchHooks Function({bool accountId, bool eventsRefs})
    >;
typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      Value<int> id,
      Value<int?> calendarId,
      Value<String?> googleEventId,
      required String title,
      Value<String?> description,
      Value<String?> location,
      required DateTime startsAt,
      required DateTime endsAt,
      Value<bool> isAllDay,
      Value<String> eventType,
      Value<int?> reminderMinutes,
      Value<DateTime?> reminderNotifiedAt,
      Value<int?> categoryId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<int> id,
      Value<int?> calendarId,
      Value<String?> googleEventId,
      Value<String> title,
      Value<String?> description,
      Value<String?> location,
      Value<DateTime> startsAt,
      Value<DateTime> endsAt,
      Value<bool> isAllDay,
      Value<String> eventType,
      Value<int?> reminderMinutes,
      Value<DateTime?> reminderNotifiedAt,
      Value<int?> categoryId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, CalendarEvent> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CalendarsTable _calendarIdTable(_$AppDatabase db) =>
      db.calendars.createAlias('events__calendar_id__calendars__id');

  $$CalendarsTableProcessedTableManager? get calendarId {
    final $_column = $_itemColumn<int>('calendar_id');
    if ($_column == null) return null;
    final manager = $$CalendarsTableTableManager(
      $_db,
      $_db.calendars,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_calendarIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('events__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderNotifiedAt => $composableBuilder(
    column: $table.reminderNotifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CalendarsTableFilterComposer get calendarId {
    final $$CalendarsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calendarId,
      referencedTable: $db.calendars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarsTableFilterComposer(
            $db: $db,
            $table: $db.calendars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderNotifiedAt => $composableBuilder(
    column: $table.reminderNotifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CalendarsTableOrderingComposer get calendarId {
    final $$CalendarsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calendarId,
      referencedTable: $db.calendars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarsTableOrderingComposer(
            $db: $db,
            $table: $db.calendars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endsAt =>
      $composableBuilder(column: $table.endsAt, builder: (column) => column);

  GeneratedColumn<bool> get isAllDay =>
      $composableBuilder(column: $table.isAllDay, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reminderNotifiedAt => $composableBuilder(
    column: $table.reminderNotifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CalendarsTableAnnotationComposer get calendarId {
    final $$CalendarsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calendarId,
      referencedTable: $db.calendars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarsTableAnnotationComposer(
            $db: $db,
            $table: $db.calendars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          CalendarEvent,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (CalendarEvent, $$EventsTableReferences),
          CalendarEvent,
          PrefetchHooks Function({bool calendarId, bool categoryId})
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> calendarId = const Value.absent(),
                Value<String?> googleEventId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<DateTime> endsAt = const Value.absent(),
                Value<bool> isAllDay = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<int?> reminderMinutes = const Value.absent(),
                Value<DateTime?> reminderNotifiedAt = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                calendarId: calendarId,
                googleEventId: googleEventId,
                title: title,
                description: description,
                location: location,
                startsAt: startsAt,
                endsAt: endsAt,
                isAllDay: isAllDay,
                eventType: eventType,
                reminderMinutes: reminderMinutes,
                reminderNotifiedAt: reminderNotifiedAt,
                categoryId: categoryId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> calendarId = const Value.absent(),
                Value<String?> googleEventId = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> location = const Value.absent(),
                required DateTime startsAt,
                required DateTime endsAt,
                Value<bool> isAllDay = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<int?> reminderMinutes = const Value.absent(),
                Value<DateTime?> reminderNotifiedAt = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                calendarId: calendarId,
                googleEventId: googleEventId,
                title: title,
                description: description,
                location: location,
                startsAt: startsAt,
                endsAt: endsAt,
                isAllDay: isAllDay,
                eventType: eventType,
                reminderMinutes: reminderMinutes,
                reminderNotifiedAt: reminderNotifiedAt,
                categoryId: categoryId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$EventsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({calendarId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (calendarId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.calendarId,
                                referencedTable: $$EventsTableReferences
                                    ._calendarIdTable(db),
                                referencedColumn: $$EventsTableReferences
                                    ._calendarIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$EventsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$EventsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      CalendarEvent,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (CalendarEvent, $$EventsTableReferences),
      CalendarEvent,
      PrefetchHooks Function({bool calendarId, bool categoryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$LinkedAccountsTableTableManager get linkedAccounts =>
      $$LinkedAccountsTableTableManager(_db, _db.linkedAccounts);
  $$CalendarsTableTableManager get calendars =>
      $$CalendarsTableTableManager(_db, _db.calendars);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
}
