// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pve_nodes_network_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BridgeType _$bridge = const BridgeType._('bridge');
const BridgeType _$bond = const BridgeType._('bond');
const BridgeType _$eth = const BridgeType._('eth');
const BridgeType _$alias = const BridgeType._('alias');
const BridgeType _$vlan = const BridgeType._('vlan');
const BridgeType _$ovsBridge = const BridgeType._('ovsBridge');
const BridgeType _$ovsBond = const BridgeType._('ovsBond');
const BridgeType _$ovsPort = const BridgeType._('ovsPort');
const BridgeType _$ovsIntPort = const BridgeType._('ovsIntPort');

BridgeType _$bridgeTypeValueOf(String name) {
  switch (name) {
    case 'bridge':
      return _$bridge;
    case 'bond':
      return _$bond;
    case 'eth':
      return _$eth;
    case 'alias':
      return _$alias;
    case 'vlan':
      return _$vlan;
    case 'ovsBridge':
      return _$ovsBridge;
    case 'ovsBond':
      return _$ovsBond;
    case 'ovsPort':
      return _$ovsPort;
    case 'ovsIntPort':
      return _$ovsIntPort;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<BridgeType> _$bridgeTypeValues =
    new BuiltSet<BridgeType>(const <BridgeType>[
  _$bridge,
  _$bond,
  _$eth,
  _$alias,
  _$vlan,
  _$ovsBridge,
  _$ovsBond,
  _$ovsPort,
  _$ovsIntPort,
]);

Serializer<PveNodeNetworkReadModel> _$pveNodeNetworkReadModelSerializer =
    new _$PveNodeNetworkReadModelSerializer();
Serializer<BridgeType> _$bridgeTypeSerializer = new _$BridgeTypeSerializer();

class _$PveNodeNetworkReadModelSerializer
    implements StructuredSerializer<PveNodeNetworkReadModel> {
  @override
  final Iterable<Type> types = const [
    PveNodeNetworkReadModel,
    _$PveNodeNetworkReadModel
  ];
  @override
  final String wireName = 'PveNodeNetworkReadModel';

  @override
  Iterable<Object> serialize(
      Serializers serializers, PveNodeNetworkReadModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'active',
      serializers.serialize(object.active, specifiedType: const FullType(bool)),
      'address',
      serializers.serialize(object.address,
          specifiedType: const FullType(String)),
      'autostart',
      serializers.serialize(object.autostart,
          specifiedType: const FullType(bool)),
      'bridge_fd',
      serializers.serialize(object.bridgeForwardDelay,
          specifiedType: const FullType(String)),
      'bridge_ports',
      serializers.serialize(object.bridgePorts,
          specifiedType: const FullType(String)),
      'bridge_stp',
      serializers.serialize(object.bridgeStp,
          specifiedType: const FullType(String)),
      'cidr',
      serializers.serialize(object.cidr, specifiedType: const FullType(String)),
      'gateway',
      serializers.serialize(object.gateway,
          specifiedType: const FullType(String)),
      'iface',
      serializers.serialize(object.iface,
          specifiedType: const FullType(String)),
      'method',
      serializers.serialize(object.method,
          specifiedType: const FullType(String)),
      'method6',
      serializers.serialize(object.method6,
          specifiedType: const FullType(String)),
      'netmask',
      serializers.serialize(object.netmask,
          specifiedType: const FullType(String)),
      'priority',
      serializers.serialize(object.priority,
          specifiedType: const FullType(int)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(BridgeType)),
    ];
    if (object.comment != null) {
      result
        ..add('comment')
        ..add(serializers.serialize(object.comment,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  PveNodeNetworkReadModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PveNodeNetworkReadModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'active':
          result.active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'address':
          result.address = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'autostart':
          result.autostart = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'bridge_fd':
          result.bridgeForwardDelay = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'bridge_ports':
          result.bridgePorts = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'bridge_stp':
          result.bridgeStp = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'cidr':
          result.cidr = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'gateway':
          result.gateway = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'iface':
          result.iface = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'method':
          result.method = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'method6':
          result.method6 = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'netmask':
          result.netmask = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'priority':
          result.priority = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(BridgeType)) as BridgeType;
          break;
        case 'comment':
          result.comment = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BridgeTypeSerializer implements PrimitiveSerializer<BridgeType> {
  @override
  final Iterable<Type> types = const <Type>[BridgeType];
  @override
  final String wireName = 'type';

  @override
  Object serialize(Serializers serializers, BridgeType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  BridgeType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BridgeType.valueOf(serialized as String);
}

class _$PveNodeNetworkReadModel extends PveNodeNetworkReadModel {
  @override
  final bool active;
  @override
  final String address;
  @override
  final bool autostart;
  @override
  final String bridgeForwardDelay;
  @override
  final String bridgePorts;
  @override
  final String bridgeStp;
  @override
  final String cidr;
  @override
  final String gateway;
  @override
  final String iface;
  @override
  final String method;
  @override
  final String method6;
  @override
  final String netmask;
  @override
  final int priority;
  @override
  final BridgeType type;
  @override
  final String comment;

  factory _$PveNodeNetworkReadModel(
          [void Function(PveNodeNetworkReadModelBuilder) updates]) =>
      (new PveNodeNetworkReadModelBuilder()..update(updates)).build();

  _$PveNodeNetworkReadModel._(
      {this.active,
      this.address,
      this.autostart,
      this.bridgeForwardDelay,
      this.bridgePorts,
      this.bridgeStp,
      this.cidr,
      this.gateway,
      this.iface,
      this.method,
      this.method6,
      this.netmask,
      this.priority,
      this.type,
      this.comment})
      : super._() {
    if (active == null) {
      throw new BuiltValueNullFieldError('PveNodeNetworkReadModel', 'active');
    }
    if (address == null) {
      throw new BuiltValueNullFieldError('PveNodeNetworkReadModel', 'address');
    }
    if (autostart == null) {
      throw new BuiltValueNullFieldError(
          'PveNodeNetworkReadModel', 'autostart');
    }
    if (bridgeForwardDelay == null) {
      throw new BuiltValueNullFieldError(
          'PveNodeNetworkReadModel', 'bridgeForwardDelay');
    }
    if (bridgePorts == null) {
      throw new BuiltValueNullFieldError(
          'PveNodeNetworkReadModel', 'bridgePorts');
    }
    if (bridgeStp == null) {
      throw new BuiltValueNullFieldError(
          'PveNodeNetworkReadModel', 'bridgeStp');
    }
    if (cidr == null) {
      throw new BuiltValueNullFieldError('PveNodeNetworkReadModel', 'cidr');
    }
    if (gateway == null) {
      throw new BuiltValueNullFieldError('PveNodeNetworkReadModel', 'gateway');
    }
    if (iface == null) {
      throw new BuiltValueNullFieldError('PveNodeNetworkReadModel', 'iface');
    }
    if (method == null) {
      throw new BuiltValueNullFieldError('PveNodeNetworkReadModel', 'method');
    }
    if (method6 == null) {
      throw new BuiltValueNullFieldError('PveNodeNetworkReadModel', 'method6');
    }
    if (netmask == null) {
      throw new BuiltValueNullFieldError('PveNodeNetworkReadModel', 'netmask');
    }
    if (priority == null) {
      throw new BuiltValueNullFieldError('PveNodeNetworkReadModel', 'priority');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('PveNodeNetworkReadModel', 'type');
    }
  }

  @override
  PveNodeNetworkReadModel rebuild(
          void Function(PveNodeNetworkReadModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PveNodeNetworkReadModelBuilder toBuilder() =>
      new PveNodeNetworkReadModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PveNodeNetworkReadModel &&
        active == other.active &&
        address == other.address &&
        autostart == other.autostart &&
        bridgeForwardDelay == other.bridgeForwardDelay &&
        bridgePorts == other.bridgePorts &&
        bridgeStp == other.bridgeStp &&
        cidr == other.cidr &&
        gateway == other.gateway &&
        iface == other.iface &&
        method == other.method &&
        method6 == other.method6 &&
        netmask == other.netmask &&
        priority == other.priority &&
        type == other.type &&
        comment == other.comment;
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
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                0,
                                                                active
                                                                    .hashCode),
                                                            address.hashCode),
                                                        autostart.hashCode),
                                                    bridgeForwardDelay
                                                        .hashCode),
                                                bridgePorts.hashCode),
                                            bridgeStp.hashCode),
                                        cidr.hashCode),
                                    gateway.hashCode),
                                iface.hashCode),
                            method.hashCode),
                        method6.hashCode),
                    netmask.hashCode),
                priority.hashCode),
            type.hashCode),
        comment.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PveNodeNetworkReadModel')
          ..add('active', active)
          ..add('address', address)
          ..add('autostart', autostart)
          ..add('bridgeForwardDelay', bridgeForwardDelay)
          ..add('bridgePorts', bridgePorts)
          ..add('bridgeStp', bridgeStp)
          ..add('cidr', cidr)
          ..add('gateway', gateway)
          ..add('iface', iface)
          ..add('method', method)
          ..add('method6', method6)
          ..add('netmask', netmask)
          ..add('priority', priority)
          ..add('type', type)
          ..add('comment', comment))
        .toString();
  }
}

