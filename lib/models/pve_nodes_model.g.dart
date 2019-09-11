// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pve_nodes_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PveNodesModel> _$pveNodesModelSerializer =
    new _$PveNodesModelSerializer();

class _$PveNodesModelSerializer implements StructuredSerializer<PveNodesModel> {
  @override
  final Iterable<Type> types = const [PveNodesModel, _$PveNodesModel];
  @override
  final String wireName = 'PveNodesModel';

  @override
  Iterable<Object> serialize(Serializers serializers, PveNodesModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'node',
      serializers.serialize(object.nodeName,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
    ];
    if (object.cpuUsage != null) {
      result
        ..add('cpu')
        ..add(serializers.serialize(object.cpuUsage,
            specifiedType: const FullType(double)));
    }
    if (object.subscription != null) {
      result
        ..add('level')
        ..add(serializers.serialize(object.subscription,
            specifiedType: const FullType(String)));
    }
    if (object.cpuCount != null) {
      result
        ..add('maxcpu')
        ..add(serializers.serialize(object.cpuCount,
            specifiedType: const FullType(int)));
    }
    if (object.memoryCount != null) {
      result
        ..add('maxmem')
        ..add(serializers.serialize(object.memoryCount,
            specifiedType: const FullType(int)));
    }
    if (object.memoryUsage != null) {
      result
        ..add('mem')
        ..add(serializers.serialize(object.memoryUsage,
            specifiedType: const FullType(int)));
    }
    if (object.sslFingerprint != null) {
      result
        ..add('ssl_fingerprint')
        ..add(serializers.serialize(object.sslFingerprint,
            specifiedType: const FullType(String)));
    }
    if (object.uptime != null) {
      result
        ..add('uptime')
        ..add(serializers.serialize(object.uptime,
            specifiedType: const FullType(Duration)));
    }
    return result;
  }

  @override
  PveNodesModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PveNodesModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'cpu':
          result.cpuUsage = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'level':
          result.subscription = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'maxcpu':
          result.cpuCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'maxmem':
          result.memoryCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'mem':
          result.memoryUsage = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'node':
          result.nodeName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'ssl_fingerprint':
          result.sslFingerprint = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'uptime':
          result.uptime = serializers.deserialize(value,
              specifiedType: const FullType(Duration)) as Duration;
          break;
      }
    }

    return result.build();
  }
}

class _$PveNodesModel extends PveNodesModel {
  @override
  final double cpuUsage;
  @override
  final String subscription;
  @override
  final int cpuCount;
  @override
  final int memoryCount;
  @override
  final int memoryUsage;
  @override
  final String nodeName;
  @override
  final String sslFingerprint;
  @override
  final String status;
  @override
  final Duration uptime;

  factory _$PveNodesModel([void Function(PveNodesModelBuilder) updates]) =>
      (new PveNodesModelBuilder()..update(updates)).build();

  _$PveNodesModel._(
      {this.cpuUsage,
      this.subscription,
      this.cpuCount,
      this.memoryCount,
      this.memoryUsage,
      this.nodeName,
      this.sslFingerprint,
      this.status,
      this.uptime})
      : super._() {
    if (nodeName == null) {
      throw new BuiltValueNullFieldError('PveNodesModel', 'nodeName');
    }
    if (status == null) {
      throw new BuiltValueNullFieldError('PveNodesModel', 'status');
    }
  }

  @override
  PveNodesModel rebuild(void Function(PveNodesModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PveNodesModelBuilder toBuilder() => new PveNodesModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PveNodesModel &&
        cpuUsage == other.cpuUsage &&
        subscription == other.subscription &&
        cpuCount == other.cpuCount &&
        memoryCount == other.memoryCount &&
        memoryUsage == other.memoryUsage &&
        nodeName == other.nodeName &&
        sslFingerprint == other.sslFingerprint &&
        status == other.status &&
        uptime == other.uptime;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc($jc(0, cpuUsage.hashCode),
                                    subscription.hashCode),
                                cpuCount.hashCode),
                            memoryCount.hashCode),
                        memoryUsage.hashCode),
                    nodeName.hashCode),
                sslFingerprint.hashCode),
            status.hashCode),
        uptime.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PveNodesModel')
          ..add('cpuUsage', cpuUsage)
          ..add('subscription', subscription)
          ..add('cpuCount', cpuCount)
          ..add('memoryCount', memoryCount)
          ..add('memoryUsage', memoryUsage)
          ..add('nodeName', nodeName)
          ..add('sslFingerprint', sslFingerprint)
          ..add('status', status)
          ..add('uptime', uptime))
        .toString();
  }
}

class PveNodesModelBuilder
    implements Builder<PveNodesModel, PveNodesModelBuilder> {
  _$PveNodesModel _$v;

  double _cpuUsage;
  double get cpuUsage => _$this._cpuUsage;
  set cpuUsage(double cpuUsage) => _$this._cpuUsage = cpuUsage;

  String _subscription;
  String get subscription => _$this._subscription;
  set subscription(String subscription) => _$this._subscription = subscription;

  int _cpuCount;
  int get cpuCount => _$this._cpuCount;
  set cpuCount(int cpuCount) => _$this._cpuCount = cpuCount;

  int _memoryCount;
  int get memoryCount => _$this._memoryCount;
  set memoryCount(int memoryCount) => _$this._memoryCount = memoryCount;

  int _memoryUsage;
  int get memoryUsage => _$this._memoryUsage;
  set memoryUsage(int memoryUsage) => _$this._memoryUsage = memoryUsage;

  String _nodeName;
  String get nodeName => _$this._nodeName;
  set nodeName(String nodeName) => _$this._nodeName = nodeName;

  String _sslFingerprint;
  String get sslFingerprint => _$this._sslFingerprint;
  set sslFingerprint(String sslFingerprint) =>
      _$this._sslFingerprint = sslFingerprint;

  String _status;
  String get status => _$this._status;
  set status(String status) => _$this._status = status;

  Duration _uptime;
  Duration get uptime => _$this._uptime;
  set uptime(Duration uptime) => _$this._uptime = uptime;

  PveNodesModelBuilder();

  PveNodesModelBuilder get _$this {
    if (_$v != null) {
      _cpuUsage = _$v.cpuUsage;
      _subscription = _$v.subscription;
      _cpuCount = _$v.cpuCount;
      _memoryCount = _$v.memoryCount;
      _memoryUsage = _$v.memoryUsage;
      _nodeName = _$v.nodeName;
      _sslFingerprint = _$v.sslFingerprint;
      _status = _$v.status;
      _uptime = _$v.uptime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PveNodesModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PveNodesModel;
  }

  @override
  void update(void Function(PveNodesModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PveNodesModel build() {
    final _$result = _$v ??
        new _$PveNodesModel._(
            cpuUsage: cpuUsage,
            subscription: subscription,
            cpuCount: cpuCount,
            memoryCount: memoryCount,
            memoryUsage: memoryUsage,
            nodeName: nodeName,
            sslFingerprint: sslFingerprint,
            status: status,
            uptime: uptime);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
