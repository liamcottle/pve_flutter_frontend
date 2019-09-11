import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pve_nodes_model.g.dart';

abstract class PveNodesModel
    implements Built<PveNodesModel, PveNodesModelBuilder> {
  static Serializer<PveNodesModel> get serializer => _$pveNodesModelSerializer;

  @BuiltValueField(wireName: 'cpu')
  @nullable
  double get cpuUsage;

  @BuiltValueField(wireName: 'level')
  @nullable
  String get subscription;

  @BuiltValueField(wireName: 'maxcpu')
  @nullable
  int get cpuCount;

  @BuiltValueField(wireName: 'maxmem')
  @nullable
  int get memoryCount;

  @BuiltValueField(wireName: 'mem')
  @nullable
  int get memoryUsage;

  @BuiltValueField(wireName: 'node')
  String get nodeName;

  @BuiltValueField(wireName: 'ssl_fingerprint')
  @nullable
  String get sslFingerprint;

  String get status;

  @nullable
  Duration get uptime;

  factory PveNodesModel([void Function(PveNodesModelBuilder) updates]) =
      _$PveNodesModel;
  PveNodesModel._();

  String renderMemoryUsagePercent() {
    if (memoryUsage == -1) {
      return '';
    }
    if (memoryUsage > 1) {
      // we got no percentage but bytes
      if (uptime == null || memoryCount == 0) {
        return '';
      }

      return ((memoryUsage * 100) / memoryCount).toStringAsFixed(1) + " %";
    }
    return (memoryUsage * 100).toStringAsFixed(1) + " %";
  }

  String renderCpuUsage() {
    if (uptime == null) {
      return '';
    }

    return (cpuUsage * 100).toStringAsFixed(1) +
        '% of ' +
        cpuCount.toString() +
        (cpuCount > 1 ? 'CPUs' : 'CPU');
  }
}
