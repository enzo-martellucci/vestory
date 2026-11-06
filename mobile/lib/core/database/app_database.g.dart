// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlayerTableTable extends PlayerTable
    with TableInfo<$PlayerTableTable, Player> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gemsMeta = const VerificationMeta('gems');
  @override
  late final GeneratedColumn<int> gems = GeneratedColumn<int>(
    'gems',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastDailyPackAtMeta = const VerificationMeta(
    'lastDailyPackAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastDailyPackAt =
      GeneratedColumn<DateTime>(
        'last_daily_pack_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [id, username, gems, lastDailyPackAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player';
  @override
  VerificationContext validateIntegrity(
    Insertable<Player> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('gems')) {
      context.handle(
        _gemsMeta,
        gems.isAcceptableOrUnknown(data['gems']!, _gemsMeta),
      );
    } else if (isInserting) {
      context.missing(_gemsMeta);
    }
    if (data.containsKey('last_daily_pack_at')) {
      context.handle(
        _lastDailyPackAtMeta,
        lastDailyPackAt.isAcceptableOrUnknown(
          data['last_daily_pack_at']!,
          _lastDailyPackAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Player(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      gems: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gems'],
      )!,
      lastDailyPackAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_daily_pack_at'],
      ),
    );
  }

  @override
  $PlayerTableTable createAlias(String alias) {
    return $PlayerTableTable(attachedDatabase, alias);
  }
}

class Player extends DataClass implements Insertable<Player> {
  final int id;
  final String username;
  final int gems;
  final DateTime? lastDailyPackAt;
  const Player({
    required this.id,
    required this.username,
    required this.gems,
    this.lastDailyPackAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['gems'] = Variable<int>(gems);
    if (!nullToAbsent || lastDailyPackAt != null) {
      map['last_daily_pack_at'] = Variable<DateTime>(lastDailyPackAt);
    }
    return map;
  }

  PlayerTableCompanion toCompanion(bool nullToAbsent) {
    return PlayerTableCompanion(
      id: Value(id),
      username: Value(username),
      gems: Value(gems),
      lastDailyPackAt: lastDailyPackAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDailyPackAt),
    );
  }

  factory Player.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      gems: serializer.fromJson<int>(json['gems']),
      lastDailyPackAt: serializer.fromJson<DateTime?>(json['lastDailyPackAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'gems': serializer.toJson<int>(gems),
      'lastDailyPackAt': serializer.toJson<DateTime?>(lastDailyPackAt),
    };
  }

  Player copyWith({
    int? id,
    String? username,
    int? gems,
    Value<DateTime?> lastDailyPackAt = const Value.absent(),
  }) => Player(
    id: id ?? this.id,
    username: username ?? this.username,
    gems: gems ?? this.gems,
    lastDailyPackAt: lastDailyPackAt.present
        ? lastDailyPackAt.value
        : this.lastDailyPackAt,
  );
  Player copyWithCompanion(PlayerTableCompanion data) {
    return Player(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      gems: data.gems.present ? data.gems.value : this.gems,
      lastDailyPackAt: data.lastDailyPackAt.present
          ? data.lastDailyPackAt.value
          : this.lastDailyPackAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('gems: $gems, ')
          ..write('lastDailyPackAt: $lastDailyPackAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, gems, lastDailyPackAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.username == this.username &&
          other.gems == this.gems &&
          other.lastDailyPackAt == this.lastDailyPackAt);
}

class PlayerTableCompanion extends UpdateCompanion<Player> {
  final Value<int> id;
  final Value<String> username;
  final Value<int> gems;
  final Value<DateTime?> lastDailyPackAt;
  const PlayerTableCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.gems = const Value.absent(),
    this.lastDailyPackAt = const Value.absent(),
  });
  PlayerTableCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required int gems,
    this.lastDailyPackAt = const Value.absent(),
  }) : username = Value(username),
       gems = Value(gems);
  static Insertable<Player> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<int>? gems,
    Expression<DateTime>? lastDailyPackAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (gems != null) 'gems': gems,
      if (lastDailyPackAt != null) 'last_daily_pack_at': lastDailyPackAt,
    });
  }

  PlayerTableCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<int>? gems,
    Value<DateTime?>? lastDailyPackAt,
  }) {
    return PlayerTableCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      gems: gems ?? this.gems,
      lastDailyPackAt: lastDailyPackAt ?? this.lastDailyPackAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (gems.present) {
      map['gems'] = Variable<int>(gems.value);
    }
    if (lastDailyPackAt.present) {
      map['last_daily_pack_at'] = Variable<DateTime>(lastDailyPackAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerTableCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('gems: $gems, ')
          ..write('lastDailyPackAt: $lastDailyPackAt')
          ..write(')'))
        .toString();
  }
}

