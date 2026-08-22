// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ImportBatchesTable extends ImportBatches
    with TableInfo<$ImportBatchesTable, ImportBatch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportBatchesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<int> importedAt = GeneratedColumn<int>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceKindMeta = const VerificationMeta(
    'sourceKind',
  );
  @override
  late final GeneratedColumn<String> sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceFilePathMeta = const VerificationMeta(
    'sourceFilePath',
  );
  @override
  late final GeneratedColumn<String> sourceFilePath = GeneratedColumn<String>(
    'source_file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceFormatDetectedMeta =
      const VerificationMeta('sourceFormatDetected');
  @override
  late final GeneratedColumn<String> sourceFormatDetected =
      GeneratedColumn<String>(
        'source_format_detected',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _periodStartMeta = const VerificationMeta(
    'periodStart',
  );
  @override
  late final GeneratedColumn<int> periodStart = GeneratedColumn<int>(
    'period_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _periodEndMeta = const VerificationMeta(
    'periodEnd',
  );
  @override
  late final GeneratedColumn<int> periodEnd = GeneratedColumn<int>(
    'period_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pointCountMeta = const VerificationMeta(
    'pointCount',
  );
  @override
  late final GeneratedColumn<int> pointCount = GeneratedColumn<int>(
    'point_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    importedAt,
    sourceKind,
    sourceFilePath,
    sourceFormatDetected,
    periodStart,
    periodEnd,
    pointCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportBatch> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('source_kind')) {
      context.handle(
        _sourceKindMeta,
        sourceKind.isAcceptableOrUnknown(data['source_kind']!, _sourceKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKindMeta);
    }
    if (data.containsKey('source_file_path')) {
      context.handle(
        _sourceFilePathMeta,
        sourceFilePath.isAcceptableOrUnknown(
          data['source_file_path']!,
          _sourceFilePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceFilePathMeta);
    }
    if (data.containsKey('source_format_detected')) {
      context.handle(
        _sourceFormatDetectedMeta,
        sourceFormatDetected.isAcceptableOrUnknown(
          data['source_format_detected']!,
          _sourceFormatDetectedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceFormatDetectedMeta);
    }
    if (data.containsKey('period_start')) {
      context.handle(
        _periodStartMeta,
        periodStart.isAcceptableOrUnknown(
          data['period_start']!,
          _periodStartMeta,
        ),
      );
    }
    if (data.containsKey('period_end')) {
      context.handle(
        _periodEndMeta,
        periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta),
      );
    }
    if (data.containsKey('point_count')) {
      context.handle(
        _pointCountMeta,
        pointCount.isAcceptableOrUnknown(data['point_count']!, _pointCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportBatch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportBatch(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imported_at'],
      )!,
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
      sourceFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_file_path'],
      )!,
      sourceFormatDetected: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_format_detected'],
      )!,
      periodStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_start'],
      ),
      periodEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_end'],
      ),
      pointCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}point_count'],
      )!,
    );
  }

  @override
  $ImportBatchesTable createAlias(String alias) {
    return $ImportBatchesTable(attachedDatabase, alias);
  }
}

class ImportBatch extends DataClass implements Insertable<ImportBatch> {
  /// Identifiant.
  final int id;

  /// Instant de l'import, en millisecondes UTC.
  final int importedAt;

  /// Origine des données (`google_timeline`, plus tard `gpx`…).
  final String sourceKind;

  /// Chemin du fichier source conservé (§3.2).
  final String sourceFilePath;

  /// Format concret détecté à l'analyse.
  final String sourceFormatDetected;

  /// Début de la période couverte, en millisecondes UTC.
  final int? periodStart;

  /// Fin de la période couverte, en millisecondes UTC.
  final int? periodEnd;