class PveNodeNetworkReadModelBuilder
    implements
        Builder<PveNodeNetworkReadModel, PveNodeNetworkReadModelBuilder> {
  _$PveNodeNetworkReadModel _$v;

  bool _active;
  bool get active => _$this._active;
  set active(bool active) => _$this._active = active;

  String _address;
  String get address => _$this._address;
  set address(String address) => _$this._address = address;

  bool _autostart;
  bool get autostart => _$this._autostart;
  set autostart(bool autostart) => _$this._autostart = autostart;

  String _bridgeForwardDelay;
  String get bridgeForwardDelay => _$this._bridgeForwardDelay;
  set bridgeForwardDelay(String bridgeForwardDelay) =>
      _$this._bridgeForwardDelay = bridgeForwardDelay;

  String _bridgePorts;
  String get bridgePorts => _$this._bridgePorts;
  set bridgePorts(String bridgePorts) => _$this._bridgePorts = bridgePorts;

  String _bridgeStp;
  String get bridgeStp => _$this._bridgeStp;
  set bridgeStp(String bridgeStp) => _$this._bridgeStp = bridgeStp;

  String _cidr;
  String get cidr => _$this._cidr;
  set cidr(String cidr) => _$this._cidr = cidr;

  String _gateway;
  String get gateway => _$this._gateway;
  set gateway(String gateway) => _$this._gateway = gateway;

  String _iface;
  String get iface => _$this._iface;
  set iface(String iface) => _$this._iface = iface;

  String _method;
  String get method => _$this._method;
  set method(String method) => _$this._method = method;

  String _method6;
  String get method6 => _$this._method6;
  set method6(String method6) => _$this._method6 = method6;

  String _netmask;
  String get netmask => _$this._netmask;
  set netmask(String netmask) => _$this._netmask = netmask;

  int _priority;
  int get priority => _$this._priority;
  set priority(int priority) => _$this._priority = priority;

  BridgeType _type;
  BridgeType get type => _$this._type;
  set type(BridgeType type) => _$this._type = type;

  String _comment;
  String get comment => _$this._comment;
  set comment(String comment) => _$this._comment = comment;

  PveNodeNetworkReadModelBuilder();

  PveNodeNetworkReadModelBuilder get _$this {
    if (_$v != null) {
      _active = _$v.active;
      _address = _$v.address;
      _autostart = _$v.autostart;
      _bridgeForwardDelay = _$v.bridgeForwardDelay;
      _bridgePorts = _$v.bridgePorts;
      _bridgeStp = _$v.bridgeStp;
      _cidr = _$v.cidr;
      _gateway = _$v.gateway;
      _iface = _$v.iface;
      _method = _$v.method;
      _method6 = _$v.method6;
      _netmask = _$v.netmask;
      _priority = _$v.priority;
      _type = _$v.type;
      _comment = _$v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PveNodeNetworkReadModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PveNodeNetworkReadModel;
  }

  @override
  void update(void Function(PveNodeNetworkReadModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PveNodeNetworkReadModel build() {
    final _$result = _$v ??
        new _$PveNodeNetworkReadModel._(
            active: active,
            address: address,
            autostart: autostart,
            bridgeForwardDelay: bridgeForwardDelay,
            bridgePorts: bridgePorts,
            bridgeStp: bridgeStp,
            cidr: cidr,
            gateway: gateway,
            iface: iface,
            method: method,
            method6: method6,
            netmask: netmask,
            priority: priority,
            type: type,
            comment: comment);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
