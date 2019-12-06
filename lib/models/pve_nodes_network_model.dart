import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pve_nodes_network_model.g.dart';

abstract class PveNodeNetworkReadModel
    implements Built<PveNodeNetworkReadModel, PveNodeNetworkReadModelBuilder> {
  static Serializer<PveNodeNetworkReadModel> get serializer =>
      _$pveNodeNetworkReadModelSerializer;

  PveNodeNetworkReadModel._();
  factory PveNodeNetworkReadModel(
          [void Function(PveNodeNetworkReadModelBuilder) updates]) =
      _$PveNodeNetworkReadModel;

  bool get active;
  String get address;
  bool get autostart;
  @BuiltValueField(wireName: 'bridge_fd')
  String get bridgeForwardDelay;
  @BuiltValueField(wireName: 'bridge_ports')
  String get bridgePorts;
  @BuiltValueField(wireName: 'bridge_stp')
  String get bridgeStp;
  String get cidr;
  String get gateway;
  String get iface;
  String get method;
  String get method6;
  String get netmask;
  int get priority;
  BridgeType get type;
  @nullable
  String get comment;
}

@BuiltValueEnum(wireName: 'type')
class BridgeType extends EnumClass {
  static Serializer<BridgeType> get serializer => _$bridgeTypeSerializer;

  static const BridgeType bridge = _$bridge;
  static const BridgeType bond = _$bond;
  static const BridgeType eth = _$eth;
  static const BridgeType alias = _$alias;
  static const BridgeType vlan = _$vlan;
  @BuiltValueField(wireName: 'OVSBridge')
  static const BridgeType ovsBridge = _$ovsBridge;
  @BuiltValueField(wireName: 'OVSBond')
  static const BridgeType ovsBond = _$ovsBond;
  @BuiltValueField(wireName: 'OVSPort')
  static const BridgeType ovsPort = _$ovsPort;
  @BuiltValueField(wireName: 'OVSIntPort')
  static const BridgeType ovsIntPort = _$ovsIntPort;

  const BridgeType._(String name) : super(name);

  static BuiltSet<BridgeType> get values => _$bridgeTypeValues;
  static BridgeType valueOf(String name) => _$bridgeTypeValueOf(name);
}