  /// Nombre de positions brutes importées.
  final int pointCount;
  const ImportBatch({
    required this.id,
    required this.importedAt,
    required this.sourceKind,
    required this.sourceFilePath,
    required this.sourceFormatDetected,
    this.periodStart,
    this.periodEnd,
    required this.pointCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['imported_at'] = Variable<int>(importedAt);
    map['source_kind'] = Variable<String>(sourceKind);
    map['source_file_path'] = Variable<String>(sourceFilePath);
    map['source_format_detected'] = Variable<String>(sourceFormatDetected);
    if (!nullToAbsent || periodStart != null) {
      map['period_start'] = Variable<int>(periodStart);
    }
    if (!nullToAbsent || periodEnd != null) {
      map['period_end'] = Variable<int>(periodEnd);
    }
    map['point_count'] = Variable<int>(pointCount);
    return map;
  }

  ImportBatchesCompanion toCompanion(bool nullToAbsent) {
    return ImportBatchesCompanion(
      id: Value(id),
      importedAt: Value(importedAt),
      sourceKind: Value(sourceKind),
      sourceFilePath: Value(sourceFilePath),
      sourceFormatDetected: Value(sourceFormatDetected),
      periodStart: periodStart == null && nullToAbsent
          ? const Value.absent()
          : Value(periodStart),
      periodEnd: periodEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(periodEnd),
      pointCount: Value(pointCount),
    );
  }

  factory ImportBatch.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportBatch(
      id: serializer.fromJson<int>(json['id']),
      importedAt: serializer.fromJson<int>(json['importedAt']),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
      sourceFilePath: serializer.fromJson<String>(json['sourceFilePath']),
      sourceFormatDetected: serializer.fromJson<String>(
        json['sourceFormatDetected'],
      ),
      periodStart: serializer.fromJson<int?>(json['periodStart']),
      periodEnd: serializer.fromJson<int?>(json['periodEnd']),
      pointCount: serializer.fromJson<int>(json['pointCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'importedAt': serializer.toJson<int>(importedAt),
      'sourceKind': serializer.toJson<String>(sourceKind),
      'sourceFilePath': serializer.toJson<String>(sourceFilePath),
      'sourceFormatDetected': serializer.toJson<String>(sourceFormatDetected),
      'periodStart': serializer.toJson<int?>(periodStart),
      'periodEnd': serializer.toJson<int?>(periodEnd),
      'pointCount': serializer.toJson<int>(pointCount),
    };
  }

  ImportBatch copyWith({
    int? id,
    int? importedAt,
    String? sourceKind,
    String? sourceFilePath,
    String? sourceFormatDetected,
    Value<int?> periodStart = const Value.absent(),
    Value<int?> periodEnd = const Value.absent(),
    int? pointCount,
  }) => ImportBatch(
    id: id ?? this.id,
    importedAt: importedAt ?? this.importedAt,
    sourceKind: sourceKind ?? this.sourceKind,
    sourceFilePath: sourceFilePath ?? this.sourceFilePath,
    sourceFormatDetected: sourceFormatDetected ?? this.sourceFormatDetected,
    periodStart: periodStart.present ? periodStart.value : this.periodStart,
    periodEnd: periodEnd.present ? periodEnd.value : this.periodEnd,
    pointCount: pointCount ?? this.pointCount,
  );
  ImportBatch copyWithCompanion(ImportBatchesCompanion data) {
    return ImportBatch(
      id: data.id.present ? data.id.value : this.id,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      sourceFilePath: data.sourceFilePath.present
          ? data.sourceFilePath.value
          : this.sourceFilePath,
      sourceFormatDetected: data.sourceFormatDetected.present
          ? data.sourceFormatDetected.value
          : this.sourceFormatDetected,
      periodStart: data.periodStart.present
          ? data.periodStart.value
          : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      pointCount: data.pointCount.present
          ? data.pointCount.value
          : this.pointCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatch(')
          ..write('id: $id, ')
          ..write('importedAt: $importedAt, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('sourceFilePath: $sourceFilePath, ')
          ..write('sourceFormatDetected: $sourceFormatDetected, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('pointCount: $pointCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    importedAt,
    sourceKind,
    sourceFilePath,
    sourceFormatDetected,
    periodStart,
    periodEnd,
    pointCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportBatch &&
          other.id == this.id &&
          other.importedAt == this.importedAt &&
          other.sourceKind == this.sourceKind &&
          other.sourceFilePath == this.sourceFilePath &&
          other.sourceFormatDetected == this.sourceFormatDetected &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.pointCount == this.pointCount);
}

class ImportBatchesCompanion extends UpdateCompanion<ImportBatch> {
  final Value<int> id;
  final Value<int> importedAt;
  final Value<String> sourceKind;
  final Value<String> sourceFilePath;
  final Value<String> sourceFormatDetected;
  final Value<int?> periodStart;
  final Value<int?> periodEnd;
  final Value<int> pointCount;
  const ImportBatchesCompanion({
    this.id = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.sourceFilePath = const Value.absent(),
    this.sourceFormatDetected = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.pointCount = const Value.absent(),
  });
  ImportBatchesCompanion.insert({
    this.id = const Value.absent(),
    required int importedAt,
    required String sourceKind,
    required String sourceFilePath,
    required String sourceFormatDetected,
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.pointCount = const Value.absent(),
  }) : importedAt = Value(importedAt),
       sourceKind = Value(sourceKind),
       sourceFilePath = Value(sourceFilePath),
       sourceFormatDetected = Value(sourceFormatDetected);
  static Insertable<ImportBatch> custom({
    Expression<int>? id,
    Expression<int>? importedAt,
    Expression<String>? sourceKind,
    Expression<String>? sourceFilePath,
    Expression<String>? sourceFormatDetected,
    Expression<int>? periodStart,
    Expression<int>? periodEnd,
    Expression<int>? pointCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (importedAt != null) 'imported_at': importedAt,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (sourceFilePath != null) 'source_file_path': sourceFilePath,
      if (sourceFormatDetected != null)
        'source_format_detected': sourceFormatDetected,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (pointCount != null) 'point_count': pointCount,
    });
  }

  ImportBatchesCompanion copyWith({
    Value<int>? id,
    Value<int>? importedAt,
    Value<String>? sourceKind,
    Value<String>? sourceFilePath,
    Value<String>? sourceFormatDetected,
    Value<int?>? periodStart,
    Value<int?>? periodEnd,
    Value<int>? pointCount,
  }) {
    return ImportBatchesCompanion(
      id: id ?? this.id,
      importedAt: importedAt ?? this.importedAt,
      sourceKind: sourceKind ?? this.sourceKind,
      sourceFilePath: sourceFilePath ?? this.sourceFilePath,
      sourceFormatDetected: sourceFormatDetected ?? this.sourceFormatDetected,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      pointCount: pointCount ?? this.pointCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<int>(importedAt.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    if (sourceFilePath.present) {
      map['source_file_path'] = Variable<String>(sourceFilePath.value);
    }
    if (sourceFormatDetected.present) {
      map['source_format_detected'] = Variable<String>(
        sourceFormatDetected.value,
      );
    }
    if (periodStart.present) {
      map['period_start'] = Variable<int>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<int>(periodEnd.value);
    }
    if (pointCount.present) {
      map['point_count'] = Variable<int>(pointCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchesCompanion(')
          ..write('id: $id, ')
          ..write('importedAt: $importedAt, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('sourceFilePath: $sourceFilePath, ')
          ..write('sourceFormatDetected: $sourceFormatDetected, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('pointCount: $pointCount')
          ..write(')'))
        .toString();
  }
}

class $RawPointsTable extends RawPoints
    with TableInfo<$RawPointsTable, RawPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawPointsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<int> batchId = GeneratedColumn<int>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES import_batches (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _timestampUtcMeta = const VerificationMeta(
    'timestampUtc',
  );
  @override
  late final GeneratedColumn<int> timestampUtc = GeneratedColumn<int>(
    'timestamp_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tzOffsetMinutesMeta = const VerificationMeta(
    'tzOffsetMinutes',
  );
  @override
  late final GeneratedColumn<int> tzOffsetMinutes = GeneratedColumn<int>(
    'tz_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMMeta = const VerificationMeta(
    'accuracyM',
  );
  @override
  late final GeneratedColumn<double> accuracyM = GeneratedColumn<double>(
    'accuracy_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altitudeMMeta = const VerificationMeta(
    'altitudeM',
  );
  @override
  late final GeneratedColumn<double> altitudeM = GeneratedColumn<double>(
    'altitude_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedMsMeta = const VerificationMeta(
    'speedMs',
  );
  @override
  late final GeneratedColumn<double> speedMs = GeneratedColumn<double>(
    'speed_ms',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceKindMeta = const VerificationMeta(
    'sourceKind',
  );
  @override
  late final GeneratedColumn<String> sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    batchId,
    timestampUtc,
    tzOffsetMinutes,
    lat,
    lon,
    accuracyM,
    altitudeM,
    speedMs,
    sourceKind,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('timestamp_utc')) {
      context.handle(
        _timestampUtcMeta,
        timestampUtc.isAcceptableOrUnknown(
          data['timestamp_utc']!,
          _timestampUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timestampUtcMeta);
    }
    if (data.containsKey('tz_offset_minutes')) {
      context.handle(
        _tzOffsetMinutesMeta,
        tzOffsetMinutes.isAcceptableOrUnknown(
          data['tz_offset_minutes']!,
          _tzOffsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tzOffsetMinutesMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('accuracy_m')) {
      context.handle(
        _accuracyMMeta,
        accuracyM.isAcceptableOrUnknown(data['accuracy_m']!, _accuracyMMeta),
      );
    }
    if (data.containsKey('altitude_m')) {
      context.handle(
        _altitudeMMeta,
        altitudeM.isAcceptableOrUnknown(data['altitude_m']!, _altitudeMMeta),
      );
    }
    if (data.containsKey('speed_ms')) {
      context.handle(
        _speedMsMeta,
        speedMs.isAcceptableOrUnknown(data['speed_ms']!, _speedMsMeta),
      );
    }
    if (data.containsKey('source_kind')) {
      context.handle(
        _sourceKindMeta,
        sourceKind.isAcceptableOrUnknown(data['source_kind']!, _sourceKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKindMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RawPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_id'],
      )!,
      timestampUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp_utc'],
      )!,
      tzOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tz_offset_minutes'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      accuracyM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_m'],
      ),
      altitudeM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude_m'],
      ),
      speedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_ms'],
      ),
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
    );
  }

  @override
  $RawPointsTable createAlias(String alias) {
    return $RawPointsTable(attachedDatabase, alias);
  }
}

class RawPoint extends DataClass implements Insertable<RawPoint> {
  /// Identifiant.
  final int id;

  /// Import d'origine.
  final int batchId;

  /// Instant UTC, en millisecondes.
  final int timestampUtc;

  /// Décalage local, en minutes — stocké séparément (§5.5).
  final int tzOffsetMinutes;

  /// Latitude décimale.
  final double lat;

  /// Longitude décimale.
  final double lon;

  /// Précision annoncée, en mètres.
  final double? accuracyM;

  /// Altitude, en mètres.
  final double? altitudeM;

  /// Vitesse, en mètres par seconde.
  final double? speedMs;

  /// Origine de l'enregistrement (§3.1).
  final String sourceKind;
  const RawPoint({
    required this.id,
    required this.batchId,
    required this.timestampUtc,
    required this.tzOffsetMinutes,
    required this.lat,
    required this.lon,
    this.accuracyM,
    this.altitudeM,
    this.speedMs,
    required this.sourceKind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['batch_id'] = Variable<int>(batchId);
    map['timestamp_utc'] = Variable<int>(timestampUtc);
    map['tz_offset_minutes'] = Variable<int>(tzOffsetMinutes);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || accuracyM != null) {
      map['accuracy_m'] = Variable<double>(accuracyM);
    }
    if (!nullToAbsent || altitudeM != null) {
      map['altitude_m'] = Variable<double>(altitudeM);
    }
    if (!nullToAbsent || speedMs != null) {
      map['speed_ms'] = Variable<double>(speedMs);
    }
    map['source_kind'] = Variable<String>(sourceKind);
    return map;
  }

  RawPointsCompanion toCompanion(bool nullToAbsent) {
    return RawPointsCompanion(
      id: Value(id),
      batchId: Value(batchId),
      timestampUtc: Value(timestampUtc),
      tzOffsetMinutes: Value(tzOffsetMinutes),
      lat: Value(lat),
      lon: Value(lon),
      accuracyM: accuracyM == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyM),
      altitudeM: altitudeM == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeM),
      speedMs: speedMs == null && nullToAbsent
          ? const Value.absent()
          : Value(speedMs),
      sourceKind: Value(sourceKind),
    );
  }

  factory RawPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawPoint(
      id: serializer.fromJson<int>(json['id']),
      batchId: serializer.fromJson<int>(json['batchId']),
      timestampUtc: serializer.fromJson<int>(json['timestampUtc']),
      tzOffsetMinutes: serializer.fromJson<int>(json['tzOffsetMinutes']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      accuracyM: serializer.fromJson<double?>(json['accuracyM']),
      altitudeM: serializer.fromJson<double?>(json['altitudeM']),
      speedMs: serializer.fromJson<double?>(json['speedMs']),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'batchId': serializer.toJson<int>(batchId),
      'timestampUtc': serializer.toJson<int>(timestampUtc),
      'tzOffsetMinutes': serializer.toJson<int>(tzOffsetMinutes),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'accuracyM': serializer.toJson<double?>(accuracyM),
      'altitudeM': serializer.toJson<double?>(altitudeM),
      'speedMs': serializer.toJson<double?>(speedMs),
      'sourceKind': serializer.toJson<String>(sourceKind),
    };
  }

  RawPoint copyWith({
    int? id,
    int? batchId,
    int? timestampUtc,
    int? tzOffsetMinutes,
    double? lat,
    double? lon,
    Value<double?> accuracyM = const Value.absent(),
    Value<double?> altitudeM = const Value.absent(),
    Value<double?> speedMs = const Value.absent(),
    String? sourceKind,
  }) => RawPoint(
    id: id ?? this.id,
    batchId: batchId ?? this.batchId,
    timestampUtc: timestampUtc ?? this.timestampUtc,
    tzOffsetMinutes: tzOffsetMinutes ?? this.tzOffsetMinutes,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    accuracyM: accuracyM.present ? accuracyM.value : this.accuracyM,
    altitudeM: altitudeM.present ? altitudeM.value : this.altitudeM,
    speedMs: speedMs.present ? speedMs.value : this.speedMs,
    sourceKind: sourceKind ?? this.sourceKind,
  );
  RawPoint copyWithCompanion(RawPointsCompanion data) {
    return RawPoint(
      id: data.id.present ? data.id.value : this.id,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      timestampUtc: data.timestampUtc.present
          ? data.timestampUtc.value
          : this.timestampUtc,
      tzOffsetMinutes: data.tzOffsetMinutes.present
          ? data.tzOffsetMinutes.value
          : this.tzOffsetMinutes,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      accuracyM: data.accuracyM.present ? data.accuracyM.value : this.accuracyM,
      altitudeM: data.altitudeM.present ? data.altitudeM.value : this.altitudeM,
      speedMs: data.speedMs.present ? data.speedMs.value : this.speedMs,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawPoint(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('timestampUtc: $timestampUtc, ')
          ..write('tzOffsetMinutes: $tzOffsetMinutes, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('accuracyM: $accuracyM, ')
          ..write('altitudeM: $altitudeM, ')
          ..write('speedMs: $speedMs, ')
          ..write('sourceKind: $sourceKind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    batchId,
    timestampUtc,
    tzOffsetMinutes,
    lat,
    lon,
    accuracyM,
    altitudeM,
    speedMs,
    sourceKind,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawPoint &&
          other.id == this.id &&
          other.batchId == this.batchId &&
          other.timestampUtc == this.timestampUtc &&
          other.tzOffsetMinutes == this.tzOffsetMinutes &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.accuracyM == this.accuracyM &&
          other.altitudeM == this.altitudeM &&
          other.speedMs == this.speedMs &&
          other.sourceKind == this.sourceKind);
}

class RawPointsCompanion extends UpdateCompanion<RawPoint> {
  final Value<int> id;
  final Value<int> batchId;
  final Value<int> timestampUtc;
  final Value<int> tzOffsetMinutes;
  final Value<double> lat;
  final Value<double> lon;
  final Value<double?> accuracyM;
  final Value<double?> altitudeM;
  final Value<double?> speedMs;
  final Value<String> sourceKind;
  const RawPointsCompanion({
    this.id = const Value.absent(),
    this.batchId = const Value.absent(),
    this.timestampUtc = const Value.absent(),
    this.tzOffsetMinutes = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.accuracyM = const Value.absent(),
    this.altitudeM = const Value.absent(),
    this.speedMs = const Value.absent(),
    this.sourceKind = const Value.absent(),
  });
  RawPointsCompanion.insert({
    this.id = const Value.absent(),
    required int batchId,
    required int timestampUtc,
    required int tzOffsetMinutes,
    required double lat,
    required double lon,
    this.accuracyM = const Value.absent(),
    this.altitudeM = const Value.absent(),
    this.speedMs = const Value.absent(),
    required String sourceKind,
  }) : batchId = Value(batchId),
       timestampUtc = Value(timestampUtc),
       tzOffsetMinutes = Value(tzOffsetMinutes),
       lat = Value(lat),
       lon = Value(lon),
       sourceKind = Value(sourceKind);
  static Insertable<RawPoint> custom({
    Expression<int>? id,
    Expression<int>? batchId,
    Expression<int>? timestampUtc,
    Expression<int>? tzOffsetMinutes,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<double>? accuracyM,
    Expression<double>? altitudeM,
    Expression<double>? speedMs,
    Expression<String>? sourceKind,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (batchId != null) 'batch_id': batchId,
      if (timestampUtc != null) 'timestamp_utc': timestampUtc,
      if (tzOffsetMinutes != null) 'tz_offset_minutes': tzOffsetMinutes,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (accuracyM != null) 'accuracy_m': accuracyM,
      if (altitudeM != null) 'altitude_m': altitudeM,
      if (speedMs != null) 'speed_ms': speedMs,
      if (sourceKind != null) 'source_kind': sourceKind,
    });
  }

  RawPointsCompanion copyWith({
    Value<int>? id,
    Value<int>? batchId,
    Value<int>? timestampUtc,
    Value<int>? tzOffsetMinutes,
    Value<double>? lat,
    Value<double>? lon,
    Value<double?>? accuracyM,
    Value<double?>? altitudeM,
    Value<double?>? speedMs,
    Value<String>? sourceKind,
  }) {
    return RawPointsCompanion(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      timestampUtc: timestampUtc ?? this.timestampUtc,
      tzOffsetMinutes: tzOffsetMinutes ?? this.tzOffsetMinutes,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      accuracyM: accuracyM ?? this.accuracyM,
      altitudeM: altitudeM ?? this.altitudeM,
      speedMs: speedMs ?? this.speedMs,
      sourceKind: sourceKind ?? this.sourceKind,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<int>(batchId.value);
    }
    if (timestampUtc.present) {
      map['timestamp_utc'] = Variable<int>(timestampUtc.value);
    }
    if (tzOffsetMinutes.present) {
      map['tz_offset_minutes'] = Variable<int>(tzOffsetMinutes.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (accuracyM.present) {
      map['accuracy_m'] = Variable<double>(accuracyM.value);
    }
    if (altitudeM.present) {
      map['altitude_m'] = Variable<double>(altitudeM.value);
    }
    if (speedMs.present) {
      map['speed_ms'] = Variable<double>(speedMs.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawPointsCompanion(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('timestampUtc: $timestampUtc, ')
          ..write('tzOffsetMinutes: $tzOffsetMinutes, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('accuracyM: $accuracyM, ')
          ..write('altitudeM: $altitudeM, ')
          ..write('speedMs: $speedMs, ')
          ..write('sourceKind: $sourceKind')
          ..write(')'))
        .toString();
  }
}

class $SegmentsTable extends Segments with TableInfo<$SegmentsTable, Segment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SegmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<int> batchId = GeneratedColumn<int>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES import_batches (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startTsUtcMeta = const VerificationMeta(
    'startTsUtc',
  );
  @override
  late final GeneratedColumn<int> startTsUtc = GeneratedColumn<int>(
    'start_ts_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTzOffsetMinutesMeta =
      const VerificationMeta('startTzOffsetMinutes');
  @override
  late final GeneratedColumn<int> startTzOffsetMinutes = GeneratedColumn<int>(
    'start_tz_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTsUtcMeta = const VerificationMeta(
    'endTsUtc',
  );
  @override
  late final GeneratedColumn<int> endTsUtc = GeneratedColumn<int>(
    'end_ts_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTzOffsetMinutesMeta =
      const VerificationMeta('endTzOffsetMinutes');
  @override
  late final GeneratedColumn<int> endTzOffsetMinutes = GeneratedColumn<int>(
    'end_tz_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startLatMeta = const VerificationMeta(
    'startLat',
  );
  @override
  late final GeneratedColumn<double> startLat = GeneratedColumn<double>(
    'start_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startLonMeta = const VerificationMeta(
    'startLon',
  );
  @override
  late final GeneratedColumn<double> startLon = GeneratedColumn<double>(
    'start_lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endLatMeta = const VerificationMeta('endLat');
  @override
  late final GeneratedColumn<double> endLat = GeneratedColumn<double>(
    'end_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endLonMeta = const VerificationMeta('endLon');
  @override
  late final GeneratedColumn<double> endLon = GeneratedColumn<double>(
    'end_lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta(
    'distanceM',
  );
  @override
  late final GeneratedColumn<double> distanceM = GeneratedColumn<double>(
    'distance_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detectedModeMeta = const VerificationMeta(
    'detectedMode',
  );
  @override
  late final GeneratedColumn<String> detectedMode = GeneratedColumn<String>(
    'detected_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeConfidenceMeta = const VerificationMeta(
    'modeConfidence',
  );
  @override
  late final GeneratedColumn<double> modeConfidence = GeneratedColumn<double>(
    'mode_confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceKindMeta = const VerificationMeta(
    'sourceKind',
  );
  @override
  late final GeneratedColumn<String> sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    batchId,
    startTsUtc,
    startTzOffsetMinutes,
    endTsUtc,
    endTzOffsetMinutes,
    startLat,
    startLon,
    endLat,
    endLon,
    distanceM,
    detectedMode,
    modeConfidence,
    sourceKind,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'segments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Segment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('start_ts_utc')) {
      context.handle(
        _startTsUtcMeta,
        startTsUtc.isAcceptableOrUnknown(
          data['start_ts_utc']!,
          _startTsUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startTsUtcMeta);
    }
    if (data.containsKey('start_tz_offset_minutes')) {
      context.handle(
        _startTzOffsetMinutesMeta,
        startTzOffsetMinutes.isAcceptableOrUnknown(
          data['start_tz_offset_minutes']!,
          _startTzOffsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startTzOffsetMinutesMeta);
    }
    if (data.containsKey('end_ts_utc')) {
      context.handle(
        _endTsUtcMeta,
        endTsUtc.isAcceptableOrUnknown(data['end_ts_utc']!, _endTsUtcMeta),
      );
    } else if (isInserting) {
      context.missing(_endTsUtcMeta);
    }
    if (data.containsKey('end_tz_offset_minutes')) {
      context.handle(
        _endTzOffsetMinutesMeta,
        endTzOffsetMinutes.isAcceptableOrUnknown(
          data['end_tz_offset_minutes']!,
          _endTzOffsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_endTzOffsetMinutesMeta);
    }
    if (data.containsKey('start_lat')) {
      context.handle(
        _startLatMeta,
        startLat.isAcceptableOrUnknown(data['start_lat']!, _startLatMeta),
      );
    } else if (isInserting) {
      context.missing(_startLatMeta);
    }
    if (data.containsKey('start_lon')) {
      context.handle(
        _startLonMeta,
        startLon.isAcceptableOrUnknown(data['start_lon']!, _startLonMeta),
      );
    } else if (isInserting) {
      context.missing(_startLonMeta);
    }
    if (data.containsKey('end_lat')) {
      context.handle(
        _endLatMeta,
        endLat.isAcceptableOrUnknown(data['end_lat']!, _endLatMeta),
      );
    } else if (isInserting) {
      context.missing(_endLatMeta);
    }
    if (data.containsKey('end_lon')) {
      context.handle(
        _endLonMeta,
        endLon.isAcceptableOrUnknown(data['end_lon']!, _endLonMeta),
      );
    } else if (isInserting) {
      context.missing(_endLonMeta);
    }
    if (data.containsKey('distance_m')) {
      context.handle(
        _distanceMMeta,
        distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta),
      );
    }
    if (data.containsKey('detected_mode')) {
      context.handle(
        _detectedModeMeta,
        detectedMode.isAcceptableOrUnknown(
          data['detected_mode']!,
          _detectedModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detectedModeMeta);
    }
    if (data.containsKey('mode_confidence')) {
      context.handle(
        _modeConfidenceMeta,
        modeConfidence.isAcceptableOrUnknown(
          data['mode_confidence']!,
          _modeConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('source_kind')) {
      context.handle(
        _sourceKindMeta,
        sourceKind.isAcceptableOrUnknown(data['source_kind']!, _sourceKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKindMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Segment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Segment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_id'],
      )!,
      startTsUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_ts_utc'],
      )!,
      startTzOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_tz_offset_minutes'],
      )!,
      endTsUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_ts_utc'],
      )!,
      endTzOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_tz_offset_minutes'],
      )!,
      startLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_lat'],
      )!,
      startLon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_lon'],
      )!,
      endLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}end_lat'],
      )!,
      endLon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}end_lon'],
      )!,
      distanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_m'],
      ),
      detectedMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detected_mode'],
      )!,
      modeConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mode_confidence'],
      ),
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
    );
  }

  @override
  $SegmentsTable createAlias(String alias) {
    return $SegmentsTable(attachedDatabase, alias);
  }
}

class Segment extends DataClass implements Insertable<Segment> {
  /// Identifiant.
  final int id;

  /// Import d'origine.
  final int batchId;

  /// Début, en millisecondes UTC.
  final int startTsUtc;

  /// Décalage local au départ, en minutes.
  final int startTzOffsetMinutes;

  /// Fin, en millisecondes UTC.
  final int endTsUtc;

  /// Décalage local à l'arrivée — différent du départ si le trajet traverse un
  /// fuseau (§5.5).
  final int endTzOffsetMinutes;

  /// Latitude de départ.
  final double startLat;

  /// Longitude de départ.
  final double startLon;

  /// Latitude d'arrivée.
  final double endLat;

  /// Longitude d'arrivée.
  final double endLon;

  /// Distance annoncée, en mètres.
  final double? distanceM;

  /// Mode détecté par la source.
  ///
  /// ⚠️ Garde **toujours** sa valeur d'origine (§5.1). Une correction
  /// utilisateur vit dans [UserSegmentOverrides] et est appliquée par le
  /// pipeline (§5.4) — jamais réécrite ici.
  final String detectedMode;

  /// Confiance de détection, dans [0, 1].
  final double? modeConfidence;

  /// Origine de l'enregistrement (§3.1).
  final String sourceKind;
  const Segment({
    required this.id,
    required this.batchId,
    required this.startTsUtc,
    required this.startTzOffsetMinutes,
    required this.endTsUtc,
    required this.endTzOffsetMinutes,
    required this.startLat,
    required this.startLon,
    required this.endLat,
    required this.endLon,
    this.distanceM,
    required this.detectedMode,
    this.modeConfidence,
    required this.sourceKind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['batch_id'] = Variable<int>(batchId);
    map['start_ts_utc'] = Variable<int>(startTsUtc);
    map['start_tz_offset_minutes'] = Variable<int>(startTzOffsetMinutes);
    map['end_ts_utc'] = Variable<int>(endTsUtc);
    map['end_tz_offset_minutes'] = Variable<int>(endTzOffsetMinutes);
    map['start_lat'] = Variable<double>(startLat);
    map['start_lon'] = Variable<double>(startLon);
    map['end_lat'] = Variable<double>(endLat);
    map['end_lon'] = Variable<double>(endLon);
    if (!nullToAbsent || distanceM != null) {
      map['distance_m'] = Variable<double>(distanceM);
    }
    map['detected_mode'] = Variable<String>(detectedMode);
    if (!nullToAbsent || modeConfidence != null) {
      map['mode_confidence'] = Variable<double>(modeConfidence);
    }
    map['source_kind'] = Variable<String>(sourceKind);
    return map;
  }

  SegmentsCompanion toCompanion(bool nullToAbsent) {
    return SegmentsCompanion(
      id: Value(id),
      batchId: Value(batchId),
      startTsUtc: Value(startTsUtc),
      startTzOffsetMinutes: Value(startTzOffsetMinutes),
      endTsUtc: Value(endTsUtc),
      endTzOffsetMinutes: Value(endTzOffsetMinutes),
      startLat: Value(startLat),
      startLon: Value(startLon),
      endLat: Value(endLat),
      endLon: Value(endLon),
      distanceM: distanceM == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceM),
      detectedMode: Value(detectedMode),
      modeConfidence: modeConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(modeConfidence),
      sourceKind: Value(sourceKind),
    );
  }

  factory Segment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Segment(
      id: serializer.fromJson<int>(json['id']),
      batchId: serializer.fromJson<int>(json['batchId']),
      startTsUtc: serializer.fromJson<int>(json['startTsUtc']),
      startTzOffsetMinutes: serializer.fromJson<int>(
        json['startTzOffsetMinutes'],
      ),
      endTsUtc: serializer.fromJson<int>(json['endTsUtc']),
      endTzOffsetMinutes: serializer.fromJson<int>(json['endTzOffsetMinutes']),
      startLat: serializer.fromJson<double>(json['startLat']),
      startLon: serializer.fromJson<double>(json['startLon']),
      endLat: serializer.fromJson<double>(json['endLat']),
      endLon: serializer.fromJson<double>(json['endLon']),
      distanceM: serializer.fromJson<double?>(json['distanceM']),
      detectedMode: serializer.fromJson<String>(json['detectedMode']),
      modeConfidence: serializer.fromJson<double?>(json['modeConfidence']),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'batchId': serializer.toJson<int>(batchId),
      'startTsUtc': serializer.toJson<int>(startTsUtc),
      'startTzOffsetMinutes': serializer.toJson<int>(startTzOffsetMinutes),
      'endTsUtc': serializer.toJson<int>(endTsUtc),
      'endTzOffsetMinutes': serializer.toJson<int>(endTzOffsetMinutes),
      'startLat': serializer.toJson<double>(startLat),
      'startLon': serializer.toJson<double>(startLon),
      'endLat': serializer.toJson<double>(endLat),
      'endLon': serializer.toJson<double>(endLon),
      'distanceM': serializer.toJson<double?>(distanceM),
      'detectedMode': serializer.toJson<String>(detectedMode),
      'modeConfidence': serializer.toJson<double?>(modeConfidence),
      'sourceKind': serializer.toJson<String>(sourceKind),
    };
  }

  Segment copyWith({
    int? id,
    int? batchId,
    int? startTsUtc,
    int? startTzOffsetMinutes,
    int? endTsUtc,
    int? endTzOffsetMinutes,
    double? startLat,
    double? startLon,
    double? endLat,
    double? endLon,
    Value<double?> distanceM = const Value.absent(),
    String? detectedMode,
    Value<double?> modeConfidence = const Value.absent(),
    String? sourceKind,
  }) => Segment(
    id: id ?? this.id,
    batchId: batchId ?? this.batchId,
    startTsUtc: startTsUtc ?? this.startTsUtc,
    startTzOffsetMinutes: startTzOffsetMinutes ?? this.startTzOffsetMinutes,
    endTsUtc: endTsUtc ?? this.endTsUtc,
    endTzOffsetMinutes: endTzOffsetMinutes ?? this.endTzOffsetMinutes,
    startLat: startLat ?? this.startLat,
    startLon: startLon ?? this.startLon,
    endLat: endLat ?? this.endLat,
    endLon: endLon ?? this.endLon,
    distanceM: distanceM.present ? distanceM.value : this.distanceM,
    detectedMode: detectedMode ?? this.detectedMode,
    modeConfidence: modeConfidence.present
        ? modeConfidence.value
        : this.modeConfidence,
    sourceKind: sourceKind ?? this.sourceKind,
  );
  Segment copyWithCompanion(SegmentsCompanion data) {
    return Segment(
      id: data.id.present ? data.id.value : this.id,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      startTsUtc: data.startTsUtc.present
          ? data.startTsUtc.value
          : this.startTsUtc,
      startTzOffsetMinutes: data.startTzOffsetMinutes.present
          ? data.startTzOffsetMinutes.value
          : this.startTzOffsetMinutes,
      endTsUtc: data.endTsUtc.present ? data.endTsUtc.value : this.endTsUtc,
      endTzOffsetMinutes: data.endTzOffsetMinutes.present
          ? data.endTzOffsetMinutes.value
          : this.endTzOffsetMinutes,
      startLat: data.startLat.present ? data.startLat.value : this.startLat,
      startLon: data.startLon.present ? data.startLon.value : this.startLon,
      endLat: data.endLat.present ? data.endLat.value : this.endLat,
      endLon: data.endLon.present ? data.endLon.value : this.endLon,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      detectedMode: data.detectedMode.present
          ? data.detectedMode.value
          : this.detectedMode,
      modeConfidence: data.modeConfidence.present
          ? data.modeConfidence.value
          : this.modeConfidence,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Segment(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('startTsUtc: $startTsUtc, ')
          ..write('startTzOffsetMinutes: $startTzOffsetMinutes, ')
          ..write('endTsUtc: $endTsUtc, ')
          ..write('endTzOffsetMinutes: $endTzOffsetMinutes, ')
          ..write('startLat: $startLat, ')
          ..write('startLon: $startLon, ')
          ..write('endLat: $endLat, ')
          ..write('endLon: $endLon, ')
          ..write('distanceM: $distanceM, ')
          ..write('detectedMode: $detectedMode, ')
          ..write('modeConfidence: $modeConfidence, ')
          ..write('sourceKind: $sourceKind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    batchId,
    startTsUtc,
    startTzOffsetMinutes,
    endTsUtc,
    endTzOffsetMinutes,
    startLat,
    startLon,
    endLat,
    endLon,
    distanceM,
    detectedMode,
    modeConfidence,
    sourceKind,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Segment &&
          other.id == this.id &&
          other.batchId == this.batchId &&
          other.startTsUtc == this.startTsUtc &&
          other.startTzOffsetMinutes == this.startTzOffsetMinutes &&
          other.endTsUtc == this.endTsUtc &&
          other.endTzOffsetMinutes == this.endTzOffsetMinutes &&
          other.startLat == this.startLat &&
          other.startLon == this.startLon &&
          other.endLat == this.endLat &&
          other.endLon == this.endLon &&
          other.distanceM == this.distanceM &&
          other.detectedMode == this.detectedMode &&
          other.modeConfidence == this.modeConfidence &&
          other.sourceKind == this.sourceKind);
}

class SegmentsCompanion extends UpdateCompanion<Segment> {
  final Value<int> id;
  final Value<int> batchId;
  final Value<int> startTsUtc;
  final Value<int> startTzOffsetMinutes;
  final Value<int> endTsUtc;
  final Value<int> endTzOffsetMinutes;
  final Value<double> startLat;
  final Value<double> startLon;
  final Value<double> endLat;
  final Value<double> endLon;
  final Value<double?> distanceM;
  final Value<String> detectedMode;
  final Value<double?> modeConfidence;
  final Value<String> sourceKind;
  const SegmentsCompanion({
    this.id = const Value.absent(),
    this.batchId = const Value.absent(),
    this.startTsUtc = const Value.absent(),
    this.startTzOffsetMinutes = const Value.absent(),
    this.endTsUtc = const Value.absent(),
    this.endTzOffsetMinutes = const Value.absent(),
    this.startLat = const Value.absent(),
    this.startLon = const Value.absent(),
    this.endLat = const Value.absent(),
    this.endLon = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.detectedMode = const Value.absent(),
    this.modeConfidence = const Value.absent(),
    this.sourceKind = const Value.absent(),
  });
  SegmentsCompanion.insert({
    this.id = const Value.absent(),
    required int batchId,
    required int startTsUtc,
    required int startTzOffsetMinutes,
    required int endTsUtc,
    required int endTzOffsetMinutes,
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
    this.distanceM = const Value.absent(),
    required String detectedMode,
    this.modeConfidence = const Value.absent(),
    required String sourceKind,
  }) : batchId = Value(batchId),
       startTsUtc = Value(startTsUtc),
       startTzOffsetMinutes = Value(startTzOffsetMinutes),
       endTsUtc = Value(endTsUtc),
       endTzOffsetMinutes = Value(endTzOffsetMinutes),
       startLat = Value(startLat),
       startLon = Value(startLon),
       endLat = Value(endLat),
       endLon = Value(endLon),
       detectedMode = Value(detectedMode),
       sourceKind = Value(sourceKind);
  static Insertable<Segment> custom({
    Expression<int>? id,
    Expression<int>? batchId,
    Expression<int>? startTsUtc,
    Expression<int>? startTzOffsetMinutes,
    Expression<int>? endTsUtc,
    Expression<int>? endTzOffsetMinutes,
    Expression<double>? startLat,
    Expression<double>? startLon,
    Expression<double>? endLat,
    Expression<double>? endLon,
    Expression<double>? distanceM,
    Expression<String>? detectedMode,
    Expression<double>? modeConfidence,
    Expression<String>? sourceKind,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (batchId != null) 'batch_id': batchId,
      if (startTsUtc != null) 'start_ts_utc': startTsUtc,
      if (startTzOffsetMinutes != null)
        'start_tz_offset_minutes': startTzOffsetMinutes,
      if (endTsUtc != null) 'end_ts_utc': endTsUtc,
      if (endTzOffsetMinutes != null)
        'end_tz_offset_minutes': endTzOffsetMinutes,
      if (startLat != null) 'start_lat': startLat,
      if (startLon != null) 'start_lon': startLon,
      if (endLat != null) 'end_lat': endLat,
      if (endLon != null) 'end_lon': endLon,
      if (distanceM != null) 'distance_m': distanceM,
      if (detectedMode != null) 'detected_mode': detectedMode,
      if (modeConfidence != null) 'mode_confidence': modeConfidence,
      if (sourceKind != null) 'source_kind': sourceKind,
    });
  }

  SegmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? batchId,
    Value<int>? startTsUtc,
    Value<int>? startTzOffsetMinutes,
    Value<int>? endTsUtc,
    Value<int>? endTzOffsetMinutes,
    Value<double>? startLat,
    Value<double>? startLon,
    Value<double>? endLat,
    Value<double>? endLon,
    Value<double?>? distanceM,
    Value<String>? detectedMode,
    Value<double?>? modeConfidence,
    Value<String>? sourceKind,
  }) {
    return SegmentsCompanion(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      startTsUtc: startTsUtc ?? this.startTsUtc,
      startTzOffsetMinutes: startTzOffsetMinutes ?? this.startTzOffsetMinutes,
      endTsUtc: endTsUtc ?? this.endTsUtc,
      endTzOffsetMinutes: endTzOffsetMinutes ?? this.endTzOffsetMinutes,
      startLat: startLat ?? this.startLat,
      startLon: startLon ?? this.startLon,
      endLat: endLat ?? this.endLat,
      endLon: endLon ?? this.endLon,
      distanceM: distanceM ?? this.distanceM,
      detectedMode: detectedMode ?? this.detectedMode,
      modeConfidence: modeConfidence ?? this.modeConfidence,
      sourceKind: sourceKind ?? this.sourceKind,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<int>(batchId.value);
    }
    if (startTsUtc.present) {
      map['start_ts_utc'] = Variable<int>(startTsUtc.value);
    }
    if (startTzOffsetMinutes.present) {
      map['start_tz_offset_minutes'] = Variable<int>(
        startTzOffsetMinutes.value,
      );
    }
    if (endTsUtc.present) {
      map['end_ts_utc'] = Variable<int>(endTsUtc.value);
    }
    if (endTzOffsetMinutes.present) {
      map['end_tz_offset_minutes'] = Variable<int>(endTzOffsetMinutes.value);
    }
    if (startLat.present) {
      map['start_lat'] = Variable<double>(startLat.value);
    }
    if (startLon.present) {
      map['start_lon'] = Variable<double>(startLon.value);
    }
    if (endLat.present) {
      map['end_lat'] = Variable<double>(endLat.value);
    }
    if (endLon.present) {
      map['end_lon'] = Variable<double>(endLon.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<double>(distanceM.value);
    }
    if (detectedMode.present) {
      map['detected_mode'] = Variable<String>(detectedMode.value);
    }
    if (modeConfidence.present) {
      map['mode_confidence'] = Variable<double>(modeConfidence.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SegmentsCompanion(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('startTsUtc: $startTsUtc, ')
          ..write('startTzOffsetMinutes: $startTzOffsetMinutes, ')
          ..write('endTsUtc: $endTsUtc, ')
          ..write('endTzOffsetMinutes: $endTzOffsetMinutes, ')
          ..write('startLat: $startLat, ')
          ..write('startLon: $startLon, ')
          ..write('endLat: $endLat, ')
          ..write('endLon: $endLon, ')
          ..write('distanceM: $distanceM, ')
          ..write('detectedMode: $detectedMode, ')
          ..write('modeConfidence: $modeConfidence, ')
          ..write('sourceKind: $sourceKind')
          ..write(')'))
        .toString();
  }
}

class $GeoPlacesTable extends GeoPlaces
    with TableInfo<$GeoPlacesTable, GeoPlace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeoPlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _nameAsciiMeta = const VerificationMeta(
    'nameAscii',
  );
  @override
  late final GeneratedColumn<String> nameAscii = GeneratedColumn<String>(
    'name_ascii',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _admin1Meta = const VerificationMeta('admin1');
  @override
  late final GeneratedColumn<String> admin1 = GeneratedColumn<String>(
    'admin1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _featureClassMeta = const VerificationMeta(
    'featureClass',
  );
  @override
  late final GeneratedColumn<String> featureClass = GeneratedColumn<String>(
    'feature_class',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _populationMeta = const VerificationMeta(
    'population',
  );
  @override
  late final GeneratedColumn<int> population = GeneratedColumn<int>(
    'population',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameAscii,
    countryCode,
    admin1,
    featureClass,
    population,
    lat,
    lon,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'geo_places';
  @override
  VerificationContext validateIntegrity(
    Insertable<GeoPlace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ascii')) {
      context.handle(
        _nameAsciiMeta,
        nameAscii.isAcceptableOrUnknown(data['name_ascii']!, _nameAsciiMeta),
      );
    } else if (isInserting) {
      context.missing(_nameAsciiMeta);
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countryCodeMeta);
    }
    if (data.containsKey('admin1')) {
      context.handle(
        _admin1Meta,
        admin1.isAcceptableOrUnknown(data['admin1']!, _admin1Meta),
      );
    }
    if (data.containsKey('feature_class')) {
      context.handle(
        _featureClassMeta,
        featureClass.isAcceptableOrUnknown(
          data['feature_class']!,
          _featureClassMeta,
        ),
      );
    }
    if (data.containsKey('population')) {
      context.handle(
        _populationMeta,
        population.isAcceptableOrUnknown(data['population']!, _populationMeta),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GeoPlace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeoPlace(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAscii: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ascii'],
      )!,
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      )!,
      admin1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}admin1'],
      ),
      featureClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_class'],
      ),
      population: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}population'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
    );
  }

  @override
  $GeoPlacesTable createAlias(String alias) {
    return $GeoPlacesTable(attachedDatabase, alias);
  }
}

class GeoPlace extends DataClass implements Insertable<GeoPlace> {
  /// Identifiant GeoNames.
  final int id;

  /// Nom du lieu.
  final String name;

  /// Nom sans diacritiques, pour la recherche.
  final String nameAscii;

  /// Code pays ISO.
  final String countryCode;

  /// Première subdivision administrative.
  final String? admin1;

  /// Classe GeoNames.
  final String? featureClass;

  /// Population, quand elle est connue.
  final int? population;

  /// Latitude.
  final double lat;

  /// Longitude.
  final double lon;
  const GeoPlace({
    required this.id,
    required this.name,
    required this.nameAscii,
    required this.countryCode,
    this.admin1,
    this.featureClass,
    this.population,
    required this.lat,
    required this.lon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['name_ascii'] = Variable<String>(nameAscii);
    map['country_code'] = Variable<String>(countryCode);
    if (!nullToAbsent || admin1 != null) {
      map['admin1'] = Variable<String>(admin1);
    }
    if (!nullToAbsent || featureClass != null) {
      map['feature_class'] = Variable<String>(featureClass);
    }
    if (!nullToAbsent || population != null) {
      map['population'] = Variable<int>(population);
    }
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    return map;
  }

  GeoPlacesCompanion toCompanion(bool nullToAbsent) {
    return GeoPlacesCompanion(
      id: Value(id),
      name: Value(name),
      nameAscii: Value(nameAscii),
      countryCode: Value(countryCode),
      admin1: admin1 == null && nullToAbsent
          ? const Value.absent()
          : Value(admin1),
      featureClass: featureClass == null && nullToAbsent
          ? const Value.absent()
          : Value(featureClass),
      population: population == null && nullToAbsent
          ? const Value.absent()
          : Value(population),
      lat: Value(lat),
      lon: Value(lon),
    );
  }

  factory GeoPlace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeoPlace(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameAscii: serializer.fromJson<String>(json['nameAscii']),
      countryCode: serializer.fromJson<String>(json['countryCode']),
      admin1: serializer.fromJson<String?>(json['admin1']),
      featureClass: serializer.fromJson<String?>(json['featureClass']),
      population: serializer.fromJson<int?>(json['population']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameAscii': serializer.toJson<String>(nameAscii),
      'countryCode': serializer.toJson<String>(countryCode),
      'admin1': serializer.toJson<String?>(admin1),
      'featureClass': serializer.toJson<String?>(featureClass),
      'population': serializer.toJson<int?>(population),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
    };
  }

  GeoPlace copyWith({
    int? id,
    String? name,
    String? nameAscii,
    String? countryCode,
    Value<String?> admin1 = const Value.absent(),
    Value<String?> featureClass = const Value.absent(),
    Value<int?> population = const Value.absent(),
    double? lat,
    double? lon,
  }) => GeoPlace(
    id: id ?? this.id,
    name: name ?? this.name,
    nameAscii: nameAscii ?? this.nameAscii,
    countryCode: countryCode ?? this.countryCode,
    admin1: admin1.present ? admin1.value : this.admin1,
    featureClass: featureClass.present ? featureClass.value : this.featureClass,
    population: population.present ? population.value : this.population,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
  );
  GeoPlace copyWithCompanion(GeoPlacesCompanion data) {
    return GeoPlace(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameAscii: data.nameAscii.present ? data.nameAscii.value : this.nameAscii,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
      admin1: data.admin1.present ? data.admin1.value : this.admin1,
      featureClass: data.featureClass.present
          ? data.featureClass.value
          : this.featureClass,
      population: data.population.present
          ? data.population.value
          : this.population,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeoPlace(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAscii: $nameAscii, ')
          ..write('countryCode: $countryCode, ')
          ..write('admin1: $admin1, ')
          ..write('featureClass: $featureClass, ')
          ..write('population: $population, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameAscii,
    countryCode,
    admin1,
    featureClass,
    population,
    lat,
    lon,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeoPlace &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameAscii == this.nameAscii &&
          other.countryCode == this.countryCode &&
          other.admin1 == this.admin1 &&
          other.featureClass == this.featureClass &&
          other.population == this.population &&
          other.lat == this.lat &&
          other.lon == this.lon);
}

class GeoPlacesCompanion extends UpdateCompanion<GeoPlace> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameAscii;
  final Value<String> countryCode;
  final Value<String?> admin1;
  final Value<String?> featureClass;
  final Value<int?> population;
  final Value<double> lat;
  final Value<double> lon;
  const GeoPlacesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAscii = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.admin1 = const Value.absent(),
    this.featureClass = const Value.absent(),
    this.population = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
  });
  GeoPlacesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nameAscii,
    required String countryCode,
    this.admin1 = const Value.absent(),
    this.featureClass = const Value.absent(),
    this.population = const Value.absent(),
    required double lat,
    required double lon,
  }) : name = Value(name),
       nameAscii = Value(nameAscii),
       countryCode = Value(countryCode),
       lat = Value(lat),
       lon = Value(lon);
  static Insertable<GeoPlace> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameAscii,
    Expression<String>? countryCode,
    Expression<String>? admin1,
    Expression<String>? featureClass,
    Expression<int>? population,
    Expression<double>? lat,
    Expression<double>? lon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameAscii != null) 'name_ascii': nameAscii,
      if (countryCode != null) 'country_code': countryCode,
      if (admin1 != null) 'admin1': admin1,
      if (featureClass != null) 'feature_class': featureClass,
      if (population != null) 'population': population,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
    });
  }

  GeoPlacesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? nameAscii,
    Value<String>? countryCode,
    Value<String?>? admin1,
    Value<String?>? featureClass,
    Value<int?>? population,
    Value<double>? lat,
    Value<double>? lon,
  }) {
    return GeoPlacesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAscii: nameAscii ?? this.nameAscii,
      countryCode: countryCode ?? this.countryCode,
      admin1: admin1 ?? this.admin1,
      featureClass: featureClass ?? this.featureClass,
      population: population ?? this.population,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAscii.present) {
      map['name_ascii'] = Variable<String>(nameAscii.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (admin1.present) {
      map['admin1'] = Variable<String>(admin1.value);
    }
    if (featureClass.present) {
      map['feature_class'] = Variable<String>(featureClass.value);
    }
    if (population.present) {
      map['population'] = Variable<int>(population.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeoPlacesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAscii: $nameAscii, ')
          ..write('countryCode: $countryCode, ')
          ..write('admin1: $admin1, ')
          ..write('featureClass: $featureClass, ')
          ..write('population: $population, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon')
          ..write(')'))
        .toString();
  }
}

class $VisitsTable extends Visits with TableInfo<$VisitsTable, Visit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<int> batchId = GeneratedColumn<int>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES import_batches (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _arrivalTsUtcMeta = const VerificationMeta(
    'arrivalTsUtc',
  );
  @override
  late final GeneratedColumn<int> arrivalTsUtc = GeneratedColumn<int>(
    'arrival_ts_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arrivalTzOffsetMinutesMeta =
      const VerificationMeta('arrivalTzOffsetMinutes');
  @override
  late final GeneratedColumn<int> arrivalTzOffsetMinutes = GeneratedColumn<int>(
    'arrival_tz_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departureTsUtcMeta = const VerificationMeta(
    'departureTsUtc',
  );
  @override
  late final GeneratedColumn<int> departureTsUtc = GeneratedColumn<int>(
    'departure_ts_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departureTzOffsetMinutesMeta =
      const VerificationMeta('departureTzOffsetMinutes');
  @override
  late final GeneratedColumn<int> departureTzOffsetMinutes =
      GeneratedColumn<int>(
        'departure_tz_offset_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _radiusMMeta = const VerificationMeta(
    'radiusM',
  );
  @override
  late final GeneratedColumn<double> radiusM = GeneratedColumn<double>(
    'radius_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalPlaceRefMeta = const VerificationMeta(
    'externalPlaceRef',
  );
  @override
  late final GeneratedColumn<String> externalPlaceRef = GeneratedColumn<String>(
    'external_place_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<int> placeId = GeneratedColumn<int>(
    'place_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES geo_places (id)',
    ),
  );
  static const VerificationMeta _detectionConfidenceMeta =
      const VerificationMeta('detectionConfidence');
  @override
  late final GeneratedColumn<double> detectionConfidence =
      GeneratedColumn<double>(
        'detection_confidence',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceKindMeta = const VerificationMeta(
    'sourceKind',
  );
  @override
  late final GeneratedColumn<String> sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    batchId,
    arrivalTsUtc,
    arrivalTzOffsetMinutes,
    departureTsUtc,
    departureTzOffsetMinutes,
    lat,
    lon,
    radiusM,
    externalPlaceRef,
    placeId,
    detectionConfidence,
    sourceKind,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Visit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('arrival_ts_utc')) {
      context.handle(
        _arrivalTsUtcMeta,
        arrivalTsUtc.isAcceptableOrUnknown(
          data['arrival_ts_utc']!,
          _arrivalTsUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_arrivalTsUtcMeta);
    }
    if (data.containsKey('arrival_tz_offset_minutes')) {
      context.handle(
        _arrivalTzOffsetMinutesMeta,
        arrivalTzOffsetMinutes.isAcceptableOrUnknown(
          data['arrival_tz_offset_minutes']!,
          _arrivalTzOffsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_arrivalTzOffsetMinutesMeta);
    }
    if (data.containsKey('departure_ts_utc')) {
      context.handle(
        _departureTsUtcMeta,
        departureTsUtc.isAcceptableOrUnknown(
          data['departure_ts_utc']!,
          _departureTsUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departureTsUtcMeta);
    }
    if (data.containsKey('departure_tz_offset_minutes')) {
      context.handle(
        _departureTzOffsetMinutesMeta,
        departureTzOffsetMinutes.isAcceptableOrUnknown(
          data['departure_tz_offset_minutes']!,
          _departureTzOffsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departureTzOffsetMinutesMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('radius_m')) {
      context.handle(
        _radiusMMeta,
        radiusM.isAcceptableOrUnknown(data['radius_m']!, _radiusMMeta),
      );
    }
    if (data.containsKey('external_place_ref')) {
      context.handle(
        _externalPlaceRefMeta,
        externalPlaceRef.isAcceptableOrUnknown(
          data['external_place_ref']!,
          _externalPlaceRefMeta,
        ),
      );
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    }
    if (data.containsKey('detection_confidence')) {
      context.handle(
        _detectionConfidenceMeta,
        detectionConfidence.isAcceptableOrUnknown(
          data['detection_confidence']!,
          _detectionConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('source_kind')) {
      context.handle(
        _sourceKindMeta,
        sourceKind.isAcceptableOrUnknown(data['source_kind']!, _sourceKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKindMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Visit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Visit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_id'],
      )!,
      arrivalTsUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}arrival_ts_utc'],
      )!,
      arrivalTzOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}arrival_tz_offset_minutes'],
      )!,
      departureTsUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}departure_ts_utc'],
      )!,
      departureTzOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}departure_tz_offset_minutes'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      radiusM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}radius_m'],
      ),
      externalPlaceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_place_ref'],
      ),
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}place_id'],
      ),
      detectionConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}detection_confidence'],
      ),
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
    );
  }

  @override
  $VisitsTable createAlias(String alias) {
    return $VisitsTable(attachedDatabase, alias);
  }
}