class $AssetTableTable extends AssetTable
    with TableInfo<$AssetTableTable, Asset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
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
  @override
  late final GeneratedColumnWithTypeConverter<AssetType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AssetType>($AssetTableTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<Rarity, String> rarity =
      GeneratedColumn<String>(
        'rarity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Rarity>($AssetTableTable.$converterrarity);
  static const VerificationMeta _marketSymbolMeta = const VerificationMeta(
    'marketSymbol',
  );
  @override
  late final GeneratedColumn<String> marketSymbol = GeneratedColumn<String>(
    'market_symbol',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _micCodeMeta = const VerificationMeta(
    'micCode',
  );
  @override
  late final GeneratedColumn<String> micCode = GeneratedColumn<String>(
    'mic_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exchangeMeta = const VerificationMeta(
    'exchange',
  );
  @override
  late final GeneratedColumn<String> exchange = GeneratedColumn<String>(
    'exchange',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sectorMeta = const VerificationMeta('sector');
  @override
  late final GeneratedColumn<String> sector = GeneratedColumn<String>(
    'sector',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _industryMeta = const VerificationMeta(
    'industry',
  );
  @override
  late final GeneratedColumn<String> industry = GeneratedColumn<String>(
    'industry',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastObtainedAtMeta = const VerificationMeta(
    'lastObtainedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastObtainedAt =
      GeneratedColumn<DateTime>(
        'last_obtained_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    symbol,
    name,
    type,
    rarity,
    marketSymbol,
    micCode,
    exchange,
    country,
    currency,
    sector,
    industry,
    description,
    logoUrl,
    quantity,
    lastObtainedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset';
  @override
  VerificationContext validateIntegrity(
    Insertable<Asset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('market_symbol')) {
      context.handle(
        _marketSymbolMeta,
        marketSymbol.isAcceptableOrUnknown(
          data['market_symbol']!,
          _marketSymbolMeta,
        ),
      );
    }
    if (data.containsKey('mic_code')) {
      context.handle(
        _micCodeMeta,
        micCode.isAcceptableOrUnknown(data['mic_code']!, _micCodeMeta),
      );
    }
    if (data.containsKey('exchange')) {
      context.handle(
        _exchangeMeta,
        exchange.isAcceptableOrUnknown(data['exchange']!, _exchangeMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('sector')) {
      context.handle(
        _sectorMeta,
        sector.isAcceptableOrUnknown(data['sector']!, _sectorMeta),
      );
    }
    if (data.containsKey('industry')) {
      context.handle(
        _industryMeta,
        industry.isAcceptableOrUnknown(data['industry']!, _industryMeta),
      );
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
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('last_obtained_at')) {
      context.handle(
        _lastObtainedAtMeta,
        lastObtainedAt.isAcceptableOrUnknown(
          data['last_obtained_at']!,
          _lastObtainedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Asset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $AssetTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      rarity: $AssetTableTable.$converterrarity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rarity'],
        )!,
      ),
      marketSymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}market_symbol'],
      ),
      micCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mic_code'],
      ),
      exchange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exchange'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      sector: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sector'],
      ),
      industry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}industry'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      lastObtainedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_obtained_at'],
      ),
    );
  }

  @override
  $AssetTableTable createAlias(String alias) {
    return $AssetTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AssetType, String, String> $convertertype =
      const EnumNameConverter<AssetType>(AssetType.values);
  static JsonTypeConverter2<Rarity, String, String> $converterrarity =
      const EnumNameConverter<Rarity>(Rarity.values);
}

class Asset extends DataClass implements Insertable<Asset> {
  final int id;
  final String symbol;
  final String name;
  final AssetType type;
  final Rarity rarity;
  final String? marketSymbol;
  final String? micCode;
  final String? exchange;
  final String? country;
  final String? currency;
  final String? sector;
  final String? industry;
  final String? description;
  final String? logoUrl;
  final int quantity;
  final DateTime? lastObtainedAt;
  const Asset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.type,
    required this.rarity,
    this.marketSymbol,
    this.micCode,
    this.exchange,
    this.country,
    this.currency,
    this.sector,
    this.industry,
    this.description,
    this.logoUrl,
    required this.quantity,
    this.lastObtainedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>(
        $AssetTableTable.$convertertype.toSql(type),
      );
    }
    {
      map['rarity'] = Variable<String>(
        $AssetTableTable.$converterrarity.toSql(rarity),
      );
    }
    if (!nullToAbsent || marketSymbol != null) {
      map['market_symbol'] = Variable<String>(marketSymbol);
    }
    if (!nullToAbsent || micCode != null) {
      map['mic_code'] = Variable<String>(micCode);
    }
    if (!nullToAbsent || exchange != null) {
      map['exchange'] = Variable<String>(exchange);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || sector != null) {
      map['sector'] = Variable<String>(sector);
    }
    if (!nullToAbsent || industry != null) {
      map['industry'] = Variable<String>(industry);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || lastObtainedAt != null) {
      map['last_obtained_at'] = Variable<DateTime>(lastObtainedAt);
    }
    return map;
  }

  AssetTableCompanion toCompanion(bool nullToAbsent) {
    return AssetTableCompanion(
      id: Value(id),
      symbol: Value(symbol),
      name: Value(name),
      type: Value(type),
      rarity: Value(rarity),
      marketSymbol: marketSymbol == null && nullToAbsent
          ? const Value.absent()
          : Value(marketSymbol),
      micCode: micCode == null && nullToAbsent
          ? const Value.absent()
          : Value(micCode),
      exchange: exchange == null && nullToAbsent
          ? const Value.absent()
          : Value(exchange),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      sector: sector == null && nullToAbsent
          ? const Value.absent()
          : Value(sector),
      industry: industry == null && nullToAbsent
          ? const Value.absent()
          : Value(industry),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      quantity: Value(quantity),
      lastObtainedAt: lastObtainedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastObtainedAt),
    );
  }

  factory Asset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      name: serializer.fromJson<String>(json['name']),
      type: $AssetTableTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      rarity: $AssetTableTable.$converterrarity.fromJson(
        serializer.fromJson<String>(json['rarity']),
      ),
      marketSymbol: serializer.fromJson<String?>(json['marketSymbol']),
      micCode: serializer.fromJson<String?>(json['micCode']),
      exchange: serializer.fromJson<String?>(json['exchange']),
      country: serializer.fromJson<String?>(json['country']),
      currency: serializer.fromJson<String?>(json['currency']),
      sector: serializer.fromJson<String?>(json['sector']),
      industry: serializer.fromJson<String?>(json['industry']),
      description: serializer.fromJson<String?>(json['description']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      quantity: serializer.fromJson<int>(json['quantity']),
      lastObtainedAt: serializer.fromJson<DateTime?>(json['lastObtainedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'symbol': serializer.toJson<String>(symbol),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $AssetTableTable.$convertertype.toJson(type),
      ),
      'rarity': serializer.toJson<String>(
        $AssetTableTable.$converterrarity.toJson(rarity),
      ),
      'marketSymbol': serializer.toJson<String?>(marketSymbol),
      'micCode': serializer.toJson<String?>(micCode),
      'exchange': serializer.toJson<String?>(exchange),
      'country': serializer.toJson<String?>(country),
      'currency': serializer.toJson<String?>(currency),
      'sector': serializer.toJson<String?>(sector),
      'industry': serializer.toJson<String?>(industry),
      'description': serializer.toJson<String?>(description),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'quantity': serializer.toJson<int>(quantity),
      'lastObtainedAt': serializer.toJson<DateTime?>(lastObtainedAt),
    };
  }

  Asset copyWith({
    int? id,
    String? symbol,
    String? name,
    AssetType? type,
    Rarity? rarity,
    Value<String?> marketSymbol = const Value.absent(),
    Value<String?> micCode = const Value.absent(),
    Value<String?> exchange = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<String?> currency = const Value.absent(),
    Value<String?> sector = const Value.absent(),
    Value<String?> industry = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> logoUrl = const Value.absent(),
    int? quantity,
    Value<DateTime?> lastObtainedAt = const Value.absent(),
  }) => Asset(
    id: id ?? this.id,
    symbol: symbol ?? this.symbol,
    name: name ?? this.name,
    type: type ?? this.type,
    rarity: rarity ?? this.rarity,
    marketSymbol: marketSymbol.present ? marketSymbol.value : this.marketSymbol,
    micCode: micCode.present ? micCode.value : this.micCode,
    exchange: exchange.present ? exchange.value : this.exchange,
    country: country.present ? country.value : this.country,
    currency: currency.present ? currency.value : this.currency,
    sector: sector.present ? sector.value : this.sector,
    industry: industry.present ? industry.value : this.industry,
    description: description.present ? description.value : this.description,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    quantity: quantity ?? this.quantity,
    lastObtainedAt: lastObtainedAt.present
        ? lastObtainedAt.value
        : this.lastObtainedAt,
  );
  Asset copyWithCompanion(AssetTableCompanion data) {
    return Asset(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      marketSymbol: data.marketSymbol.present
          ? data.marketSymbol.value
          : this.marketSymbol,
      micCode: data.micCode.present ? data.micCode.value : this.micCode,
      exchange: data.exchange.present ? data.exchange.value : this.exchange,
      country: data.country.present ? data.country.value : this.country,
      currency: data.currency.present ? data.currency.value : this.currency,
      sector: data.sector.present ? data.sector.value : this.sector,
      industry: data.industry.present ? data.industry.value : this.industry,
      description: data.description.present
          ? data.description.value
          : this.description,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      lastObtainedAt: data.lastObtainedAt.present
          ? data.lastObtainedAt.value
          : this.lastObtainedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('rarity: $rarity, ')
          ..write('marketSymbol: $marketSymbol, ')
          ..write('micCode: $micCode, ')
          ..write('exchange: $exchange, ')
          ..write('country: $country, ')
          ..write('currency: $currency, ')
          ..write('sector: $sector, ')
          ..write('industry: $industry, ')
          ..write('description: $description, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('quantity: $quantity, ')
          ..write('lastObtainedAt: $lastObtainedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    symbol,
    name,
    type,
    rarity,
    marketSymbol,
    micCode,
    exchange,
    country,
    currency,
    sector,
    industry,
    description,
    logoUrl,
    quantity,
    lastObtainedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.name == this.name &&
          other.type == this.type &&
          other.rarity == this.rarity &&
          other.marketSymbol == this.marketSymbol &&
          other.micCode == this.micCode &&
          other.exchange == this.exchange &&
          other.country == this.country &&
          other.currency == this.currency &&
          other.sector == this.sector &&
          other.industry == this.industry &&
          other.description == this.description &&
          other.logoUrl == this.logoUrl &&
          other.quantity == this.quantity &&
          other.lastObtainedAt == this.lastObtainedAt);
}

class AssetTableCompanion extends UpdateCompanion<Asset> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<String> name;
  final Value<AssetType> type;
  final Value<Rarity> rarity;
  final Value<String?> marketSymbol;
  final Value<String?> micCode;
  final Value<String?> exchange;
  final Value<String?> country;
  final Value<String?> currency;
  final Value<String?> sector;
  final Value<String?> industry;
  final Value<String?> description;
  final Value<String?> logoUrl;
  final Value<int> quantity;
  final Value<DateTime?> lastObtainedAt;
  const AssetTableCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.rarity = const Value.absent(),
    this.marketSymbol = const Value.absent(),
    this.micCode = const Value.absent(),
    this.exchange = const Value.absent(),
    this.country = const Value.absent(),
    this.currency = const Value.absent(),
    this.sector = const Value.absent(),
    this.industry = const Value.absent(),
    this.description = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.quantity = const Value.absent(),
    this.lastObtainedAt = const Value.absent(),
  });
  AssetTableCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required String name,
    required AssetType type,
    required Rarity rarity,
    this.marketSymbol = const Value.absent(),
    this.micCode = const Value.absent(),
    this.exchange = const Value.absent(),
    this.country = const Value.absent(),
    this.currency = const Value.absent(),
    this.sector = const Value.absent(),
    this.industry = const Value.absent(),
    this.description = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.quantity = const Value.absent(),
    this.lastObtainedAt = const Value.absent(),
  }) : symbol = Value(symbol),
       name = Value(name),
       type = Value(type),
       rarity = Value(rarity);
  static Insertable<Asset> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? rarity,
    Expression<String>? marketSymbol,
    Expression<String>? micCode,
    Expression<String>? exchange,
    Expression<String>? country,
    Expression<String>? currency,
    Expression<String>? sector,
    Expression<String>? industry,
    Expression<String>? description,
    Expression<String>? logoUrl,
    Expression<int>? quantity,
    Expression<DateTime>? lastObtainedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (rarity != null) 'rarity': rarity,
      if (marketSymbol != null) 'market_symbol': marketSymbol,
      if (micCode != null) 'mic_code': micCode,
      if (exchange != null) 'exchange': exchange,
      if (country != null) 'country': country,
      if (currency != null) 'currency': currency,
      if (sector != null) 'sector': sector,
      if (industry != null) 'industry': industry,
      if (description != null) 'description': description,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (quantity != null) 'quantity': quantity,
      if (lastObtainedAt != null) 'last_obtained_at': lastObtainedAt,
    });
  }

  AssetTableCompanion copyWith({
    Value<int>? id,
    Value<String>? symbol,
    Value<String>? name,
    Value<AssetType>? type,
    Value<Rarity>? rarity,
    Value<String?>? marketSymbol,
    Value<String?>? micCode,
    Value<String?>? exchange,
    Value<String?>? country,
    Value<String?>? currency,
    Value<String?>? sector,
    Value<String?>? industry,
    Value<String?>? description,
    Value<String?>? logoUrl,
    Value<int>? quantity,
    Value<DateTime?>? lastObtainedAt,
  }) {
    return AssetTableCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      marketSymbol: marketSymbol ?? this.marketSymbol,
      micCode: micCode ?? this.micCode,
      exchange: exchange ?? this.exchange,
      country: country ?? this.country,
      currency: currency ?? this.currency,
      sector: sector ?? this.sector,
      industry: industry ?? this.industry,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      quantity: quantity ?? this.quantity,
      lastObtainedAt: lastObtainedAt ?? this.lastObtainedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $AssetTableTable.$convertertype.toSql(type.value),
      );
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(
        $AssetTableTable.$converterrarity.toSql(rarity.value),
      );
    }
    if (marketSymbol.present) {
      map['market_symbol'] = Variable<String>(marketSymbol.value);
    }
    if (micCode.present) {
      map['mic_code'] = Variable<String>(micCode.value);
    }
    if (exchange.present) {
      map['exchange'] = Variable<String>(exchange.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (sector.present) {
      map['sector'] = Variable<String>(sector.value);
    }
    if (industry.present) {
      map['industry'] = Variable<String>(industry.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (lastObtainedAt.present) {
      map['last_obtained_at'] = Variable<DateTime>(lastObtainedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetTableCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('rarity: $rarity, ')
          ..write('marketSymbol: $marketSymbol, ')
          ..write('micCode: $micCode, ')
          ..write('exchange: $exchange, ')
          ..write('country: $country, ')
          ..write('currency: $currency, ')
          ..write('sector: $sector, ')
          ..write('industry: $industry, ')
          ..write('description: $description, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('quantity: $quantity, ')
          ..write('lastObtainedAt: $lastObtainedAt')
          ..write(')'))
        .toString();
  }
}

class $GameTableTable extends GameTable with TableInfo<$GameTableTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameTableTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<YearMonth, int> startMonth =
      GeneratedColumn<int>(
        'start_month',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<YearMonth>($GameTableTable.$converterstartMonth);
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finalValueMeta = const VerificationMeta(
    'finalValue',
  );
  @override
  late final GeneratedColumn<double> finalValue = GeneratedColumn<double>(
    'final_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startMonth,
    startedAt,
    endedAt,
    finalValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('final_value')) {
      context.handle(
        _finalValueMeta,
        finalValue.isAcceptableOrUnknown(data['final_value']!, _finalValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startMonth: $GameTableTable.$converterstartMonth.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}start_month'],
        )!,
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      finalValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}final_value'],
      ),
    );
  }

  @override
  $GameTableTable createAlias(String alias) {
    return $GameTableTable(attachedDatabase, alias);
  }

  static TypeConverter<YearMonth, int> $converterstartMonth =
      const YearMonthConverter();
}

class Game extends DataClass implements Insertable<Game> {
  final int id;
  final YearMonth startMonth;
  final DateTime startedAt;
  final DateTime? endedAt;
  final double? finalValue;
  const Game({
    required this.id,
    required this.startMonth,
    required this.startedAt,
    this.endedAt,
    this.finalValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['start_month'] = Variable<int>(
        $GameTableTable.$converterstartMonth.toSql(startMonth),
      );
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || finalValue != null) {
      map['final_value'] = Variable<double>(finalValue);
    }
    return map;
  }

  GameTableCompanion toCompanion(bool nullToAbsent) {
    return GameTableCompanion(
      id: Value(id),
      startMonth: Value(startMonth),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      finalValue: finalValue == null && nullToAbsent
          ? const Value.absent()
          : Value(finalValue),
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<int>(json['id']),
      startMonth: serializer.fromJson<YearMonth>(json['startMonth']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      finalValue: serializer.fromJson<double?>(json['finalValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startMonth': serializer.toJson<YearMonth>(startMonth),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'finalValue': serializer.toJson<double?>(finalValue),
    };
  }

  Game copyWith({
    int? id,
    YearMonth? startMonth,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<double?> finalValue = const Value.absent(),
  }) => Game(
    id: id ?? this.id,
    startMonth: startMonth ?? this.startMonth,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    finalValue: finalValue.present ? finalValue.value : this.finalValue,
  );
  Game copyWithCompanion(GameTableCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      startMonth: data.startMonth.present
          ? data.startMonth.value
          : this.startMonth,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      finalValue: data.finalValue.present
          ? data.finalValue.value
          : this.finalValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('startMonth: $startMonth, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('finalValue: $finalValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startMonth, startedAt, endedAt, finalValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.startMonth == this.startMonth &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.finalValue == this.finalValue);
}

class GameTableCompanion extends UpdateCompanion<Game> {
  final Value<int> id;
  final Value<YearMonth> startMonth;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<double?> finalValue;
  const GameTableCompanion({
    this.id = const Value.absent(),
    this.startMonth = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.finalValue = const Value.absent(),
  });
  GameTableCompanion.insert({
    this.id = const Value.absent(),
    required YearMonth startMonth,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.finalValue = const Value.absent(),
  }) : startMonth = Value(startMonth),
       startedAt = Value(startedAt);
  static Insertable<Game> custom({
    Expression<int>? id,
    Expression<int>? startMonth,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<double>? finalValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startMonth != null) 'start_month': startMonth,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (finalValue != null) 'final_value': finalValue,
    });
  }

  GameTableCompanion copyWith({
    Value<int>? id,
    Value<YearMonth>? startMonth,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<double?>? finalValue,
  }) {
    return GameTableCompanion(
      id: id ?? this.id,
      startMonth: startMonth ?? this.startMonth,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      finalValue: finalValue ?? this.finalValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startMonth.present) {
      map['start_month'] = Variable<int>(
        $GameTableTable.$converterstartMonth.toSql(startMonth.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (finalValue.present) {
      map['final_value'] = Variable<double>(finalValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameTableCompanion(')
          ..write('id: $id, ')
          ..write('startMonth: $startMonth, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('finalValue: $finalValue')
          ..write(')'))
        .toString();
  }
}

class $TradeTableTable extends TradeTable
    with TableInfo<$TradeTableTable, Trade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TradeTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES game (id)',
    ),
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<int> assetId = GeneratedColumn<int>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES asset (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TradeType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TradeType>($TradeTableTable.$convertertype);
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<YearMonth, int> month =
      GeneratedColumn<int>(
        'month',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<YearMonth>($TradeTableTable.$convertermonth);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    assetId,
    type,
    quantity,
    price,
    month,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trade';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trade> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trade(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}asset_id'],
      )!,
      type: $TradeTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      month: $TradeTableTable.$convertermonth.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}month'],
        )!,
      ),
    );
  }

  @override
  $TradeTableTable createAlias(String alias) {
    return $TradeTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TradeType, String, String> $convertertype =
      const EnumNameConverter<TradeType>(TradeType.values);
  static TypeConverter<YearMonth, int> $convertermonth =
      const YearMonthConverter();
}

class Trade extends DataClass implements Insertable<Trade> {
  final int id;
  final int gameId;
  final int assetId;
  final TradeType type;
  final double quantity;
  final double price;
  final YearMonth month;
  const Trade({
    required this.id,
    required this.gameId,
    required this.assetId,
    required this.type,
    required this.quantity,
    required this.price,
    required this.month,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['asset_id'] = Variable<int>(assetId);
    {
      map['type'] = Variable<String>(
        $TradeTableTable.$convertertype.toSql(type),
      );
    }
    map['quantity'] = Variable<double>(quantity);
    map['price'] = Variable<double>(price);
    {
      map['month'] = Variable<int>(
        $TradeTableTable.$convertermonth.toSql(month),
      );
    }
    return map;
  }

  TradeTableCompanion toCompanion(bool nullToAbsent) {
    return TradeTableCompanion(
      id: Value(id),
      gameId: Value(gameId),
      assetId: Value(assetId),
      type: Value(type),
      quantity: Value(quantity),
      price: Value(price),
      month: Value(month),
    );
  }

  factory Trade.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trade(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      assetId: serializer.fromJson<int>(json['assetId']),
      type: $TradeTableTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      quantity: serializer.fromJson<double>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      month: serializer.fromJson<YearMonth>(json['month']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'assetId': serializer.toJson<int>(assetId),
      'type': serializer.toJson<String>(
        $TradeTableTable.$convertertype.toJson(type),
      ),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'month': serializer.toJson<YearMonth>(month),
    };
  }

  Trade copyWith({
    int? id,
    int? gameId,
    int? assetId,
    TradeType? type,
    double? quantity,
    double? price,
    YearMonth? month,
  }) => Trade(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    assetId: assetId ?? this.assetId,
    type: type ?? this.type,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    month: month ?? this.month,
  );
  Trade copyWithCompanion(TradeTableCompanion data) {
    return Trade(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      type: data.type.present ? data.type.value : this.type,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      month: data.month.present ? data.month.value : this.month,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trade(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('assetId: $assetId, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('month: $month')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameId, assetId, type, quantity, price, month);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trade &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.assetId == this.assetId &&
          other.type == this.type &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.month == this.month);
}

class TradeTableCompanion extends UpdateCompanion<Trade> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<int> assetId;
  final Value<TradeType> type;
  final Value<double> quantity;
  final Value<double> price;
  final Value<YearMonth> month;
  const TradeTableCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.type = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.month = const Value.absent(),
  });
  TradeTableCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required int assetId,
    required TradeType type,
    required double quantity,
    required double price,
    required YearMonth month,
  }) : gameId = Value(gameId),
       assetId = Value(assetId),
       type = Value(type),
       quantity = Value(quantity),
       price = Value(price),
       month = Value(month);
  static Insertable<Trade> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<int>? assetId,
    Expression<String>? type,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<int>? month,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (assetId != null) 'asset_id': assetId,
      if (type != null) 'type': type,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (month != null) 'month': month,
    });
  }

  TradeTableCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<int>? assetId,
    Value<TradeType>? type,
    Value<double>? quantity,
    Value<double>? price,
    Value<YearMonth>? month,
  }) {
    return TradeTableCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      assetId: assetId ?? this.assetId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      month: month ?? this.month,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<int>(assetId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TradeTableTable.$convertertype.toSql(type.value),
      );
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(
        $TradeTableTable.$convertermonth.toSql(month.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TradeTableCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('assetId: $assetId, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('month: $month')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayerTableTable playerTable = $PlayerTableTable(this);
  late final $AssetTableTable assetTable = $AssetTableTable(this);
  late final $GameTableTable gameTable = $GameTableTable(this);
  late final $TradeTableTable tradeTable = $TradeTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    playerTable,
    assetTable,
    gameTable,
    tradeTable,
  ];
}

typedef $$PlayerTableTableCreateCompanionBuilder =
    PlayerTableCompanion Function({
      Value<int> id,
      required String username,
      required int gems,
      Value<DateTime?> lastDailyPackAt,
    });
typedef $$PlayerTableTableUpdateCompanionBuilder =
    PlayerTableCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<int> gems,
      Value<DateTime?> lastDailyPackAt,
    });

class $$PlayerTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerTableTable> {
  $$PlayerTableTableFilterComposer({
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

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gems => $composableBuilder(
    column: $table.gems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastDailyPackAt => $composableBuilder(
    column: $table.lastDailyPackAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayerTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerTableTable> {
  $$PlayerTableTableOrderingComposer({
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

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gems => $composableBuilder(
    column: $table.gems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastDailyPackAt => $composableBuilder(
    column: $table.lastDailyPackAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayerTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerTableTable> {
  $$PlayerTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<int> get gems =>
      $composableBuilder(column: $table.gems, builder: (column) => column);

  GeneratedColumn<DateTime> get lastDailyPackAt => $composableBuilder(
    column: $table.lastDailyPackAt,
    builder: (column) => column,
  );
}

class $$PlayerTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerTableTable,
          Player,
          $$PlayerTableTableFilterComposer,
          $$PlayerTableTableOrderingComposer,
          $$PlayerTableTableAnnotationComposer,
          $$PlayerTableTableCreateCompanionBuilder,
          $$PlayerTableTableUpdateCompanionBuilder,
          (Player, BaseReferences<_$AppDatabase, $PlayerTableTable, Player>),
          Player,
          PrefetchHooks Function()
        > {
  $$PlayerTableTableTableManager(_$AppDatabase db, $PlayerTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<int> gems = const Value.absent(),
                Value<DateTime?> lastDailyPackAt = const Value.absent(),
              }) => PlayerTableCompanion(
                id: id,
                username: username,
                gems: gems,
                lastDailyPackAt: lastDailyPackAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required int gems,
                Value<DateTime?> lastDailyPackAt = const Value.absent(),
              }) => PlayerTableCompanion.insert(
                id: id,
                username: username,
                gems: gems,
                lastDailyPackAt: lastDailyPackAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlayerTableTable, Player>(table),
                  BaseReferences<_$AppDatabase, $PlayerTableTable, Player>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayerTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerTableTable,
      Player,
      $$PlayerTableTableFilterComposer,
      $$PlayerTableTableOrderingComposer,
      $$PlayerTableTableAnnotationComposer,
      $$PlayerTableTableCreateCompanionBuilder,
      $$PlayerTableTableUpdateCompanionBuilder,
      (Player, BaseReferences<_$AppDatabase, $PlayerTableTable, Player>),
      Player,
      PrefetchHooks Function()
    >;
typedef $$AssetTableTableCreateCompanionBuilder = AssetTableCompanion Function({
  Value<int> id,
  required String symbol,
  required String name,
  required AssetType type,
  required Rarity rarity,
  Value<String?> marketSymbol,
  Value<String?> micCode,
  Value<String?> exchange,
  Value<String?> country,
  Value<String?> currency,
  Value<String?> sector,
  Value<String?> industry,
  Value<String?> description,
  Value<String?> logoUrl,
  Value<int> quantity,
  Value<DateTime?> lastObtainedAt,
});
typedef $$AssetTableTableUpdateCompanionBuilder = AssetTableCompanion Function({
  Value<int> id,
  Value<String> symbol,
  Value<String> name,
  Value<AssetType> type,
  Value<Rarity> rarity,
  Value<String?> marketSymbol,
  Value<String?> micCode,
  Value<String?> exchange,
  Value<String?> country,
  Value<String?> currency,
  Value<String?> sector,
  Value<String?> industry,
  Value<String?> description,
  Value<String?> logoUrl,
  Value<int> quantity,
  Value<DateTime?> lastObtainedAt,
});

final class $$AssetTableTableReferences
    extends BaseReferences<_$AppDatabase, $AssetTableTable, Asset> {
  $$AssetTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TradeTableTable, List<Trade>>
  _tradeTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tradeTable,
    aliasName: 'asset__id__trade__asset_id',
  );

  $$TradeTableTableProcessedTableManager get tradeTableRefs {
    final manager = $$TradeTableTableTableManager(
      $_db,
      $_db.tradeTable,
    ).filter((f) => f.assetId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tradeTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AssetTableTableFilterComposer
    extends Composer<_$AppDatabase, $AssetTableTable> {
  $$AssetTableTableFilterComposer({
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

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AssetType, AssetType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Rarity, Rarity, String> get rarity =>
      $composableBuilder(
        column: $table.rarity,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get marketSymbol => $composableBuilder(
    column: $table.marketSymbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get micCode => $composableBuilder(
    column: $table.micCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exchange => $composableBuilder(
    column: $table.exchange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sector => $composableBuilder(
    column: $table.sector,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get industry => $composableBuilder(
    column: $table.industry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastObtainedAt => $composableBuilder(
    column: $table.lastObtainedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tradeTableRefs(
    Expression<bool> Function($$TradeTableTableFilterComposer f) f,
  ) {
    final $$TradeTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tradeTable,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TradeTableTableFilterComposer(
            $db: $db,
            $table: $db.tradeTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetTableTable> {
  $$AssetTableTableOrderingComposer({
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

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marketSymbol => $composableBuilder(
    column: $table.marketSymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get micCode => $composableBuilder(
    column: $table.micCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exchange => $composableBuilder(
    column: $table.exchange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sector => $composableBuilder(
    column: $table.sector,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get industry => $composableBuilder(
    column: $table.industry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastObtainedAt => $composableBuilder(
    column: $table.lastObtainedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetTableTable> {
  $$AssetTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AssetType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Rarity, String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<String> get marketSymbol => $composableBuilder(
    column: $table.marketSymbol,
    builder: (column) => column,
  );

  GeneratedColumn<String> get micCode =>
      $composableBuilder(column: $table.micCode, builder: (column) => column);

  GeneratedColumn<String> get exchange =>
      $composableBuilder(column: $table.exchange, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get sector =>
      $composableBuilder(column: $table.sector, builder: (column) => column);

  GeneratedColumn<String> get industry =>
      $composableBuilder(column: $table.industry, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get lastObtainedAt => $composableBuilder(
    column: $table.lastObtainedAt,
    builder: (column) => column,
  );

  Expression<T> tradeTableRefs<T extends Object>(
    Expression<T> Function($$TradeTableTableAnnotationComposer a) f,
  ) {
    final $$TradeTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tradeTable,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TradeTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tradeTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetTableTable,
          Asset,
          $$AssetTableTableFilterComposer,
          $$AssetTableTableOrderingComposer,
          $$AssetTableTableAnnotationComposer,
          $$AssetTableTableCreateCompanionBuilder,
          $$AssetTableTableUpdateCompanionBuilder,
          (Asset, $$AssetTableTableReferences),
          Asset,
          PrefetchHooks Function({bool tradeTableRefs})
        > {
  $$AssetTableTableTableManager(_$AppDatabase db, $AssetTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AssetType> type = const Value.absent(),
                Value<Rarity> rarity = const Value.absent(),
                Value<String?> marketSymbol = const Value.absent(),
                Value<String?> micCode = const Value.absent(),
                Value<String?> exchange = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> sector = const Value.absent(),
                Value<String?> industry = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<DateTime?> lastObtainedAt = const Value.absent(),
              }) => AssetTableCompanion(
                id: id,
                symbol: symbol,
                name: name,
                type: type,
                rarity: rarity,
                marketSymbol: marketSymbol,
                micCode: micCode,
                exchange: exchange,
                country: country,
                currency: currency,
                sector: sector,
                industry: industry,
                description: description,
                logoUrl: logoUrl,
                quantity: quantity,
                lastObtainedAt: lastObtainedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String symbol,
                required String name,
                required AssetType type,
                required Rarity rarity,
                Value<String?> marketSymbol = const Value.absent(),
                Value<String?> micCode = const Value.absent(),
                Value<String?> exchange = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> sector = const Value.absent(),
                Value<String?> industry = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<DateTime?> lastObtainedAt = const Value.absent(),
              }) => AssetTableCompanion.insert(
                id: id,
                symbol: symbol,
                name: name,
                type: type,
                rarity: rarity,
                marketSymbol: marketSymbol,
                micCode: micCode,
                exchange: exchange,
                country: country,
                currency: currency,
                sector: sector,
                industry: industry,
                description: description,
                logoUrl: logoUrl,
                quantity: quantity,
                lastObtainedAt: lastObtainedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssetTableTable, Asset>(table),
                  $$AssetTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tradeTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tradeTableRefs) db.tradeTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tradeTableRefs)
                    await $_getPrefetchedData<Asset, $AssetTableTable, Trade>(
                      currentTable: table,
                      referencedTable: $$AssetTableTableReferences
                          ._tradeTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AssetTableTableReferences(
                            db,
                            table,
                            p0,
                          ).tradeTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.assetId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AssetTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetTableTable,
      Asset,
      $$AssetTableTableFilterComposer,
      $$AssetTableTableOrderingComposer,
      $$AssetTableTableAnnotationComposer,
      $$AssetTableTableCreateCompanionBuilder,
      $$AssetTableTableUpdateCompanionBuilder,
      (Asset, $$AssetTableTableReferences),
      Asset,
      PrefetchHooks Function({bool tradeTableRefs})
    >;
typedef $$GameTableTableCreateCompanionBuilder = GameTableCompanion Function({
  Value<int> id,
  required YearMonth startMonth,
  required DateTime startedAt,
  Value<DateTime?> endedAt,
  Value<double?> finalValue,
});
typedef $$GameTableTableUpdateCompanionBuilder = GameTableCompanion Function({
  Value<int> id,
  Value<YearMonth> startMonth,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<double?> finalValue,
});

final class $$GameTableTableReferences
    extends BaseReferences<_$AppDatabase, $GameTableTable, Game> {
  $$GameTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TradeTableTable, List<Trade>>
  _tradeTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tradeTable,
    aliasName: 'game__id__trade__game_id',
  );

  $$TradeTableTableProcessedTableManager get tradeTableRefs {
    final manager = $$TradeTableTableTableManager(
      $_db,
      $_db.tradeTable,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tradeTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GameTableTableFilterComposer
    extends Composer<_$AppDatabase, $GameTableTable> {
  $$GameTableTableFilterComposer({
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

  ColumnWithTypeConverterFilters<YearMonth, YearMonth, int> get startMonth =>
      $composableBuilder(
        column: $table.startMonth,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get finalValue => $composableBuilder(
    column: $table.finalValue,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tradeTableRefs(
    Expression<bool> Function($$TradeTableTableFilterComposer f) f,
  ) {
    final $$TradeTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tradeTable,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TradeTableTableFilterComposer(
            $db: $db,
            $table: $db.tradeTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GameTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GameTableTable> {
  $$GameTableTableOrderingComposer({
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

  ColumnOrderings<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get finalValue => $composableBuilder(
    column: $table.finalValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameTableTable> {
  $$GameTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<YearMonth, int> get startMonth =>
      $composableBuilder(
        column: $table.startMonth,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<double> get finalValue => $composableBuilder(
    column: $table.finalValue,
    builder: (column) => column,
  );

  Expression<T> tradeTableRefs<T extends Object>(
    Expression<T> Function($$TradeTableTableAnnotationComposer a) f,
  ) {
    final $$TradeTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tradeTable,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TradeTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tradeTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GameTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameTableTable,
          Game,
          $$GameTableTableFilterComposer,
          $$GameTableTableOrderingComposer,
          $$GameTableTableAnnotationComposer,
          $$GameTableTableCreateCompanionBuilder,
          $$GameTableTableUpdateCompanionBuilder,
          (Game, $$GameTableTableReferences),
          Game,
          PrefetchHooks Function({bool tradeTableRefs})
        > {
  $$GameTableTableTableManager(_$AppDatabase db, $GameTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<YearMonth> startMonth = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<double?> finalValue = const Value.absent(),
              }) => GameTableCompanion(
                id: id,
                startMonth: startMonth,
                startedAt: startedAt,
                endedAt: endedAt,
                finalValue: finalValue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required YearMonth startMonth,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<double?> finalValue = const Value.absent(),
              }) => GameTableCompanion.insert(
                id: id,
                startMonth: startMonth,
                startedAt: startedAt,
                endedAt: endedAt,
                finalValue: finalValue,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GameTableTable, Game>(table),
                  $$GameTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tradeTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tradeTableRefs) db.tradeTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tradeTableRefs)
                    await $_getPrefetchedData<Game, $GameTableTable, Trade>(
                      currentTable: table,
                      referencedTable: $$GameTableTableReferences
                          ._tradeTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GameTableTableReferences(
                            db,
                            table,
                            p0,
                          ).tradeTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.gameId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GameTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameTableTable,
      Game,
      $$GameTableTableFilterComposer,
      $$GameTableTableOrderingComposer,
      $$GameTableTableAnnotationComposer,
      $$GameTableTableCreateCompanionBuilder,
      $$GameTableTableUpdateCompanionBuilder,
      (Game, $$GameTableTableReferences),
      Game,
      PrefetchHooks Function({bool tradeTableRefs})
    >;
typedef $$TradeTableTableCreateCompanionBuilder = TradeTableCompanion Function({
  Value<int> id,
  required int gameId,
  required int assetId,
  required TradeType type,
  required double quantity,
  required double price,
  required YearMonth month,
});
typedef $$TradeTableTableUpdateCompanionBuilder = TradeTableCompanion Function({
  Value<int> id,
  Value<int> gameId,
  Value<int> assetId,
  Value<TradeType> type,
  Value<double> quantity,
  Value<double> price,
  Value<YearMonth> month,
});

final class $$TradeTableTableReferences
    extends BaseReferences<_$AppDatabase, $TradeTableTable, Trade> {
  $$TradeTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GameTableTable _gameIdTable(_$AppDatabase db) =>
      db.gameTable.createAlias('trade__game_id__game__id');

  $$GameTableTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GameTableTableTableManager(
      $_db,
      $_db.gameTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AssetTableTable _assetIdTable(_$AppDatabase db) =>
      db.assetTable.createAlias('trade__asset_id__asset__id');

  $$AssetTableTableProcessedTableManager get assetId {
    final $_column = $_itemColumn<int>('asset_id')!;

    final manager = $$AssetTableTableTableManager(
      $_db,
      $_db.assetTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TradeTableTableFilterComposer
    extends Composer<_$AppDatabase, $TradeTableTable> {
  $$TradeTableTableFilterComposer({
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

  ColumnWithTypeConverterFilters<TradeType, TradeType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<YearMonth, YearMonth, int> get month =>
      $composableBuilder(
        column: $table.month,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$GameTableTableFilterComposer get gameId {
    final $$GameTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.gameTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameTableTableFilterComposer(
            $db: $db,
            $table: $db.gameTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetTableTableFilterComposer get assetId {
    final $$AssetTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assetTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetTableTableFilterComposer(
            $db: $db,
            $table: $db.assetTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TradeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TradeTableTable> {
  $$TradeTableTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  $$GameTableTableOrderingComposer get gameId {
    final $$GameTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.gameTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameTableTableOrderingComposer(
            $db: $db,
            $table: $db.gameTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetTableTableOrderingComposer get assetId {
    final $$AssetTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assetTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetTableTableOrderingComposer(
            $db: $db,
            $table: $db.assetTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TradeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TradeTableTable> {
  $$TradeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TradeType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumnWithTypeConverter<YearMonth, int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  $$GameTableTableAnnotationComposer get gameId {
    final $$GameTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.gameTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameTableTableAnnotationComposer(
            $db: $db,
            $table: $db.gameTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetTableTableAnnotationComposer get assetId {
    final $$AssetTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assetTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetTableTableAnnotationComposer(
            $db: $db,
            $table: $db.assetTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TradeTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TradeTableTable,
          Trade,
          $$TradeTableTableFilterComposer,
          $$TradeTableTableOrderingComposer,
          $$TradeTableTableAnnotationComposer,
          $$TradeTableTableCreateCompanionBuilder,
          $$TradeTableTableUpdateCompanionBuilder,
          (Trade, $$TradeTableTableReferences),
          Trade,
          PrefetchHooks Function({bool gameId, bool assetId})
        > {
  $$TradeTableTableTableManager(_$AppDatabase db, $TradeTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TradeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TradeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TradeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> assetId = const Value.absent(),
                Value<TradeType> type = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<YearMonth> month = const Value.absent(),
              }) => TradeTableCompanion(
                id: id,
                gameId: gameId,
                assetId: assetId,
                type: type,
                quantity: quantity,
                price: price,
                month: month,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required int assetId,
                required TradeType type,
                required double quantity,
                required double price,
                required YearMonth month,
              }) => TradeTableCompanion.insert(
                id: id,
                gameId: gameId,
                assetId: assetId,
                type: type,
                quantity: quantity,
                price: price,
                month: month,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TradeTableTable, Trade>(table),
                  $$TradeTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false, assetId = false}) {
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
                    if (gameId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.gameId,
                        referencedTable: $$TradeTableTableReferences
                            ._gameIdTable(db),
                        referencedColumn: $$TradeTableTableReferences
                            ._gameIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (assetId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.assetId,
                        referencedTable: $$TradeTableTableReferences
                            ._assetIdTable(db),
                        referencedColumn: $$TradeTableTableReferences
                            ._assetIdTable(db)
                            .id,
                      ) as T;
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

typedef $$TradeTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TradeTableTable,
      Trade,
      $$TradeTableTableFilterComposer,
      $$TradeTableTableOrderingComposer,
      $$TradeTableTableAnnotationComposer,
      $$TradeTableTableCreateCompanionBuilder,
      $$TradeTableTableUpdateCompanionBuilder,
      (Trade, $$TradeTableTableReferences),
      Trade,
      PrefetchHooks Function({bool gameId, bool assetId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayerTableTableTableManager get playerTable =>
      $$PlayerTableTableTableManager(_db, _db.playerTable);
  $$AssetTableTableTableManager get assetTable =>
      $$AssetTableTableTableManager(_db, _db.assetTable);
  $$GameTableTableTableManager get gameTable =>
      $$GameTableTableTableManager(_db, _db.gameTable);
  $$TradeTableTableTableManager get tradeTable =>
      $$TradeTableTableTableManager(_db, _db.tradeTable);
}