class Visit extends DataClass implements Insertable<Visit> {
  /// Identifiant.
  final int id;

  /// Import d'origine.
  final int batchId;

  /// Arrivée, en millisecondes UTC.
  final int arrivalTsUtc;

  /// Décalage local à l'arrivée, en minutes.
  final int arrivalTzOffsetMinutes;

  /// Départ, en millisecondes UTC.
  final int departureTsUtc;

  /// Décalage local au départ, en minutes.
  final int departureTzOffsetMinutes;

  /// Latitude du lieu.
  final double lat;

  /// Longitude du lieu.
  final double lon;

  /// Rayon annoncé, en mètres.
  final double? radiusM;

  /// Identifiant de lieu **propre à la source** (`placeId` Google).
  ///
  /// Distinct du `place_id` de §5.1, qui référence le référentiel embarqué
  /// [GeoPlaces] et est résolu par le pipeline : y recopier l'identifiant
  /// Google calquerait le modèle sur Google (§3.1).
  final String? externalPlaceRef;

  /// Lieu du référentiel résolu, quand il l'a été (§5.3).
  final int? placeId;

  /// Confiance de détection, dans [0, 1].
  final double? detectionConfidence;

  /// Origine de l'enregistrement (§3.1).
  final String sourceKind;
  const Visit({
    required this.id,
    required this.batchId,
    required this.arrivalTsUtc,
    required this.arrivalTzOffsetMinutes,
    required this.departureTsUtc,
    required this.departureTzOffsetMinutes,
    required this.lat,
    required this.lon,
    this.radiusM,
    this.externalPlaceRef,
    this.placeId,
    this.detectionConfidence,
    required this.sourceKind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['batch_id'] = Variable<int>(batchId);
    map['arrival_ts_utc'] = Variable<int>(arrivalTsUtc);
    map['arrival_tz_offset_minutes'] = Variable<int>(arrivalTzOffsetMinutes);
    map['departure_ts_utc'] = Variable<int>(departureTsUtc);
    map['departure_tz_offset_minutes'] = Variable<int>(
      departureTzOffsetMinutes,
    );
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || radiusM != null) {
      map['radius_m'] = Variable<double>(radiusM);
    }
    if (!nullToAbsent || externalPlaceRef != null) {
      map['external_place_ref'] = Variable<String>(externalPlaceRef);
    }
    if (!nullToAbsent || placeId != null) {
      map['place_id'] = Variable<int>(placeId);
    }
    if (!nullToAbsent || detectionConfidence != null) {
      map['detection_confidence'] = Variable<double>(detectionConfidence);
    }
    map['source_kind'] = Variable<String>(sourceKind);
    return map;
  }

  VisitsCompanion toCompanion(bool nullToAbsent) {
    return VisitsCompanion(
      id: Value(id),
      batchId: Value(batchId),
      arrivalTsUtc: Value(arrivalTsUtc),
      arrivalTzOffsetMinutes: Value(arrivalTzOffsetMinutes),
      departureTsUtc: Value(departureTsUtc),
      departureTzOffsetMinutes: Value(departureTzOffsetMinutes),
      lat: Value(lat),
      lon: Value(lon),
      radiusM: radiusM == null && nullToAbsent
          ? const Value.absent()
          : Value(radiusM),
      externalPlaceRef: externalPlaceRef == null && nullToAbsent
          ? const Value.absent()
          : Value(externalPlaceRef),
      placeId: placeId == null && nullToAbsent
          ? const Value.absent()
          : Value(placeId),
      detectionConfidence: detectionConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(detectionConfidence),
      sourceKind: Value(sourceKind),
    );
  }

  factory Visit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Visit(
      id: serializer.fromJson<int>(json['id']),
      batchId: serializer.fromJson<int>(json['batchId']),
      arrivalTsUtc: serializer.fromJson<int>(json['arrivalTsUtc']),
      arrivalTzOffsetMinutes: serializer.fromJson<int>(
        json['arrivalTzOffsetMinutes'],
      ),
      departureTsUtc: serializer.fromJson<int>(json['departureTsUtc']),
      departureTzOffsetMinutes: serializer.fromJson<int>(
        json['departureTzOffsetMinutes'],
      ),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      radiusM: serializer.fromJson<double?>(json['radiusM']),
      externalPlaceRef: serializer.fromJson<String?>(json['externalPlaceRef']),
      placeId: serializer.fromJson<int?>(json['placeId']),
      detectionConfidence: serializer.fromJson<double?>(
        json['detectionConfidence'],
      ),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'batchId': serializer.toJson<int>(batchId),
      'arrivalTsUtc': serializer.toJson<int>(arrivalTsUtc),
      'arrivalTzOffsetMinutes': serializer.toJson<int>(arrivalTzOffsetMinutes),
      'departureTsUtc': serializer.toJson<int>(departureTsUtc),
      'departureTzOffsetMinutes': serializer.toJson<int>(
        departureTzOffsetMinutes,
      ),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'radiusM': serializer.toJson<double?>(radiusM),
      'externalPlaceRef': serializer.toJson<String?>(externalPlaceRef),
      'placeId': serializer.toJson<int?>(placeId),
      'detectionConfidence': serializer.toJson<double?>(detectionConfidence),
      'sourceKind': serializer.toJson<String>(sourceKind),
    };
  }

  Visit copyWith({
    int? id,
    int? batchId,
    int? arrivalTsUtc,
    int? arrivalTzOffsetMinutes,
    int? departureTsUtc,
    int? departureTzOffsetMinutes,
    double? lat,
    double? lon,
    Value<double?> radiusM = const Value.absent(),
    Value<String?> externalPlaceRef = const Value.absent(),
    Value<int?> placeId = const Value.absent(),
    Value<double?> detectionConfidence = const Value.absent(),
    String? sourceKind,
  }) => Visit(
    id: id ?? this.id,
    batchId: batchId ?? this.batchId,
    arrivalTsUtc: arrivalTsUtc ?? this.arrivalTsUtc,
    arrivalTzOffsetMinutes:
        arrivalTzOffsetMinutes ?? this.arrivalTzOffsetMinutes,
    departureTsUtc: departureTsUtc ?? this.departureTsUtc,
    departureTzOffsetMinutes:
        departureTzOffsetMinutes ?? this.departureTzOffsetMinutes,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    radiusM: radiusM.present ? radiusM.value : this.radiusM,
    externalPlaceRef: externalPlaceRef.present
        ? externalPlaceRef.value
        : this.externalPlaceRef,
    placeId: placeId.present ? placeId.value : this.placeId,
    detectionConfidence: detectionConfidence.present
        ? detectionConfidence.value
        : this.detectionConfidence,
    sourceKind: sourceKind ?? this.sourceKind,
  );
  Visit copyWithCompanion(VisitsCompanion data) {
    return Visit(
      id: data.id.present ? data.id.value : this.id,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      arrivalTsUtc: data.arrivalTsUtc.present
          ? data.arrivalTsUtc.value
          : this.arrivalTsUtc,
      arrivalTzOffsetMinutes: data.arrivalTzOffsetMinutes.present
          ? data.arrivalTzOffsetMinutes.value
          : this.arrivalTzOffsetMinutes,
      departureTsUtc: data.departureTsUtc.present
          ? data.departureTsUtc.value
          : this.departureTsUtc,
      departureTzOffsetMinutes: data.departureTzOffsetMinutes.present
          ? data.departureTzOffsetMinutes.value
          : this.departureTzOffsetMinutes,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      radiusM: data.radiusM.present ? data.radiusM.value : this.radiusM,
      externalPlaceRef: data.externalPlaceRef.present
          ? data.externalPlaceRef.value
          : this.externalPlaceRef,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      detectionConfidence: data.detectionConfidence.present
          ? data.detectionConfidence.value
          : this.detectionConfidence,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Visit(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('arrivalTsUtc: $arrivalTsUtc, ')
          ..write('arrivalTzOffsetMinutes: $arrivalTzOffsetMinutes, ')
          ..write('departureTsUtc: $departureTsUtc, ')
          ..write('departureTzOffsetMinutes: $departureTzOffsetMinutes, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('radiusM: $radiusM, ')
          ..write('externalPlaceRef: $externalPlaceRef, ')
          ..write('placeId: $placeId, ')
          ..write('detectionConfidence: $detectionConfidence, ')
          ..write('sourceKind: $sourceKind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    batchId,
    arrivalTsUtc,
    arrivalTzOffsetMinutes,
    departureTsUtc,
    departureTzOffsetMinutes,
    lat,
    lon,
    radiusM,
    externalPlaceRef,
    placeId,
    detectionConfidence,
    sourceKind,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Visit &&
          other.id == this.id &&
          other.batchId == this.batchId &&
          other.arrivalTsUtc == this.arrivalTsUtc &&
          other.arrivalTzOffsetMinutes == this.arrivalTzOffsetMinutes &&
          other.departureTsUtc == this.departureTsUtc &&
          other.departureTzOffsetMinutes == this.departureTzOffsetMinutes &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.radiusM == this.radiusM &&
          other.externalPlaceRef == this.externalPlaceRef &&
          other.placeId == this.placeId &&
          other.detectionConfidence == this.detectionConfidence &&
          other.sourceKind == this.sourceKind);
}

class VisitsCompanion extends UpdateCompanion<Visit> {
  final Value<int> id;
  final Value<int> batchId;
  final Value<int> arrivalTsUtc;
  final Value<int> arrivalTzOffsetMinutes;
  final Value<int> departureTsUtc;
  final Value<int> departureTzOffsetMinutes;
  final Value<double> lat;
  final Value<double> lon;
  final Value<double?> radiusM;
  final Value<String?> externalPlaceRef;
  final Value<int?> placeId;
  final Value<double?> detectionConfidence;
  final Value<String> sourceKind;
  const VisitsCompanion({
    this.id = const Value.absent(),
    this.batchId = const Value.absent(),
    this.arrivalTsUtc = const Value.absent(),
    this.arrivalTzOffsetMinutes = const Value.absent(),
    this.departureTsUtc = const Value.absent(),
    this.departureTzOffsetMinutes = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.radiusM = const Value.absent(),
    this.externalPlaceRef = const Value.absent(),
    this.placeId = const Value.absent(),
    this.detectionConfidence = const Value.absent(),
    this.sourceKind = const Value.absent(),
  });
  VisitsCompanion.insert({
    this.id = const Value.absent(),
    required int batchId,
    required int arrivalTsUtc,
    required int arrivalTzOffsetMinutes,
    required int departureTsUtc,
    required int departureTzOffsetMinutes,
    required double lat,
    required double lon,
    this.radiusM = const Value.absent(),
    this.externalPlaceRef = const Value.absent(),
    this.placeId = const Value.absent(),
    this.detectionConfidence = const Value.absent(),
    required String sourceKind,
  }) : batchId = Value(batchId),
       arrivalTsUtc = Value(arrivalTsUtc),
       arrivalTzOffsetMinutes = Value(arrivalTzOffsetMinutes),
       departureTsUtc = Value(departureTsUtc),
       departureTzOffsetMinutes = Value(departureTzOffsetMinutes),
       lat = Value(lat),
       lon = Value(lon),
       sourceKind = Value(sourceKind);
  static Insertable<Visit> custom({
    Expression<int>? id,
    Expression<int>? batchId,
    Expression<int>? arrivalTsUtc,
    Expression<int>? arrivalTzOffsetMinutes,
    Expression<int>? departureTsUtc,
    Expression<int>? departureTzOffsetMinutes,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<double>? radiusM,
    Expression<String>? externalPlaceRef,
    Expression<int>? placeId,
    Expression<double>? detectionConfidence,
    Expression<String>? sourceKind,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (batchId != null) 'batch_id': batchId,
      if (arrivalTsUtc != null) 'arrival_ts_utc': arrivalTsUtc,
      if (arrivalTzOffsetMinutes != null)
        'arrival_tz_offset_minutes': arrivalTzOffsetMinutes,
      if (departureTsUtc != null) 'departure_ts_utc': departureTsUtc,
      if (departureTzOffsetMinutes != null)
        'departure_tz_offset_minutes': departureTzOffsetMinutes,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (radiusM != null) 'radius_m': radiusM,
      if (externalPlaceRef != null) 'external_place_ref': externalPlaceRef,
      if (placeId != null) 'place_id': placeId,
      if (detectionConfidence != null)
        'detection_confidence': detectionConfidence,
      if (sourceKind != null) 'source_kind': sourceKind,
    });
  }

  VisitsCompanion copyWith({
    Value<int>? id,
    Value<int>? batchId,
    Value<int>? arrivalTsUtc,
    Value<int>? arrivalTzOffsetMinutes,
    Value<int>? departureTsUtc,
    Value<int>? departureTzOffsetMinutes,
    Value<double>? lat,
    Value<double>? lon,
    Value<double?>? radiusM,
    Value<String?>? externalPlaceRef,
    Value<int?>? placeId,
    Value<double?>? detectionConfidence,
    Value<String>? sourceKind,
  }) {
    return VisitsCompanion(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      arrivalTsUtc: arrivalTsUtc ?? this.arrivalTsUtc,
      arrivalTzOffsetMinutes:
          arrivalTzOffsetMinutes ?? this.arrivalTzOffsetMinutes,
      departureTsUtc: departureTsUtc ?? this.departureTsUtc,
      departureTzOffsetMinutes:
          departureTzOffsetMinutes ?? this.departureTzOffsetMinutes,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      radiusM: radiusM ?? this.radiusM,
      externalPlaceRef: externalPlaceRef ?? this.externalPlaceRef,
      placeId: placeId ?? this.placeId,
      detectionConfidence: detectionConfidence ?? this.detectionConfidence,
      sourceKind: sourceKind ?? this.sourceKind,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<int>(batchId.value);
    }
    if (arrivalTsUtc.present) {
      map['arrival_ts_utc'] = Variable<int>(arrivalTsUtc.value);
    }
    if (arrivalTzOffsetMinutes.present) {
      map['arrival_tz_offset_minutes'] = Variable<int>(
        arrivalTzOffsetMinutes.value,
      );
    }
    if (departureTsUtc.present) {
      map['departure_ts_utc'] = Variable<int>(departureTsUtc.value);
    }
    if (departureTzOffsetMinutes.present) {
      map['departure_tz_offset_minutes'] = Variable<int>(
        departureTzOffsetMinutes.value,
      );
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (radiusM.present) {
      map['radius_m'] = Variable<double>(radiusM.value);
    }
    if (externalPlaceRef.present) {
      map['external_place_ref'] = Variable<String>(externalPlaceRef.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<int>(placeId.value);
    }
    if (detectionConfidence.present) {
      map['detection_confidence'] = Variable<double>(detectionConfidence.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitsCompanion(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('arrivalTsUtc: $arrivalTsUtc, ')
          ..write('arrivalTzOffsetMinutes: $arrivalTzOffsetMinutes, ')
          ..write('departureTsUtc: $departureTsUtc, ')
          ..write('departureTzOffsetMinutes: $departureTzOffsetMinutes, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('radiusM: $radiusM, ')
          ..write('externalPlaceRef: $externalPlaceRef, ')
          ..write('placeId: $placeId, ')
          ..write('detectionConfidence: $detectionConfidence, ')
          ..write('sourceKind: $sourceKind')
          ..write(')'))
        .toString();
  }
}

class $UserPlacesTable extends UserPlaces
    with TableInfo<$UserPlacesTable, UserPlace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPlacesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _radiusMMeta = const VerificationMeta(
    'radiusM',
  );
  @override
  late final GeneratedColumn<double> radiusM = GeneratedColumn<double>(
    'radius_m',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    lat,
    lon,
    radiusM,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_places';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPlace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('radius_m')) {
      context.handle(
        _radiusMMeta,
        radiusM.isAcceptableOrUnknown(data['radius_m']!, _radiusMMeta),
      );
    } else if (isInserting) {
      context.missing(_radiusMMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPlace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPlace(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      radiusM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}radius_m'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserPlacesTable createAlias(String alias) {
    return $UserPlacesTable(attachedDatabase, alias);
  }
}

class UserPlace extends DataClass implements Insertable<UserPlace> {
  /// Identifiant.
  final int id;

  /// Nom donné par l'utilisateur.
  final String label;

  /// Latitude du centre.
  final double lat;

  /// Longitude du centre.
  final double lon;

  /// Rayon de rattachement, en mètres.
  final double radiusM;

  /// Création, en millisecondes UTC.
  final int createdAt;

  /// Dernière modification, en millisecondes UTC.
  final int updatedAt;
  const UserPlace({
    required this.id,
    required this.label,
    required this.lat,
    required this.lon,
    required this.radiusM,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    map['radius_m'] = Variable<double>(radiusM);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  UserPlacesCompanion toCompanion(bool nullToAbsent) {
    return UserPlacesCompanion(
      id: Value(id),
      label: Value(label),
      lat: Value(lat),
      lon: Value(lon),
      radiusM: Value(radiusM),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserPlace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPlace(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      radiusM: serializer.fromJson<double>(json['radiusM']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'radiusM': serializer.toJson<double>(radiusM),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  UserPlace copyWith({
    int? id,
    String? label,
    double? lat,
    double? lon,
    double? radiusM,
    int? createdAt,
    int? updatedAt,
  }) => UserPlace(
    id: id ?? this.id,
    label: label ?? this.label,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    radiusM: radiusM ?? this.radiusM,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserPlace copyWithCompanion(UserPlacesCompanion data) {
    return UserPlace(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      radiusM: data.radiusM.present ? data.radiusM.value : this.radiusM,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPlace(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('radiusM: $radiusM, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, label, lat, lon, radiusM, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPlace &&
          other.id == this.id &&
          other.label == this.label &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.radiusM == this.radiusM &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserPlacesCompanion extends UpdateCompanion<UserPlace> {
  final Value<int> id;
  final Value<String> label;
  final Value<double> lat;
  final Value<double> lon;
  final Value<double> radiusM;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const UserPlacesCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.radiusM = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserPlacesCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    required double lat,
    required double lon,
    required double radiusM,
    required int createdAt,
    required int updatedAt,
  }) : label = Value(label),
       lat = Value(lat),
       lon = Value(lon),
       radiusM = Value(radiusM),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserPlace> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<double>? radiusM,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (radiusM != null) 'radius_m': radiusM,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserPlacesCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<double>? lat,
    Value<double>? lon,
    Value<double>? radiusM,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return UserPlacesCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      radiusM: radiusM ?? this.radiusM,
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
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (radiusM.present) {
      map['radius_m'] = Variable<double>(radiusM.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPlacesCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('radiusM: $radiusM, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PrivateZonesTable extends PrivateZones
    with TableInfo<$PrivateZonesTable, PrivateZone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrivateZonesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shapeKindMeta = const VerificationMeta(
    'shapeKind',
  );
  @override
  late final GeneratedColumn<String> shapeKind = GeneratedColumn<String>(
    'shape_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _radiusMMeta = const VerificationMeta(
    'radiusM',
  );
  @override
  late final GeneratedColumn<double> radiusM = GeneratedColumn<double>(
    'radius_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _polygonGeojsonMeta = const VerificationMeta(
    'polygonGeojson',
  );
  @override
  late final GeneratedColumn<String> polygonGeojson = GeneratedColumn<String>(
    'polygon_geojson',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    shapeKind,
    lat,
    lon,
    radiusM,
    polygonGeojson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'private_zones';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrivateZone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('shape_kind')) {
      context.handle(
        _shapeKindMeta,
        shapeKind.isAcceptableOrUnknown(data['shape_kind']!, _shapeKindMeta),
      );
    } else if (isInserting) {
      context.missing(_shapeKindMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    }
    if (data.containsKey('radius_m')) {
      context.handle(
        _radiusMMeta,
        radiusM.isAcceptableOrUnknown(data['radius_m']!, _radiusMMeta),
      );
    }
    if (data.containsKey('polygon_geojson')) {
      context.handle(
        _polygonGeojsonMeta,
        polygonGeojson.isAcceptableOrUnknown(
          data['polygon_geojson']!,
          _polygonGeojsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrivateZone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrivateZone(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      shapeKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shape_kind'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      ),
      radiusM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}radius_m'],
      ),
      polygonGeojson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}polygon_geojson'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PrivateZonesTable createAlias(String alias) {
    return $PrivateZonesTable(attachedDatabase, alias);
  }
}

class PrivateZone extends DataClass implements Insertable<PrivateZone> {
  /// Identifiant.
  final int id;

  /// Nom donné par l'utilisateur.
  final String label;

  /// `circle` ou `polygon`.
  final String shapeKind;

  /// Latitude du centre, pour un cercle.
  final double? lat;

  /// Longitude du centre, pour un cercle.
  final double? lon;

  /// Rayon, en mètres, pour un cercle.
  final double? radiusM;

  /// Tracé GeoJSON, pour un polygone.
  final String? polygonGeojson;

  /// Création, en millisecondes UTC.
  final int createdAt;
  const PrivateZone({
    required this.id,
    required this.label,
    required this.shapeKind,
    this.lat,
    this.lon,
    this.radiusM,
    this.polygonGeojson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['shape_kind'] = Variable<String>(shapeKind);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lon != null) {
      map['lon'] = Variable<double>(lon);
    }
    if (!nullToAbsent || radiusM != null) {
      map['radius_m'] = Variable<double>(radiusM);
    }
    if (!nullToAbsent || polygonGeojson != null) {
      map['polygon_geojson'] = Variable<String>(polygonGeojson);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  PrivateZonesCompanion toCompanion(bool nullToAbsent) {
    return PrivateZonesCompanion(
      id: Value(id),
      label: Value(label),
      shapeKind: Value(shapeKind),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lon: lon == null && nullToAbsent ? const Value.absent() : Value(lon),
      radiusM: radiusM == null && nullToAbsent
          ? const Value.absent()
          : Value(radiusM),
      polygonGeojson: polygonGeojson == null && nullToAbsent
          ? const Value.absent()
          : Value(polygonGeojson),
      createdAt: Value(createdAt),
    );
  }

  factory PrivateZone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrivateZone(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      shapeKind: serializer.fromJson<String>(json['shapeKind']),
      lat: serializer.fromJson<double?>(json['lat']),
      lon: serializer.fromJson<double?>(json['lon']),
      radiusM: serializer.fromJson<double?>(json['radiusM']),
      polygonGeojson: serializer.fromJson<String?>(json['polygonGeojson']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'shapeKind': serializer.toJson<String>(shapeKind),
      'lat': serializer.toJson<double?>(lat),
      'lon': serializer.toJson<double?>(lon),
      'radiusM': serializer.toJson<double?>(radiusM),
      'polygonGeojson': serializer.toJson<String?>(polygonGeojson),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  PrivateZone copyWith({
    int? id,
    String? label,
    String? shapeKind,
    Value<double?> lat = const Value.absent(),
    Value<double?> lon = const Value.absent(),
    Value<double?> radiusM = const Value.absent(),
    Value<String?> polygonGeojson = const Value.absent(),
    int? createdAt,
  }) => PrivateZone(
    id: id ?? this.id,
    label: label ?? this.label,
    shapeKind: shapeKind ?? this.shapeKind,
    lat: lat.present ? lat.value : this.lat,
    lon: lon.present ? lon.value : this.lon,
    radiusM: radiusM.present ? radiusM.value : this.radiusM,
    polygonGeojson: polygonGeojson.present
        ? polygonGeojson.value
        : this.polygonGeojson,
    createdAt: createdAt ?? this.createdAt,
  );
  PrivateZone copyWithCompanion(PrivateZonesCompanion data) {
    return PrivateZone(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      shapeKind: data.shapeKind.present ? data.shapeKind.value : this.shapeKind,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      radiusM: data.radiusM.present ? data.radiusM.value : this.radiusM,
      polygonGeojson: data.polygonGeojson.present
          ? data.polygonGeojson.value
          : this.polygonGeojson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrivateZone(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('shapeKind: $shapeKind, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('radiusM: $radiusM, ')
          ..write('polygonGeojson: $polygonGeojson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    shapeKind,
    lat,
    lon,
    radiusM,
    polygonGeojson,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrivateZone &&
          other.id == this.id &&
          other.label == this.label &&
          other.shapeKind == this.shapeKind &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.radiusM == this.radiusM &&
          other.polygonGeojson == this.polygonGeojson &&
          other.createdAt == this.createdAt);
}

class PrivateZonesCompanion extends UpdateCompanion<PrivateZone> {
  final Value<int> id;
  final Value<String> label;
  final Value<String> shapeKind;
  final Value<double?> lat;
  final Value<double?> lon;
  final Value<double?> radiusM;
  final Value<String?> polygonGeojson;
  final Value<int> createdAt;
  const PrivateZonesCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.shapeKind = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.radiusM = const Value.absent(),
    this.polygonGeojson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PrivateZonesCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    required String shapeKind,
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.radiusM = const Value.absent(),
    this.polygonGeojson = const Value.absent(),
    required int createdAt,
  }) : label = Value(label),
       shapeKind = Value(shapeKind),
       createdAt = Value(createdAt);
  static Insertable<PrivateZone> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<String>? shapeKind,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<double>? radiusM,
    Expression<String>? polygonGeojson,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (shapeKind != null) 'shape_kind': shapeKind,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (radiusM != null) 'radius_m': radiusM,
      if (polygonGeojson != null) 'polygon_geojson': polygonGeojson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PrivateZonesCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<String>? shapeKind,
    Value<double?>? lat,
    Value<double?>? lon,
    Value<double?>? radiusM,
    Value<String?>? polygonGeojson,
    Value<int>? createdAt,
  }) {
    return PrivateZonesCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      shapeKind: shapeKind ?? this.shapeKind,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      radiusM: radiusM ?? this.radiusM,
      polygonGeojson: polygonGeojson ?? this.polygonGeojson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (shapeKind.present) {
      map['shape_kind'] = Variable<String>(shapeKind.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (radiusM.present) {
      map['radius_m'] = Variable<double>(radiusM.value);
    }
    if (polygonGeojson.present) {
      map['polygon_geojson'] = Variable<String>(polygonGeojson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrivateZonesCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('shapeKind: $shapeKind, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('radiusM: $radiusM, ')
          ..write('polygonGeojson: $polygonGeojson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserSegmentOverridesTable extends UserSegmentOverrides
    with TableInfo<$UserSegmentOverridesTable, UserSegmentOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSegmentOverridesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<int> localDate = GeneratedColumn<int>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startLatRMeta = const VerificationMeta(
    'startLatR',
  );
  @override
  late final GeneratedColumn<double> startLatR = GeneratedColumn<double>(
    'start_lat_r',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startLonRMeta = const VerificationMeta(
    'startLonR',
  );
  @override
  late final GeneratedColumn<double> startLonR = GeneratedColumn<double>(
    'start_lon_r',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endLatRMeta = const VerificationMeta(
    'endLatR',
  );
  @override
  late final GeneratedColumn<double> endLatR = GeneratedColumn<double>(
    'end_lat_r',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endLonRMeta = const VerificationMeta(
    'endLonR',
  );
  @override
  late final GeneratedColumn<double> endLonR = GeneratedColumn<double>(
    'end_lon_r',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctedModeMeta = const VerificationMeta(
    'correctedMode',
  );
  @override
  late final GeneratedColumn<String> correctedMode = GeneratedColumn<String>(
    'corrected_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceStartTsUtcMeta = const VerificationMeta(
    'sourceStartTsUtc',
  );
  @override
  late final GeneratedColumn<int> sourceStartTsUtc = GeneratedColumn<int>(
    'source_start_ts_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localDate,
    startLatR,
    startLonR,
    endLatR,
    endLonR,
    correctedMode,
    sourceStartTsUtc,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_segment_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSegmentOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('start_lat_r')) {
      context.handle(
        _startLatRMeta,
        startLatR.isAcceptableOrUnknown(data['start_lat_r']!, _startLatRMeta),
      );
    } else if (isInserting) {
      context.missing(_startLatRMeta);
    }
    if (data.containsKey('start_lon_r')) {
      context.handle(
        _startLonRMeta,
        startLonR.isAcceptableOrUnknown(data['start_lon_r']!, _startLonRMeta),
      );
    } else if (isInserting) {
      context.missing(_startLonRMeta);
    }
    if (data.containsKey('end_lat_r')) {
      context.handle(
        _endLatRMeta,
        endLatR.isAcceptableOrUnknown(data['end_lat_r']!, _endLatRMeta),
      );
    } else if (isInserting) {
      context.missing(_endLatRMeta);
    }
    if (data.containsKey('end_lon_r')) {
      context.handle(
        _endLonRMeta,
        endLonR.isAcceptableOrUnknown(data['end_lon_r']!, _endLonRMeta),
      );
    } else if (isInserting) {
      context.missing(_endLonRMeta);
    }
    if (data.containsKey('corrected_mode')) {
      context.handle(
        _correctedModeMeta,
        correctedMode.isAcceptableOrUnknown(
          data['corrected_mode']!,
          _correctedModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctedModeMeta);
    }
    if (data.containsKey('source_start_ts_utc')) {
      context.handle(
        _sourceStartTsUtcMeta,
        sourceStartTsUtc.isAcceptableOrUnknown(
          data['source_start_ts_utc']!,
          _sourceStartTsUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceStartTsUtcMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSegmentOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSegmentOverride(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_date'],
      )!,
      startLatR: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_lat_r'],
      )!,
      startLonR: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_lon_r'],
      )!,
      endLatR: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}end_lat_r'],
      )!,
      endLonR: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}end_lon_r'],
      )!,
      correctedMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}corrected_mode'],
      )!,
      sourceStartTsUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_start_ts_utc'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserSegmentOverridesTable createAlias(String alias) {
    return $UserSegmentOverridesTable(attachedDatabase, alias);
  }
}

class UserSegmentOverride extends DataClass
    implements Insertable<UserSegmentOverride> {
  /// Identifiant.
  final int id;

  /// Date locale du trajet corrigé, en jours depuis l'epoch.
  final int localDate;

  /// Latitude de départ arrondie.
  final double startLatR;

  /// Longitude de départ arrondie.
  final double startLonR;

  /// Latitude d'arrivée arrondie.
  final double endLatR;

  /// Longitude d'arrivée arrondie.
  final double endLonR;

  /// Mode corrigé par l'utilisateur.
  final String correctedMode;

  /// Début du segment au moment de la correction.
  ///
  /// Ne fait pas partie de la clé d'appariement : sert uniquement à départager
  /// plusieurs segments de même empreinte le même jour (§4).
  final int sourceStartTsUtc;

  /// Création, en millisecondes UTC.
  final int createdAt;
  const UserSegmentOverride({
    required this.id,
    required this.localDate,
    required this.startLatR,
    required this.startLonR,
    required this.endLatR,
    required this.endLonR,
    required this.correctedMode,
    required this.sourceStartTsUtc,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_date'] = Variable<int>(localDate);
    map['start_lat_r'] = Variable<double>(startLatR);
    map['start_lon_r'] = Variable<double>(startLonR);
    map['end_lat_r'] = Variable<double>(endLatR);
    map['end_lon_r'] = Variable<double>(endLonR);
    map['corrected_mode'] = Variable<String>(correctedMode);
    map['source_start_ts_utc'] = Variable<int>(sourceStartTsUtc);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  UserSegmentOverridesCompanion toCompanion(bool nullToAbsent) {
    return UserSegmentOverridesCompanion(
      id: Value(id),
      localDate: Value(localDate),
      startLatR: Value(startLatR),
      startLonR: Value(startLonR),
      endLatR: Value(endLatR),
      endLonR: Value(endLonR),
      correctedMode: Value(correctedMode),
      sourceStartTsUtc: Value(sourceStartTsUtc),
      createdAt: Value(createdAt),
    );
  }

  factory UserSegmentOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSegmentOverride(
      id: serializer.fromJson<int>(json['id']),
      localDate: serializer.fromJson<int>(json['localDate']),
      startLatR: serializer.fromJson<double>(json['startLatR']),
      startLonR: serializer.fromJson<double>(json['startLonR']),
      endLatR: serializer.fromJson<double>(json['endLatR']),
      endLonR: serializer.fromJson<double>(json['endLonR']),
      correctedMode: serializer.fromJson<String>(json['correctedMode']),
      sourceStartTsUtc: serializer.fromJson<int>(json['sourceStartTsUtc']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localDate': serializer.toJson<int>(localDate),
      'startLatR': serializer.toJson<double>(startLatR),
      'startLonR': serializer.toJson<double>(startLonR),
      'endLatR': serializer.toJson<double>(endLatR),
      'endLonR': serializer.toJson<double>(endLonR),
      'correctedMode': serializer.toJson<String>(correctedMode),
      'sourceStartTsUtc': serializer.toJson<int>(sourceStartTsUtc),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  UserSegmentOverride copyWith({
    int? id,
    int? localDate,
    double? startLatR,
    double? startLonR,
    double? endLatR,
    double? endLonR,
    String? correctedMode,
    int? sourceStartTsUtc,
    int? createdAt,
  }) => UserSegmentOverride(
    id: id ?? this.id,
    localDate: localDate ?? this.localDate,
    startLatR: startLatR ?? this.startLatR,
    startLonR: startLonR ?? this.startLonR,
    endLatR: endLatR ?? this.endLatR,
    endLonR: endLonR ?? this.endLonR,
    correctedMode: correctedMode ?? this.correctedMode,
    sourceStartTsUtc: sourceStartTsUtc ?? this.sourceStartTsUtc,
    createdAt: createdAt ?? this.createdAt,
  );
  UserSegmentOverride copyWithCompanion(UserSegmentOverridesCompanion data) {
    return UserSegmentOverride(
      id: data.id.present ? data.id.value : this.id,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      startLatR: data.startLatR.present ? data.startLatR.value : this.startLatR,
      startLonR: data.startLonR.present ? data.startLonR.value : this.startLonR,
      endLatR: data.endLatR.present ? data.endLatR.value : this.endLatR,
      endLonR: data.endLonR.present ? data.endLonR.value : this.endLonR,
      correctedMode: data.correctedMode.present
          ? data.correctedMode.value
          : this.correctedMode,
      sourceStartTsUtc: data.sourceStartTsUtc.present
          ? data.sourceStartTsUtc.value
          : this.sourceStartTsUtc,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSegmentOverride(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('startLatR: $startLatR, ')
          ..write('startLonR: $startLonR, ')
          ..write('endLatR: $endLatR, ')
          ..write('endLonR: $endLonR, ')
          ..write('correctedMode: $correctedMode, ')
          ..write('sourceStartTsUtc: $sourceStartTsUtc, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localDate,
    startLatR,
    startLonR,
    endLatR,
    endLonR,
    correctedMode,
    sourceStartTsUtc,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSegmentOverride &&
          other.id == this.id &&
          other.localDate == this.localDate &&
          other.startLatR == this.startLatR &&
          other.startLonR == this.startLonR &&
          other.endLatR == this.endLatR &&
          other.endLonR == this.endLonR &&
          other.correctedMode == this.correctedMode &&
          other.sourceStartTsUtc == this.sourceStartTsUtc &&
          other.createdAt == this.createdAt);
}

class UserSegmentOverridesCompanion
    extends UpdateCompanion<UserSegmentOverride> {
  final Value<int> id;
  final Value<int> localDate;
  final Value<double> startLatR;
  final Value<double> startLonR;
  final Value<double> endLatR;
  final Value<double> endLonR;
  final Value<String> correctedMode;
  final Value<int> sourceStartTsUtc;
  final Value<int> createdAt;
  const UserSegmentOverridesCompanion({
    this.id = const Value.absent(),
    this.localDate = const Value.absent(),
    this.startLatR = const Value.absent(),
    this.startLonR = const Value.absent(),
    this.endLatR = const Value.absent(),
    this.endLonR = const Value.absent(),
    this.correctedMode = const Value.absent(),
    this.sourceStartTsUtc = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserSegmentOverridesCompanion.insert({
    this.id = const Value.absent(),
    required int localDate,
    required double startLatR,
    required double startLonR,
    required double endLatR,
    required double endLonR,
    required String correctedMode,
    required int sourceStartTsUtc,
    required int createdAt,
  }) : localDate = Value(localDate),
       startLatR = Value(startLatR),
       startLonR = Value(startLonR),
       endLatR = Value(endLatR),
       endLonR = Value(endLonR),
       correctedMode = Value(correctedMode),
       sourceStartTsUtc = Value(sourceStartTsUtc),
       createdAt = Value(createdAt);
  static Insertable<UserSegmentOverride> custom({
    Expression<int>? id,
    Expression<int>? localDate,
    Expression<double>? startLatR,
    Expression<double>? startLonR,
    Expression<double>? endLatR,
    Expression<double>? endLonR,
    Expression<String>? correctedMode,
    Expression<int>? sourceStartTsUtc,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localDate != null) 'local_date': localDate,
      if (startLatR != null) 'start_lat_r': startLatR,
      if (startLonR != null) 'start_lon_r': startLonR,
      if (endLatR != null) 'end_lat_r': endLatR,
      if (endLonR != null) 'end_lon_r': endLonR,
      if (correctedMode != null) 'corrected_mode': correctedMode,
      if (sourceStartTsUtc != null) 'source_start_ts_utc': sourceStartTsUtc,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserSegmentOverridesCompanion copyWith({
    Value<int>? id,
    Value<int>? localDate,
    Value<double>? startLatR,
    Value<double>? startLonR,
    Value<double>? endLatR,
    Value<double>? endLonR,
    Value<String>? correctedMode,
    Value<int>? sourceStartTsUtc,
    Value<int>? createdAt,
  }) {
    return UserSegmentOverridesCompanion(
      id: id ?? this.id,
      localDate: localDate ?? this.localDate,
      startLatR: startLatR ?? this.startLatR,
      startLonR: startLonR ?? this.startLonR,
      endLatR: endLatR ?? this.endLatR,
      endLonR: endLonR ?? this.endLonR,
      correctedMode: correctedMode ?? this.correctedMode,
      sourceStartTsUtc: sourceStartTsUtc ?? this.sourceStartTsUtc,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<int>(localDate.value);
    }
    if (startLatR.present) {
      map['start_lat_r'] = Variable<double>(startLatR.value);
    }
    if (startLonR.present) {
      map['start_lon_r'] = Variable<double>(startLonR.value);
    }
    if (endLatR.present) {
      map['end_lat_r'] = Variable<double>(endLatR.value);
    }
    if (endLonR.present) {
      map['end_lon_r'] = Variable<double>(endLonR.value);
    }
    if (correctedMode.present) {
      map['corrected_mode'] = Variable<String>(correctedMode.value);
    }
    if (sourceStartTsUtc.present) {
      map['source_start_ts_utc'] = Variable<int>(sourceStartTsUtc.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSegmentOverridesCompanion(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('startLatR: $startLatR, ')
          ..write('startLonR: $startLonR, ')
          ..write('endLatR: $endLatR, ')
          ..write('endLonR: $endLonR, ')
          ..write('correctedMode: $correctedMode, ')
          ..write('sourceStartTsUtc: $sourceStartTsUtc, ')
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
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingValueMeta = const VerificationMeta(
    'settingValue',
  );
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
    'setting_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue];
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
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
        _settingValueMeta,
        settingValue.isAcceptableOrUnknown(
          data['setting_value']!,
          _settingValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      settingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  /// Clé du réglage.
  final String settingKey;

  /// Valeur sérialisée.
  final String settingValue;
  const AppSetting({required this.settingKey, required this.settingValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
    };
  }

  AppSetting copyWith({String? settingKey, String? settingValue}) => AppSetting(
    settingKey: settingKey ?? this.settingKey,
    settingValue: settingValue ?? this.settingValue,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String settingKey,
    required String settingValue,
    this.rowid = const Value.absent(),
  }) : settingKey = Value(settingKey),
       settingValue = Value(settingValue);
  static Insertable<AppSetting> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? settingKey,
    Value<String>? settingValue,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$OdysseiaDatabase extends GeneratedDatabase {
  _$OdysseiaDatabase(QueryExecutor e) : super(e);
  $OdysseiaDatabaseManager get managers => $OdysseiaDatabaseManager(this);
  late final $ImportBatchesTable importBatches = $ImportBatchesTable(this);
  late final $RawPointsTable rawPoints = $RawPointsTable(this);
  late final $SegmentsTable segments = $SegmentsTable(this);
  late final $GeoPlacesTable geoPlaces = $GeoPlacesTable(this);
  late final $VisitsTable visits = $VisitsTable(this);
  late final $UserPlacesTable userPlaces = $UserPlacesTable(this);
  late final $PrivateZonesTable privateZones = $PrivateZonesTable(this);
  late final $UserSegmentOverridesTable userSegmentOverrides =
      $UserSegmentOverridesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final Index rawPointTime = Index(
    'raw_point_time',
    'CREATE INDEX raw_point_time ON raw_points (timestamp_utc)',
  );
  late final Index rawPointSpace = Index(
    'raw_point_space',
    'CREATE INDEX raw_point_space ON raw_points (lat, lon)',
  );
  late final Index segmentTime = Index(
    'segment_time',
    'CREATE INDEX segment_time ON segments (start_ts_utc)',
  );
  late final Index visitTime = Index(
    'visit_time',
    'CREATE INDEX visit_time ON visits (arrival_ts_utc)',
  );
  late final Index visitSpace = Index(
    'visit_space',
    'CREATE INDEX visit_space ON visits (lat, lon)',
  );
  late final Index userPlaceSpace = Index(
    'user_place_space',
    'CREATE INDEX user_place_space ON user_places (lat, lon)',
  );
  late final Index overrideFingerprint = Index(
    'override_fingerprint',
    'CREATE INDEX override_fingerprint ON user_segment_overrides (local_date)',
  );
  late final Index geoPlaceSpace = Index(
    'geo_place_space',
    'CREATE INDEX geo_place_space ON geo_places (lat, lon)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    importBatches,
    rawPoints,
    segments,
    geoPlaces,
    visits,
    userPlaces,
    privateZones,
    userSegmentOverrides,
    appSettings,
    rawPointTime,
    rawPointSpace,
    segmentTime,
    visitTime,
    visitSpace,
    userPlaceSpace,
    overrideFingerprint,
    geoPlaceSpace,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'import_batches',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('raw_points', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'import_batches',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('segments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'import_batches',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('visits', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ImportBatchesTableCreateCompanionBuilder =
    ImportBatchesCompanion Function({
      Value<int> id,
      required int importedAt,
      required String sourceKind,
      required String sourceFilePath,
      required String sourceFormatDetected,
      Value<int?> periodStart,
      Value<int?> periodEnd,
      Value<int> pointCount,
    });
typedef $$ImportBatchesTableUpdateCompanionBuilder =
    ImportBatchesCompanion Function({
      Value<int> id,
      Value<int> importedAt,
      Value<String> sourceKind,
      Value<String> sourceFilePath,
      Value<String> sourceFormatDetected,
      Value<int?> periodStart,
      Value<int?> periodEnd,
      Value<int> pointCount,
    });

final class $$ImportBatchesTableReferences
    extends
        BaseReferences<_$OdysseiaDatabase, $ImportBatchesTable, ImportBatch> {
  $$ImportBatchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$RawPointsTable, List<RawPoint>>
  _rawPointsRefsTable(_$OdysseiaDatabase db) => MultiTypedResultKey.fromTable(
    db.rawPoints,
    aliasName: 'import_batches__id__raw_points__batch_id',
  );

  $$RawPointsTableProcessedTableManager get rawPointsRefs {
    final manager = $$RawPointsTableTableManager(
      $_db,
      $_db.rawPoints,
    ).filter((f) => f.batchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rawPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SegmentsTable, List<Segment>> _segmentsRefsTable(
    _$OdysseiaDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.segments,
    aliasName: 'import_batches__id__segments__batch_id',
  );

  $$SegmentsTableProcessedTableManager get segmentsRefs {
    final manager = $$SegmentsTableTableManager(
      $_db,
      $_db.segments,
    ).filter((f) => f.batchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_segmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VisitsTable, List<Visit>> _visitsRefsTable(
    _$OdysseiaDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.visits,
    aliasName: 'import_batches__id__visits__batch_id',
  );

  $$VisitsTableProcessedTableManager get visitsRefs {
    final manager = $$VisitsTableTableManager(
      $_db,
      $_db.visits,
    ).filter((f) => f.batchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_visitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ImportBatchesTableFilterComposer
    extends Composer<_$OdysseiaDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableFilterComposer({
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

  ColumnFilters<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceFilePath => $composableBuilder(
    column: $table.sourceFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceFormatDetected => $composableBuilder(
    column: $table.sourceFormatDetected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> rawPointsRefs(
    Expression<bool> Function($$RawPointsTableFilterComposer f) f,
  ) {
    final $$RawPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rawPoints,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RawPointsTableFilterComposer(
            $db: $db,
            $table: $db.rawPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> segmentsRefs(
    Expression<bool> Function($$SegmentsTableFilterComposer f) f,
  ) {
    final $$SegmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.segments,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SegmentsTableFilterComposer(
            $db: $db,
            $table: $db.segments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> visitsRefs(
    Expression<bool> Function($$VisitsTableFilterComposer f) f,
  ) {
    final $$VisitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableFilterComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportBatchesTableOrderingComposer
    extends Composer<_$OdysseiaDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableOrderingComposer({
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

  ColumnOrderings<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceFilePath => $composableBuilder(
    column: $table.sourceFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceFormatDetected => $composableBuilder(
    column: $table.sourceFormatDetected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportBatchesTableAnnotationComposer
    extends Composer<_$OdysseiaDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceFilePath => $composableBuilder(
    column: $table.sourceFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceFormatDetected => $composableBuilder(
    column: $table.sourceFormatDetected,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => column,
  );

  Expression<T> rawPointsRefs<T extends Object>(
    Expression<T> Function($$RawPointsTableAnnotationComposer a) f,
  ) {
    final $$RawPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rawPoints,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RawPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.rawPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> segmentsRefs<T extends Object>(
    Expression<T> Function($$SegmentsTableAnnotationComposer a) f,
  ) {
    final $$SegmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.segments,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SegmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.segments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> visitsRefs<T extends Object>(
    Expression<T> Function($$VisitsTableAnnotationComposer a) f,
  ) {
    final $$VisitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableAnnotationComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportBatchesTableTableManager
    extends
        RootTableManager<
          _$OdysseiaDatabase,
          $ImportBatchesTable,
          ImportBatch,
          $$ImportBatchesTableFilterComposer,
          $$ImportBatchesTableOrderingComposer,
          $$ImportBatchesTableAnnotationComposer,
          $$ImportBatchesTableCreateCompanionBuilder,
          $$ImportBatchesTableUpdateCompanionBuilder,
          (ImportBatch, $$ImportBatchesTableReferences),
          ImportBatch,
          PrefetchHooks Function({
            bool rawPointsRefs,
            bool segmentsRefs,
            bool visitsRefs,
          })
        > {
  $$ImportBatchesTableTableManager(
    _$OdysseiaDatabase db,
    $ImportBatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> importedAt = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
                Value<String> sourceFilePath = const Value.absent(),
                Value<String> sourceFormatDetected = const Value.absent(),
                Value<int?> periodStart = const Value.absent(),
                Value<int?> periodEnd = const Value.absent(),
                Value<int> pointCount = const Value.absent(),
              }) => ImportBatchesCompanion(
                id: id,
                importedAt: importedAt,
                sourceKind: sourceKind,
                sourceFilePath: sourceFilePath,
                sourceFormatDetected: sourceFormatDetected,
                periodStart: periodStart,
                periodEnd: periodEnd,
                pointCount: pointCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int importedAt,
                required String sourceKind,
                required String sourceFilePath,
                required String sourceFormatDetected,
                Value<int?> periodStart = const Value.absent(),
                Value<int?> periodEnd = const Value.absent(),
                Value<int> pointCount = const Value.absent(),
              }) => ImportBatchesCompanion.insert(
                id: id,
                importedAt: importedAt,
                sourceKind: sourceKind,
                sourceFilePath: sourceFilePath,
                sourceFormatDetected: sourceFormatDetected,
                periodStart: periodStart,
                periodEnd: periodEnd,
                pointCount: pointCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ImportBatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                rawPointsRefs = false,
                segmentsRefs = false,
                visitsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (rawPointsRefs) db.rawPoints,
                    if (segmentsRefs) db.segments,
                    if (visitsRefs) db.visits,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (rawPointsRefs)
                        await $_getPrefetchedData<
                          ImportBatch,
                          $ImportBatchesTable,
                          RawPoint
                        >(
                          currentTable: table,
                          referencedTable: $$ImportBatchesTableReferences
                              ._rawPointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ImportBatchesTableReferences(
                                db,
                                table,
                                p0,
                              ).rawPointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.batchId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (segmentsRefs)
                        await $_getPrefetchedData<
                          ImportBatch,
                          $ImportBatchesTable,
                          Segment
                        >(
                          currentTable: table,
                          referencedTable: $$ImportBatchesTableReferences
                              ._segmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ImportBatchesTableReferences(
                                db,
                                table,
                                p0,
                              ).segmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.batchId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (visitsRefs)
                        await $_getPrefetchedData<
                          ImportBatch,
                          $ImportBatchesTable,
                          Visit
                        >(
                          currentTable: table,
                          referencedTable: $$ImportBatchesTableReferences
                              ._visitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ImportBatchesTableReferences(
                                db,
                                table,
                                p0,
                              ).visitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.batchId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ImportBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$OdysseiaDatabase,
      $ImportBatchesTable,
      ImportBatch,
      $$ImportBatchesTableFilterComposer,
      $$ImportBatchesTableOrderingComposer,
      $$ImportBatchesTableAnnotationComposer,
      $$ImportBatchesTableCreateCompanionBuilder,
      $$ImportBatchesTableUpdateCompanionBuilder,
      (ImportBatch, $$ImportBatchesTableReferences),
      ImportBatch,
      PrefetchHooks Function({
        bool rawPointsRefs,
        bool segmentsRefs,
        bool visitsRefs,
      })
    >;
typedef $$RawPointsTableCreateCompanionBuilder =
    RawPointsCompanion Function({
      Value<int> id,
      required int batchId,
      required int timestampUtc,
      required int tzOffsetMinutes,
      required double lat,
      required double lon,
      Value<double?> accuracyM,
      Value<double?> altitudeM,
      Value<double?> speedMs,
      required String sourceKind,
    });
typedef $$RawPointsTableUpdateCompanionBuilder =
    RawPointsCompanion Function({
      Value<int> id,
      Value<int> batchId,
      Value<int> timestampUtc,
      Value<int> tzOffsetMinutes,
      Value<double> lat,
      Value<double> lon,
      Value<double?> accuracyM,
      Value<double?> altitudeM,
      Value<double?> speedMs,
      Value<String> sourceKind,
    });

final class $$RawPointsTableReferences
    extends BaseReferences<_$OdysseiaDatabase, $RawPointsTable, RawPoint> {
  $$RawPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ImportBatchesTable _batchIdTable(_$OdysseiaDatabase db) =>
      db.importBatches.createAlias('raw_points__batch_id__import_batches__id');

  $$ImportBatchesTableProcessedTableManager get batchId {
    final $_column = $_itemColumn<int>('batch_id')!;

    final manager = $$ImportBatchesTableTableManager(
      $_db,
      $_db.importBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RawPointsTableFilterComposer
    extends Composer<_$OdysseiaDatabase, $RawPointsTable> {
  $$RawPointsTableFilterComposer({
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

  ColumnFilters<int> get timestampUtc => $composableBuilder(
    column: $table.timestampUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tzOffsetMinutes => $composableBuilder(
    column: $table.tzOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyM => $composableBuilder(
    column: $table.accuracyM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitudeM => $composableBuilder(
    column: $table.altitudeM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedMs => $composableBuilder(
    column: $table.speedMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnFilters(column),
  );

  $$ImportBatchesTableFilterComposer get batchId {
    final $$ImportBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableFilterComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RawPointsTableOrderingComposer
    extends Composer<_$OdysseiaDatabase, $RawPointsTable> {
  $$RawPointsTableOrderingComposer({
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

  ColumnOrderings<int> get timestampUtc => $composableBuilder(
    column: $table.timestampUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tzOffsetMinutes => $composableBuilder(
    column: $table.tzOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyM => $composableBuilder(
    column: $table.accuracyM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitudeM => $composableBuilder(
    column: $table.altitudeM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedMs => $composableBuilder(
    column: $table.speedMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnOrderings(column),
  );

  $$ImportBatchesTableOrderingComposer get batchId {
    final $$ImportBatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableOrderingComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RawPointsTableAnnotationComposer
    extends Composer<_$OdysseiaDatabase, $RawPointsTable> {
  $$RawPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get timestampUtc => $composableBuilder(
    column: $table.timestampUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tzOffsetMinutes => $composableBuilder(
    column: $table.tzOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<double> get accuracyM =>
      $composableBuilder(column: $table.accuracyM, builder: (column) => column);

  GeneratedColumn<double> get altitudeM =>
      $composableBuilder(column: $table.altitudeM, builder: (column) => column);

  GeneratedColumn<double> get speedMs =>
      $composableBuilder(column: $table.speedMs, builder: (column) => column);

  GeneratedColumn<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => column,
  );

  $$ImportBatchesTableAnnotationComposer get batchId {
    final $$ImportBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RawPointsTableTableManager
    extends
        RootTableManager<
          _$OdysseiaDatabase,
          $RawPointsTable,
          RawPoint,
          $$RawPointsTableFilterComposer,
          $$RawPointsTableOrderingComposer,
          $$RawPointsTableAnnotationComposer,
          $$RawPointsTableCreateCompanionBuilder,
          $$RawPointsTableUpdateCompanionBuilder,
          (RawPoint, $$RawPointsTableReferences),
          RawPoint,
          PrefetchHooks Function({bool batchId})
        > {
  $$RawPointsTableTableManager(_$OdysseiaDatabase db, $RawPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RawPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RawPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RawPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> batchId = const Value.absent(),
                Value<int> timestampUtc = const Value.absent(),
                Value<int> tzOffsetMinutes = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<double?> accuracyM = const Value.absent(),
                Value<double?> altitudeM = const Value.absent(),
                Value<double?> speedMs = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
              }) => RawPointsCompanion(
                id: id,
                batchId: batchId,
                timestampUtc: timestampUtc,
                tzOffsetMinutes: tzOffsetMinutes,
                lat: lat,
                lon: lon,
                accuracyM: accuracyM,
                altitudeM: altitudeM,
                speedMs: speedMs,
                sourceKind: sourceKind,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int batchId,
                required int timestampUtc,
                required int tzOffsetMinutes,
                required double lat,
                required double lon,
                Value<double?> accuracyM = const Value.absent(),
                Value<double?> altitudeM = const Value.absent(),
                Value<double?> speedMs = const Value.absent(),
                required String sourceKind,
              }) => RawPointsCompanion.insert(
                id: id,
                batchId: batchId,
                timestampUtc: timestampUtc,
                tzOffsetMinutes: tzOffsetMinutes,
                lat: lat,
                lon: lon,
                accuracyM: accuracyM,
                altitudeM: altitudeM,
                speedMs: speedMs,
                sourceKind: sourceKind,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RawPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({batchId = false}) {
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
                    if (batchId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.batchId,
                                referencedTable: $$RawPointsTableReferences
                                    ._batchIdTable(db),
                                referencedColumn: $$RawPointsTableReferences
                                    ._batchIdTable(db)
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

typedef $$RawPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$OdysseiaDatabase,
      $RawPointsTable,
      RawPoint,
      $$RawPointsTableFilterComposer,
      $$RawPointsTableOrderingComposer,
      $$RawPointsTableAnnotationComposer,
      $$RawPointsTableCreateCompanionBuilder,
      $$RawPointsTableUpdateCompanionBuilder,
      (RawPoint, $$RawPointsTableReferences),
      RawPoint,
      PrefetchHooks Function({bool batchId})
    >;
typedef $$SegmentsTableCreateCompanionBuilder =
    SegmentsCompanion Function({
      Value<int> id,
      required int batchId,
      required int startTsUtc,
      required int startTzOffsetMinutes,
      required int endTsUtc,
      required int endTzOffsetMinutes,
      required double startLat,
      required double startLon,
      required double endLat,
      required double endLon,
      Value<double?> distanceM,
      required String detectedMode,
      Value<double?> modeConfidence,
      required String sourceKind,
    });
typedef $$SegmentsTableUpdateCompanionBuilder =
    SegmentsCompanion Function({
      Value<int> id,
      Value<int> batchId,
      Value<int> startTsUtc,
      Value<int> startTzOffsetMinutes,
      Value<int> endTsUtc,
      Value<int> endTzOffsetMinutes,
      Value<double> startLat,
      Value<double> startLon,
      Value<double> endLat,
      Value<double> endLon,
      Value<double?> distanceM,
      Value<String> detectedMode,
      Value<double?> modeConfidence,
      Value<String> sourceKind,
    });

final class $$SegmentsTableReferences
    extends BaseReferences<_$OdysseiaDatabase, $SegmentsTable, Segment> {
  $$SegmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ImportBatchesTable _batchIdTable(_$OdysseiaDatabase db) =>
      db.importBatches.createAlias('segments__batch_id__import_batches__id');

  $$ImportBatchesTableProcessedTableManager get batchId {
    final $_column = $_itemColumn<int>('batch_id')!;

    final manager = $$ImportBatchesTableTableManager(
      $_db,
      $_db.importBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SegmentsTableFilterComposer
    extends Composer<_$OdysseiaDatabase, $SegmentsTable> {
  $$SegmentsTableFilterComposer({
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

  ColumnFilters<int> get startTsUtc => $composableBuilder(
    column: $table.startTsUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startTzOffsetMinutes => $composableBuilder(
    column: $table.startTzOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endTsUtc => $composableBuilder(
    column: $table.endTsUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endTzOffsetMinutes => $composableBuilder(
    column: $table.endTzOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startLat => $composableBuilder(
    column: $table.startLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startLon => $composableBuilder(
    column: $table.startLon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get endLat => $composableBuilder(
    column: $table.endLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get endLon => $composableBuilder(
    column: $table.endLon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detectedMode => $composableBuilder(
    column: $table.detectedMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get modeConfidence => $composableBuilder(
    column: $table.modeConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnFilters(column),
  );

  $$ImportBatchesTableFilterComposer get batchId {
    final $$ImportBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableFilterComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SegmentsTableOrderingComposer
    extends Composer<_$OdysseiaDatabase, $SegmentsTable> {
  $$SegmentsTableOrderingComposer({
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

  ColumnOrderings<int> get startTsUtc => $composableBuilder(
    column: $table.startTsUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startTzOffsetMinutes => $composableBuilder(
    column: $table.startTzOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endTsUtc => $composableBuilder(
    column: $table.endTsUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endTzOffsetMinutes => $composableBuilder(
    column: $table.endTzOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startLat => $composableBuilder(
    column: $table.startLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startLon => $composableBuilder(
    column: $table.startLon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get endLat => $composableBuilder(
    column: $table.endLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get endLon => $composableBuilder(
    column: $table.endLon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detectedMode => $composableBuilder(
    column: $table.detectedMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get modeConfidence => $composableBuilder(
    column: $table.modeConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnOrderings(column),
  );

  $$ImportBatchesTableOrderingComposer get batchId {
    final $$ImportBatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableOrderingComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SegmentsTableAnnotationComposer
    extends Composer<_$OdysseiaDatabase, $SegmentsTable> {
  $$SegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startTsUtc => $composableBuilder(
    column: $table.startTsUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startTzOffsetMinutes => $composableBuilder(
    column: $table.startTzOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endTsUtc =>
      $composableBuilder(column: $table.endTsUtc, builder: (column) => column);

  GeneratedColumn<int> get endTzOffsetMinutes => $composableBuilder(
    column: $table.endTzOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get startLat =>
      $composableBuilder(column: $table.startLat, builder: (column) => column);

  GeneratedColumn<double> get startLon =>
      $composableBuilder(column: $table.startLon, builder: (column) => column);

  GeneratedColumn<double> get endLat =>
      $composableBuilder(column: $table.endLat, builder: (column) => column);

  GeneratedColumn<double> get endLon =>
      $composableBuilder(column: $table.endLon, builder: (column) => column);

  GeneratedColumn<double> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<String> get detectedMode => $composableBuilder(
    column: $table.detectedMode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get modeConfidence => $composableBuilder(
    column: $table.modeConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => column,
  );

  $$ImportBatchesTableAnnotationComposer get batchId {
    final $$ImportBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SegmentsTableTableManager
    extends
        RootTableManager<
          _$OdysseiaDatabase,
          $SegmentsTable,
          Segment,
          $$SegmentsTableFilterComposer,
          $$SegmentsTableOrderingComposer,
          $$SegmentsTableAnnotationComposer,
          $$SegmentsTableCreateCompanionBuilder,
          $$SegmentsTableUpdateCompanionBuilder,
          (Segment, $$SegmentsTableReferences),
          Segment,
          PrefetchHooks Function({bool batchId})
        > {
  $$SegmentsTableTableManager(_$OdysseiaDatabase db, $SegmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SegmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SegmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> batchId = const Value.absent(),
                Value<int> startTsUtc = const Value.absent(),
                Value<int> startTzOffsetMinutes = const Value.absent(),
                Value<int> endTsUtc = const Value.absent(),
                Value<int> endTzOffsetMinutes = const Value.absent(),
                Value<double> startLat = const Value.absent(),
                Value<double> startLon = const Value.absent(),
                Value<double> endLat = const Value.absent(),
                Value<double> endLon = const Value.absent(),
                Value<double?> distanceM = const Value.absent(),
                Value<String> detectedMode = const Value.absent(),
                Value<double?> modeConfidence = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
              }) => SegmentsCompanion(
                id: id,
                batchId: batchId,
                startTsUtc: startTsUtc,
                startTzOffsetMinutes: startTzOffsetMinutes,
                endTsUtc: endTsUtc,
                endTzOffsetMinutes: endTzOffsetMinutes,
                startLat: startLat,
                startLon: startLon,
                endLat: endLat,
                endLon: endLon,
                distanceM: distanceM,
                detectedMode: detectedMode,
                modeConfidence: modeConfidence,
                sourceKind: sourceKind,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int batchId,
                required int startTsUtc,
                required int startTzOffsetMinutes,
                required int endTsUtc,
                required int endTzOffsetMinutes,
                required double startLat,
                required double startLon,
                required double endLat,
                required double endLon,
                Value<double?> distanceM = const Value.absent(),
                required String detectedMode,
                Value<double?> modeConfidence = const Value.absent(),
                required String sourceKind,
              }) => SegmentsCompanion.insert(
                id: id,
                batchId: batchId,
                startTsUtc: startTsUtc,
                startTzOffsetMinutes: startTzOffsetMinutes,
                endTsUtc: endTsUtc,
                endTzOffsetMinutes: endTzOffsetMinutes,
                startLat: startLat,
                startLon: startLon,
                endLat: endLat,
                endLon: endLon,
                distanceM: distanceM,
                detectedMode: detectedMode,
                modeConfidence: modeConfidence,
                sourceKind: sourceKind,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SegmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({batchId = false}) {
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
                    if (batchId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.batchId,
                                referencedTable: $$SegmentsTableReferences
                                    ._batchIdTable(db),
                                referencedColumn: $$SegmentsTableReferences
                                    ._batchIdTable(db)
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

typedef $$SegmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$OdysseiaDatabase,
      $SegmentsTable,
      Segment,
      $$SegmentsTableFilterComposer,
      $$SegmentsTableOrderingComposer,
      $$SegmentsTableAnnotationComposer,
      $$SegmentsTableCreateCompanionBuilder,
      $$SegmentsTableUpdateCompanionBuilder,
      (Segment, $$SegmentsTableReferences),
      Segment,
      PrefetchHooks Function({bool batchId})
    >;
typedef $$GeoPlacesTableCreateCompanionBuilder =
    GeoPlacesCompanion Function({
      Value<int> id,
      required String name,
      required String nameAscii,
      required String countryCode,
      Value<String?> admin1,
      Value<String?> featureClass,
      Value<int?> population,
      required double lat,
      required double lon,
    });
typedef $$GeoPlacesTableUpdateCompanionBuilder =
    GeoPlacesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> nameAscii,
      Value<String> countryCode,
      Value<String?> admin1,
      Value<String?> featureClass,
      Value<int?> population,
      Value<double> lat,
      Value<double> lon,
    });

final class $$GeoPlacesTableReferences
    extends BaseReferences<_$OdysseiaDatabase, $GeoPlacesTable, GeoPlace> {
  $$GeoPlacesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VisitsTable, List<Visit>> _visitsRefsTable(
    _$OdysseiaDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.visits,
    aliasName: 'geo_places__id__visits__place_id',
  );

  $$VisitsTableProcessedTableManager get visitsRefs {
    final manager = $$VisitsTableTableManager(
      $_db,
      $_db.visits,
    ).filter((f) => f.placeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_visitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GeoPlacesTableFilterComposer
    extends Composer<_$OdysseiaDatabase, $GeoPlacesTable> {
  $$GeoPlacesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAscii => $composableBuilder(
    column: $table.nameAscii,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get admin1 => $composableBuilder(
    column: $table.admin1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get featureClass => $composableBuilder(
    column: $table.featureClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get population => $composableBuilder(
    column: $table.population,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> visitsRefs(
    Expression<bool> Function($$VisitsTableFilterComposer f) f,
  ) {
    final $$VisitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableFilterComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GeoPlacesTableOrderingComposer
    extends Composer<_$OdysseiaDatabase, $GeoPlacesTable> {
  $$GeoPlacesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAscii => $composableBuilder(
    column: $table.nameAscii,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get admin1 => $composableBuilder(
    column: $table.admin1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get featureClass => $composableBuilder(
    column: $table.featureClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get population => $composableBuilder(
    column: $table.population,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GeoPlacesTableAnnotationComposer
    extends Composer<_$OdysseiaDatabase, $GeoPlacesTable> {
  $$GeoPlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAscii =>
      $composableBuilder(column: $table.nameAscii, builder: (column) => column);

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get admin1 =>
      $composableBuilder(column: $table.admin1, builder: (column) => column);

  GeneratedColumn<String> get featureClass => $composableBuilder(
    column: $table.featureClass,
    builder: (column) => column,
  );

  GeneratedColumn<int> get population => $composableBuilder(
    column: $table.population,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  Expression<T> visitsRefs<T extends Object>(
    Expression<T> Function($$VisitsTableAnnotationComposer a) f,
  ) {
    final $$VisitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableAnnotationComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GeoPlacesTableTableManager
    extends
        RootTableManager<
          _$OdysseiaDatabase,
          $GeoPlacesTable,
          GeoPlace,
          $$GeoPlacesTableFilterComposer,
          $$GeoPlacesTableOrderingComposer,
          $$GeoPlacesTableAnnotationComposer,
          $$GeoPlacesTableCreateCompanionBuilder,
          $$GeoPlacesTableUpdateCompanionBuilder,
          (GeoPlace, $$GeoPlacesTableReferences),
          GeoPlace,
          PrefetchHooks Function({bool visitsRefs})
        > {
  $$GeoPlacesTableTableManager(_$OdysseiaDatabase db, $GeoPlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeoPlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeoPlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeoPlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameAscii = const Value.absent(),
                Value<String> countryCode = const Value.absent(),
                Value<String?> admin1 = const Value.absent(),
                Value<String?> featureClass = const Value.absent(),
                Value<int?> population = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
              }) => GeoPlacesCompanion(
                id: id,
                name: name,
                nameAscii: nameAscii,
                countryCode: countryCode,
                admin1: admin1,
                featureClass: featureClass,
                population: population,
                lat: lat,
                lon: lon,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String nameAscii,
                required String countryCode,
                Value<String?> admin1 = const Value.absent(),
                Value<String?> featureClass = const Value.absent(),
                Value<int?> population = const Value.absent(),
                required double lat,
                required double lon,
              }) => GeoPlacesCompanion.insert(
                id: id,
                name: name,
                nameAscii: nameAscii,
                countryCode: countryCode,
                admin1: admin1,
                featureClass: featureClass,
                population: population,
                lat: lat,
                lon: lon,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GeoPlacesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({visitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (visitsRefs) db.visits],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (visitsRefs)
                    await $_getPrefetchedData<GeoPlace, $GeoPlacesTable, Visit>(
                      currentTable: table,
                      referencedTable: $$GeoPlacesTableReferences
                          ._visitsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GeoPlacesTableReferences(db, table, p0).visitsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.placeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GeoPlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$OdysseiaDatabase,
      $GeoPlacesTable,
      GeoPlace,
      $$GeoPlacesTableFilterComposer,
      $$GeoPlacesTableOrderingComposer,
      $$GeoPlacesTableAnnotationComposer,
      $$GeoPlacesTableCreateCompanionBuilder,
      $$GeoPlacesTableUpdateCompanionBuilder,
      (GeoPlace, $$GeoPlacesTableReferences),
      GeoPlace,
      PrefetchHooks Function({bool visitsRefs})
    >;
typedef $$VisitsTableCreateCompanionBuilder =
    VisitsCompanion Function({
      Value<int> id,
      required int batchId,
      required int arrivalTsUtc,
      required int arrivalTzOffsetMinutes,
      required int departureTsUtc,
      required int departureTzOffsetMinutes,
      required double lat,
      required double lon,
      Value<double?> radiusM,
      Value<String?> externalPlaceRef,
      Value<int?> placeId,
      Value<double?> detectionConfidence,
      required String sourceKind,
    });
typedef $$VisitsTableUpdateCompanionBuilder =
    VisitsCompanion Function({
      Value<int> id,
      Value<int> batchId,
      Value<int> arrivalTsUtc,
      Value<int> arrivalTzOffsetMinutes,
      Value<int> departureTsUtc,
      Value<int> departureTzOffsetMinutes,
      Value<double> lat,
      Value<double> lon,
      Value<double?> radiusM,
      Value<String?> externalPlaceRef,
      Value<int?> placeId,
      Value<double?> detectionConfidence,
      Value<String> sourceKind,
    });

final class $$VisitsTableReferences
    extends BaseReferences<_$OdysseiaDatabase, $VisitsTable, Visit> {
  $$VisitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ImportBatchesTable _batchIdTable(_$OdysseiaDatabase db) =>
      db.importBatches.createAlias('visits__batch_id__import_batches__id');

  $$ImportBatchesTableProcessedTableManager get batchId {
    final $_column = $_itemColumn<int>('batch_id')!;

    final manager = $$ImportBatchesTableTableManager(
      $_db,
      $_db.importBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GeoPlacesTable _placeIdTable(_$OdysseiaDatabase db) =>
      db.geoPlaces.createAlias('visits__place_id__geo_places__id');

  $$GeoPlacesTableProcessedTableManager? get placeId {
    final $_column = $_itemColumn<int>('place_id');
    if ($_column == null) return null;
    final manager = $$GeoPlacesTableTableManager(
      $_db,
      $_db.geoPlaces,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_placeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VisitsTableFilterComposer
    extends Composer<_$OdysseiaDatabase, $VisitsTable> {
  $$VisitsTableFilterComposer({
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

  ColumnFilters<int> get arrivalTsUtc => $composableBuilder(
    column: $table.arrivalTsUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get arrivalTzOffsetMinutes => $composableBuilder(
    column: $table.arrivalTzOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get departureTsUtc => $composableBuilder(
    column: $table.departureTsUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get departureTzOffsetMinutes => $composableBuilder(
    column: $table.departureTzOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get radiusM => $composableBuilder(
    column: $table.radiusM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalPlaceRef => $composableBuilder(
    column: $table.externalPlaceRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get detectionConfidence => $composableBuilder(
    column: $table.detectionConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnFilters(column),
  );

  $$ImportBatchesTableFilterComposer get batchId {
    final $$ImportBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableFilterComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GeoPlacesTableFilterComposer get placeId {
    final $$GeoPlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.geoPlaces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeoPlacesTableFilterComposer(
            $db: $db,
            $table: $db.geoPlaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitsTableOrderingComposer
    extends Composer<_$OdysseiaDatabase, $VisitsTable> {
  $$VisitsTableOrderingComposer({
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

  ColumnOrderings<int> get arrivalTsUtc => $composableBuilder(
    column: $table.arrivalTsUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get arrivalTzOffsetMinutes => $composableBuilder(
    column: $table.arrivalTzOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get departureTsUtc => $composableBuilder(
    column: $table.departureTsUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get departureTzOffsetMinutes => $composableBuilder(
    column: $table.departureTzOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get radiusM => $composableBuilder(
    column: $table.radiusM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalPlaceRef => $composableBuilder(
    column: $table.externalPlaceRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get detectionConfidence => $composableBuilder(
    column: $table.detectionConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnOrderings(column),
  );

  $$ImportBatchesTableOrderingComposer get batchId {
    final $$ImportBatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableOrderingComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GeoPlacesTableOrderingComposer get placeId {
    final $$GeoPlacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.geoPlaces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeoPlacesTableOrderingComposer(
            $db: $db,
            $table: $db.geoPlaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitsTableAnnotationComposer
    extends Composer<_$OdysseiaDatabase, $VisitsTable> {
  $$VisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get arrivalTsUtc => $composableBuilder(
    column: $table.arrivalTsUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get arrivalTzOffsetMinutes => $composableBuilder(
    column: $table.arrivalTzOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get departureTsUtc => $composableBuilder(
    column: $table.departureTsUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get departureTzOffsetMinutes => $composableBuilder(
    column: $table.departureTzOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<double> get radiusM =>
      $composableBuilder(column: $table.radiusM, builder: (column) => column);

  GeneratedColumn<String> get externalPlaceRef => $composableBuilder(
    column: $table.externalPlaceRef,
    builder: (column) => column,
  );

  GeneratedColumn<double> get detectionConfidence => $composableBuilder(
    column: $table.detectionConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => column,
  );

  $$ImportBatchesTableAnnotationComposer get batchId {
    final $$ImportBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GeoPlacesTableAnnotationComposer get placeId {
    final $$GeoPlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.geoPlaces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeoPlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.geoPlaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitsTableTableManager
    extends
        RootTableManager<
          _$OdysseiaDatabase,
          $VisitsTable,
          Visit,
          $$VisitsTableFilterComposer,
          $$VisitsTableOrderingComposer,
          $$VisitsTableAnnotationComposer,
          $$VisitsTableCreateCompanionBuilder,
          $$VisitsTableUpdateCompanionBuilder,
          (Visit, $$VisitsTableReferences),
          Visit,
          PrefetchHooks Function({bool batchId, bool placeId})
        > {
  $$VisitsTableTableManager(_$OdysseiaDatabase db, $VisitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> batchId = const Value.absent(),
                Value<int> arrivalTsUtc = const Value.absent(),
                Value<int> arrivalTzOffsetMinutes = const Value.absent(),
                Value<int> departureTsUtc = const Value.absent(),
                Value<int> departureTzOffsetMinutes = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<double?> radiusM = const Value.absent(),
                Value<String?> externalPlaceRef = const Value.absent(),
                Value<int?> placeId = const Value.absent(),
                Value<double?> detectionConfidence = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
              }) => VisitsCompanion(
                id: id,
                batchId: batchId,
                arrivalTsUtc: arrivalTsUtc,
                arrivalTzOffsetMinutes: arrivalTzOffsetMinutes,
                departureTsUtc: departureTsUtc,
                departureTzOffsetMinutes: departureTzOffsetMinutes,
                lat: lat,
                lon: lon,
                radiusM: radiusM,
                externalPlaceRef: externalPlaceRef,
                placeId: placeId,
                detectionConfidence: detectionConfidence,
                sourceKind: sourceKind,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int batchId,
                required int arrivalTsUtc,
                required int arrivalTzOffsetMinutes,
                required int departureTsUtc,
                required int departureTzOffsetMinutes,
                required double lat,
                required double lon,
                Value<double?> radiusM = const Value.absent(),
                Value<String?> externalPlaceRef = const Value.absent(),
                Value<int?> placeId = const Value.absent(),
                Value<double?> detectionConfidence = const Value.absent(),
                required String sourceKind,
              }) => VisitsCompanion.insert(
                id: id,
                batchId: batchId,
                arrivalTsUtc: arrivalTsUtc,
                arrivalTzOffsetMinutes: arrivalTzOffsetMinutes,
                departureTsUtc: departureTsUtc,
                departureTzOffsetMinutes: departureTzOffsetMinutes,
                lat: lat,
                lon: lon,
                radiusM: radiusM,
                externalPlaceRef: externalPlaceRef,
                placeId: placeId,
                detectionConfidence: detectionConfidence,
                sourceKind: sourceKind,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$VisitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({batchId = false, placeId = false}) {
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
                    if (batchId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.batchId,
                                referencedTable: $$VisitsTableReferences
                                    ._batchIdTable(db),
                                referencedColumn: $$VisitsTableReferences
                                    ._batchIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (placeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.placeId,
                                referencedTable: $$VisitsTableReferences
                                    ._placeIdTable(db),
                                referencedColumn: $$VisitsTableReferences
                                    ._placeIdTable(db)
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

typedef $$VisitsTableProcessedTableManager =
    ProcessedTableManager<
      _$OdysseiaDatabase,
      $VisitsTable,
      Visit,
      $$VisitsTableFilterComposer,
      $$VisitsTableOrderingComposer,
      $$VisitsTableAnnotationComposer,
      $$VisitsTableCreateCompanionBuilder,
      $$VisitsTableUpdateCompanionBuilder,
      (Visit, $$VisitsTableReferences),
      Visit,
      PrefetchHooks Function({bool batchId, bool placeId})
    >;
typedef $$UserPlacesTableCreateCompanionBuilder =
    UserPlacesCompanion Function({
      Value<int> id,
      required String label,
      required double lat,
      required double lon,
      required double radiusM,
      required int createdAt,
      required int updatedAt,
    });
typedef $$UserPlacesTableUpdateCompanionBuilder =
    UserPlacesCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<double> lat,
      Value<double> lon,
      Value<double> radiusM,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$UserPlacesTableFilterComposer
    extends Composer<_$OdysseiaDatabase, $UserPlacesTable> {
  $$UserPlacesTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get radiusM => $composableBuilder(
    column: $table.radiusM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPlacesTableOrderingComposer
    extends Composer<_$OdysseiaDatabase, $UserPlacesTable> {
  $$UserPlacesTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get radiusM => $composableBuilder(
    column: $table.radiusM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPlacesTableAnnotationComposer
    extends Composer<_$OdysseiaDatabase, $UserPlacesTable> {
  $$UserPlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<double> get radiusM =>
      $composableBuilder(column: $table.radiusM, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserPlacesTableTableManager
    extends
        RootTableManager<
          _$OdysseiaDatabase,
          $UserPlacesTable,
          UserPlace,
          $$UserPlacesTableFilterComposer,
          $$UserPlacesTableOrderingComposer,
          $$UserPlacesTableAnnotationComposer,
          $$UserPlacesTableCreateCompanionBuilder,
          $$UserPlacesTableUpdateCompanionBuilder,
          (
            UserPlace,
            BaseReferences<_$OdysseiaDatabase, $UserPlacesTable, UserPlace>,
          ),
          UserPlace,
          PrefetchHooks Function()
        > {
  $$UserPlacesTableTableManager(_$OdysseiaDatabase db, $UserPlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<double> radiusM = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => UserPlacesCompanion(
                id: id,
                label: label,
                lat: lat,
                lon: lon,
                radiusM: radiusM,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                required double lat,
                required double lon,
                required double radiusM,
                required int createdAt,
                required int updatedAt,
              }) => UserPlacesCompanion.insert(
                id: id,
                label: label,
                lat: lat,
                lon: lon,
                radiusM: radiusM,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$OdysseiaDatabase,
      $UserPlacesTable,
      UserPlace,
      $$UserPlacesTableFilterComposer,
      $$UserPlacesTableOrderingComposer,
      $$UserPlacesTableAnnotationComposer,
      $$UserPlacesTableCreateCompanionBuilder,
      $$UserPlacesTableUpdateCompanionBuilder,
      (
        UserPlace,
        BaseReferences<_$OdysseiaDatabase, $UserPlacesTable, UserPlace>,
      ),
      UserPlace,
      PrefetchHooks Function()
    >;
typedef $$PrivateZonesTableCreateCompanionBuilder =
    PrivateZonesCompanion Function({
      Value<int> id,
      required String label,
      required String shapeKind,
      Value<double?> lat,
      Value<double?> lon,
      Value<double?> radiusM,
      Value<String?> polygonGeojson,
      required int createdAt,
    });
typedef $$PrivateZonesTableUpdateCompanionBuilder =
    PrivateZonesCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<String> shapeKind,
      Value<double?> lat,
      Value<double?> lon,
      Value<double?> radiusM,
      Value<String?> polygonGeojson,
      Value<int> createdAt,
    });

class $$PrivateZonesTableFilterComposer
    extends Composer<_$OdysseiaDatabase, $PrivateZonesTable> {
  $$PrivateZonesTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shapeKind => $composableBuilder(
    column: $table.shapeKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get radiusM => $composableBuilder(
    column: $table.radiusM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get polygonGeojson => $composableBuilder(
    column: $table.polygonGeojson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrivateZonesTableOrderingComposer
    extends Composer<_$OdysseiaDatabase, $PrivateZonesTable> {
  $$PrivateZonesTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shapeKind => $composableBuilder(
    column: $table.shapeKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get radiusM => $composableBuilder(
    column: $table.radiusM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get polygonGeojson => $composableBuilder(
    column: $table.polygonGeojson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrivateZonesTableAnnotationComposer
    extends Composer<_$OdysseiaDatabase, $PrivateZonesTable> {
  $$PrivateZonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get shapeKind =>
      $composableBuilder(column: $table.shapeKind, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<double> get radiusM =>
      $composableBuilder(column: $table.radiusM, builder: (column) => column);

  GeneratedColumn<String> get polygonGeojson => $composableBuilder(
    column: $table.polygonGeojson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PrivateZonesTableTableManager
    extends
        RootTableManager<
          _$OdysseiaDatabase,
          $PrivateZonesTable,
          PrivateZone,
          $$PrivateZonesTableFilterComposer,
          $$PrivateZonesTableOrderingComposer,
          $$PrivateZonesTableAnnotationComposer,
          $$PrivateZonesTableCreateCompanionBuilder,
          $$PrivateZonesTableUpdateCompanionBuilder,
          (
            PrivateZone,
            BaseReferences<_$OdysseiaDatabase, $PrivateZonesTable, PrivateZone>,
          ),
          PrivateZone,
          PrefetchHooks Function()
        > {
  $$PrivateZonesTableTableManager(
    _$OdysseiaDatabase db,
    $PrivateZonesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrivateZonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrivateZonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrivateZonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> shapeKind = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lon = const Value.absent(),
                Value<double?> radiusM = const Value.absent(),
                Value<String?> polygonGeojson = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => PrivateZonesCompanion(
                id: id,
                label: label,
                shapeKind: shapeKind,
                lat: lat,
                lon: lon,
                radiusM: radiusM,
                polygonGeojson: polygonGeojson,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                required String shapeKind,
                Value<double?> lat = const Value.absent(),
                Value<double?> lon = const Value.absent(),
                Value<double?> radiusM = const Value.absent(),
                Value<String?> polygonGeojson = const Value.absent(),
                required int createdAt,
              }) => PrivateZonesCompanion.insert(
                id: id,
                label: label,
                shapeKind: shapeKind,
                lat: lat,
                lon: lon,
                radiusM: radiusM,
                polygonGeojson: polygonGeojson,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrivateZonesTableProcessedTableManager =
    ProcessedTableManager<
      _$OdysseiaDatabase,
      $PrivateZonesTable,
      PrivateZone,
      $$PrivateZonesTableFilterComposer,
      $$PrivateZonesTableOrderingComposer,
      $$PrivateZonesTableAnnotationComposer,
      $$PrivateZonesTableCreateCompanionBuilder,
      $$PrivateZonesTableUpdateCompanionBuilder,
      (
        PrivateZone,
        BaseReferences<_$OdysseiaDatabase, $PrivateZonesTable, PrivateZone>,
      ),
      PrivateZone,
      PrefetchHooks Function()
    >;
typedef $$UserSegmentOverridesTableCreateCompanionBuilder =
    UserSegmentOverridesCompanion Function({
      Value<int> id,
      required int localDate,
      required double startLatR,
      required double startLonR,
      required double endLatR,
      required double endLonR,
      required String correctedMode,
      required int sourceStartTsUtc,
      required int createdAt,
    });
typedef $$UserSegmentOverridesTableUpdateCompanionBuilder =
    UserSegmentOverridesCompanion Function({
      Value<int> id,
      Value<int> localDate,
      Value<double> startLatR,
      Value<double> startLonR,
      Value<double> endLatR,
      Value<double> endLonR,
      Value<String> correctedMode,
      Value<int> sourceStartTsUtc,
      Value<int> createdAt,
    });

class $$UserSegmentOverridesTableFilterComposer
    extends Composer<_$OdysseiaDatabase, $UserSegmentOverridesTable> {
  $$UserSegmentOverridesTableFilterComposer({
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

  ColumnFilters<int> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startLatR => $composableBuilder(
    column: $table.startLatR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startLonR => $composableBuilder(
    column: $table.startLonR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get endLatR => $composableBuilder(
    column: $table.endLatR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get endLonR => $composableBuilder(
    column: $table.endLonR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctedMode => $composableBuilder(
    column: $table.correctedMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceStartTsUtc => $composableBuilder(
    column: $table.sourceStartTsUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSegmentOverridesTableOrderingComposer
    extends Composer<_$OdysseiaDatabase, $UserSegmentOverridesTable> {
  $$UserSegmentOverridesTableOrderingComposer({
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

  ColumnOrderings<int> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startLatR => $composableBuilder(
    column: $table.startLatR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startLonR => $composableBuilder(
    column: $table.startLonR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get endLatR => $composableBuilder(
    column: $table.endLatR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get endLonR => $composableBuilder(
    column: $table.endLonR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctedMode => $composableBuilder(
    column: $table.correctedMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceStartTsUtc => $composableBuilder(
    column: $table.sourceStartTsUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSegmentOverridesTableAnnotationComposer
    extends Composer<_$OdysseiaDatabase, $UserSegmentOverridesTable> {
  $$UserSegmentOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<double> get startLatR =>
      $composableBuilder(column: $table.startLatR, builder: (column) => column);

  GeneratedColumn<double> get startLonR =>
      $composableBuilder(column: $table.startLonR, builder: (column) => column);

  GeneratedColumn<double> get endLatR =>
      $composableBuilder(column: $table.endLatR, builder: (column) => column);

  GeneratedColumn<double> get endLonR =>
      $composableBuilder(column: $table.endLonR, builder: (column) => column);

  GeneratedColumn<String> get correctedMode => $composableBuilder(
    column: $table.correctedMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceStartTsUtc => $composableBuilder(
    column: $table.sourceStartTsUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserSegmentOverridesTableTableManager
    extends
        RootTableManager<
          _$OdysseiaDatabase,
          $UserSegmentOverridesTable,
          UserSegmentOverride,
          $$UserSegmentOverridesTableFilterComposer,
          $$UserSegmentOverridesTableOrderingComposer,
          $$UserSegmentOverridesTableAnnotationComposer,
          $$UserSegmentOverridesTableCreateCompanionBuilder,
          $$UserSegmentOverridesTableUpdateCompanionBuilder,
          (
            UserSegmentOverride,
            BaseReferences<
              _$OdysseiaDatabase,
              $UserSegmentOverridesTable,
              UserSegmentOverride
            >,
          ),
          UserSegmentOverride,
          PrefetchHooks Function()
        > {
  $$UserSegmentOverridesTableTableManager(
    _$OdysseiaDatabase db,
    $UserSegmentOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSegmentOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSegmentOverridesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserSegmentOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> localDate = const Value.absent(),
                Value<double> startLatR = const Value.absent(),
                Value<double> startLonR = const Value.absent(),
                Value<double> endLatR = const Value.absent(),
                Value<double> endLonR = const Value.absent(),
                Value<String> correctedMode = const Value.absent(),
                Value<int> sourceStartTsUtc = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => UserSegmentOverridesCompanion(
                id: id,
                localDate: localDate,
                startLatR: startLatR,
                startLonR: startLonR,
                endLatR: endLatR,
                endLonR: endLonR,
                correctedMode: correctedMode,
                sourceStartTsUtc: sourceStartTsUtc,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int localDate,
                required double startLatR,
                required double startLonR,
                required double endLatR,
                required double endLonR,
                required String correctedMode,
                required int sourceStartTsUtc,
                required int createdAt,
              }) => UserSegmentOverridesCompanion.insert(
                id: id,
                localDate: localDate,
                startLatR: startLatR,
                startLonR: startLonR,
                endLatR: endLatR,
                endLonR: endLonR,
                correctedMode: correctedMode,
                sourceStartTsUtc: sourceStartTsUtc,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSegmentOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$OdysseiaDatabase,
      $UserSegmentOverridesTable,
      UserSegmentOverride,
      $$UserSegmentOverridesTableFilterComposer,
      $$UserSegmentOverridesTableOrderingComposer,
      $$UserSegmentOverridesTableAnnotationComposer,
      $$UserSegmentOverridesTableCreateCompanionBuilder,
      $$UserSegmentOverridesTableUpdateCompanionBuilder,
      (
        UserSegmentOverride,
        BaseReferences<
          _$OdysseiaDatabase,
          $UserSegmentOverridesTable,
          UserSegmentOverride
        >,
      ),
      UserSegmentOverride,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String settingKey,
      required String settingValue,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> settingKey,
      Value<String> settingValue,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$OdysseiaDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$OdysseiaDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$OdysseiaDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$OdysseiaDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$OdysseiaDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$OdysseiaDatabase db, $AppSettingsTable table)
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
                Value<String> settingKey = const Value.absent(),
                Value<String> settingValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String settingKey,
                required String settingValue,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                settingKey: settingKey,
                settingValue: settingValue,
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
      _$OdysseiaDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$OdysseiaDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $OdysseiaDatabaseManager {
  final _$OdysseiaDatabase _db;
  $OdysseiaDatabaseManager(this._db);
  $$ImportBatchesTableTableManager get importBatches =>
      $$ImportBatchesTableTableManager(_db, _db.importBatches);
  $$RawPointsTableTableManager get rawPoints =>
      $$RawPointsTableTableManager(_db, _db.rawPoints);
  $$SegmentsTableTableManager get segments =>
      $$SegmentsTableTableManager(_db, _db.segments);
  $$GeoPlacesTableTableManager get geoPlaces =>
      $$GeoPlacesTableTableManager(_db, _db.geoPlaces);
  $$VisitsTableTableManager get visits =>
      $$VisitsTableTableManager(_db, _db.visits);
  $$UserPlacesTableTableManager get userPlaces =>
      $$UserPlacesTableTableManager(_db, _db.userPlaces);
  $$PrivateZonesTableTableManager get privateZones =>
      $$PrivateZonesTableTableManager(_db, _db.privateZones);
  $$UserSegmentOverridesTableTableManager get userSegmentOverrides =>
      $$UserSegmentOverridesTableTableManager(_db, _db.userSegmentOverrides);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
