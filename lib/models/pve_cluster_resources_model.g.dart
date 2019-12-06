// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pve_cluster_resources_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PveClusterResourcesModel> _$pveClusterResourcesModelSerializer =
    new _$PveClusterResourcesModelSerializer();

class _$PveClusterResourcesModelSerializer
    implements StructuredSerializer<PveClusterResourcesModel> {
  @override
  final Iterable<Type> types = const [
    PveClusterResourcesModel,
    _$PveClusterResourcesModel
  ];
  @override
  final String wireName = 'PveClusterResourcesModel';

  @override
  Iterable<Object> serialize(
      Serializers serializers, PveClusterResourcesModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
    ];
    if (object.cpu != null) {
      result
        ..add('cpu')
        ..add(serializers.serialize(object.cpu,
            specifiedType: const FullType(double)));
    }
    if (object.disk != null) {
      result
        ..add('disk')
        ..add(serializers.serialize(object.disk,
            specifiedType: const FullType(int)));
    }
    if (object.hastate != null) {
      result
        ..add('hastate')
        ..add(serializers.serialize(object.hastate,
            specifiedType: const FullType(String)));
    }
    if (object.level != null) {
      result
        ..add('level')
        ..add(serializers.serialize(object.level,
            specifiedType: const FullType(String)));
    }
    if (object.maxcpu != null) {
      result
        ..add('maxcpu')
        ..add(serializers.serialize(object.maxcpu,
            specifiedType: const FullType(double)));
    }
    if (object.maxdisk != null) {
      result
        ..add('maxdisk')
        ..add(serializers.serialize(object.maxdisk,
            specifiedType: const FullType(int)));
    }
    if (object.maxmem != null) {
      result
        ..add('maxmem')
        ..add(serializers.serialize(object.maxmem,
            specifiedType: const FullType(int)));
    }
    if (object.mem != null) {
      result
        ..add('mem')
        ..add(serializers.serialize(object.mem,
            specifiedType: const FullType(int)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.node != null) {
      result
        ..add('node')
        ..add(serializers.serialize(object.node,
            specifiedType: const FullType(String)));
    }
    if (object.pool != null) {
      result
        ..add('pool')
        ..add(serializers.serialize(object.pool,
            specifiedType: const FullType(String)));
    }
    if (object.status != null) {
      result
        ..add('status')
        ..add(serializers.serialize(object.status,
            specifiedType: const FullType(String)));
    }
    if (object.shared != null) {
      result
        ..add('shared')
        ..add(serializers.serialize(object.shared,
            specifiedType: const FullType(bool)));
    }
    if (object.storage != null) {
      result
        ..add('storage')
        ..add(serializers.serialize(object.storage,
            specifiedType: const FullType(String)));
    }
    if (object.uptime != null) {
      result
        ..add('uptime')
        ..add(serializers.serialize(object.uptime,
            specifiedType: const FullType(int)));
    }
    if (object.vmid != null) {
      result
        ..add('vmid')
        ..add(serializers.serialize(object.vmid,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  PveClusterResourcesModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PveClusterResourcesModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'cpu':
          result.cpu = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'disk':
          result.disk = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'hastate':
          result.hastate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'level':
          result.level = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'maxcpu':
          result.maxcpu = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'maxdisk':
          result.maxdisk = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'maxmem':
          result.maxmem = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'mem':
          result.mem = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'node':
          result.node = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'pool':
          result.pool = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'shared':
          result.shared = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'storage':
          result.storage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'uptime':
          result.uptime = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'vmid':
          result.vmid = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$PveClusterResourcesModel extends PveClusterResourcesModel {
  @override
  final double cpu;
  @override
  final int disk;
  @override
  final String hastate;
  @override
  final String id;
  @override
  final String level;
  @override
  final double maxcpu;
  @override
  final int maxdisk;
  @override
  final int maxmem;
  @override
  final int mem;
  @override
  final String name;
  @override
  final String node;
  @override
  final String pool;
  @override
  final String status;
  @override
  final bool shared;
  @override
  final String storage;
  @override
  final String type;
  @override
  final int uptime;
  @override
  final int vmid;

  factory _$PveClusterResourcesModel(
          [void Function(PveClusterResourcesModelBuilder) updates]) =>
      (new PveClusterResourcesModelBuilder()..update(updates)).build();

  _$PveClusterResourcesModel._(
      {this.cpu,
      this.disk,
      this.hastate,
      this.id,
      this.level,
      this.maxcpu,
      this.maxdisk,
      this.maxmem,
      this.mem,
      this.name,
      this.node,
      this.pool,
      this.status,
      this.shared,
      this.storage,
      this.type,
      this.uptime,
      this.vmid})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('PveClusterResourcesModel', 'id');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('PveClusterResourcesModel', 'type');
    }
  }

  @override
  PveClusterResourcesModel rebuild(
          void Function(PveClusterResourcesModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PveClusterResourcesModelBuilder toBuilder() =>
      new PveClusterResourcesModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PveClusterResourcesModel &&
        cpu == other.cpu &&
        disk == other.disk &&
        hastate == other.hastate &&
        id == other.id &&
        level == other.level &&
        maxcpu == other.maxcpu &&
        maxdisk == other.maxdisk &&
        maxmem == other.maxmem &&
        mem == other.mem &&
        name == other.name &&
        node == other.node &&
        pool == other.pool &&
        status == other.status &&
        shared == other.shared &&
        storage == other.storage &&
        type == other.type &&
        uptime == other.uptime &&
        vmid == other.vmid;
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
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            0,
                                                                            cpu
                                                                                .hashCode),
                                                                        disk
                                                                            .hashCode),
                                                                    hastate
                                                                        .hashCode),
                                                                id.hashCode),
                                                            level.hashCode),
                                                        maxcpu.hashCode),
                                                    maxdisk.hashCode),
                                                maxmem.hashCode),
                                            mem.hashCode),
                                        name.hashCode),
                                    node.hashCode),
                                pool.hashCode),
                            status.hashCode),
                        shared.hashCode),
                    storage.hashCode),
                type.hashCode),
            uptime.hashCode),
        vmid.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PveClusterResourcesModel')
          ..add('cpu', cpu)
          ..add('disk', disk)
          ..add('hastate', hastate)
          ..add('id', id)
          ..add('level', level)
          ..add('maxcpu', maxcpu)
          ..add('maxdisk', maxdisk)
          ..add('maxmem', maxmem)
          ..add('mem', mem)
          ..add('name', name)
          ..add('node', node)
          ..add('pool', pool)
          ..add('status', status)
          ..add('shared', shared)
          ..add('storage', storage)
          ..add('type', type)
          ..add('uptime', uptime)
          ..add('vmid', vmid))
        .toString();
  }
}

class PveClusterResourcesModelBuilder
    implements
        Builder<PveClusterResourcesModel, PveClusterResourcesModelBuilder> {
  _$PveClusterResourcesModel _$v;

  double _cpu;
  double get cpu => _$this._cpu;
  set cpu(double cpu) => _$this._cpu = cpu;

  int _disk;
  int get disk => _$this._disk;
  set disk(int disk) => _$this._disk = disk;

  String _hastate;
  String get hastate => _$this._hastate;
  set hastate(String hastate) => _$this._hastate = hastate;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _level;
  String get level => _$this._level;
  set level(String level) => _$this._level = level;

  double _maxcpu;
  double get maxcpu => _$this._maxcpu;
  set maxcpu(double maxcpu) => _$this._maxcpu = maxcpu;

  int _maxdisk;
  int get maxdisk => _$this._maxdisk;
  set maxdisk(int maxdisk) => _$this._maxdisk = maxdisk;

  int _maxmem;
  int get maxmem => _$this._maxmem;
  set maxmem(int maxmem) => _$this._maxmem = maxmem;

  int _mem;
  int get mem => _$this._mem;
  set mem(int mem) => _$this._mem = mem;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _node;
  String get node => _$this._node;
  set node(String node) => _$this._node = node;

  String _pool;
  String get pool => _$this._pool;
  set pool(String pool) => _$this._pool = pool;

  String _status;
  String get status => _$this._status;
  set status(String status) => _$this._status = status;

  bool _shared;
  bool get shared => _$this._shared;
  set shared(bool shared) => _$this._shared = shared;

  String _storage;
  String get storage => _$this._storage;
  set storage(String storage) => _$this._storage = storage;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  int _uptime;
  int get uptime => _$this._uptime;
  set uptime(int uptime) => _$this._uptime = uptime;

  int _vmid;
  int get vmid => _$this._vmid;
  set vmid(int vmid) => _$this._vmid = vmid;

  PveClusterResourcesModelBuilder();

  PveClusterResourcesModelBuilder get _$this {
    if (_$v != null) {
      _cpu = _$v.cpu;
      _disk = _$v.disk;
      _hastate = _$v.hastate;
      _id = _$v.id;
      _level = _$v.level;
      _maxcpu = _$v.maxcpu;
      _maxdisk = _$v.maxdisk;
      _maxmem = _$v.maxmem;
      _mem = _$v.mem;
      _name = _$v.name;
      _node = _$v.node;
      _pool = _$v.pool;
      _status = _$v.status;
      _shared = _$v.shared;
      _storage = _$v.storage;
      _type = _$v.type;
      _uptime = _$v.uptime;
      _vmid = _$v.vmid;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PveClusterResourcesModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PveClusterResourcesModel;
  }

  @override
  void update(void Function(PveClusterResourcesModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PveClusterResourcesModel build() {
    final _$result = _$v ??
        new _$PveClusterResourcesModel._(
            cpu: cpu,
            disk: disk,
            hastate: hastate,
            id: id,
            level: level,
            maxcpu: maxcpu,
            maxdisk: maxdisk,
            maxmem: maxmem,
            mem: mem,
            name: name,
            node: node,
            pool: pool,
            status: status,
            shared: shared,
            storage: storage,
            type: type,
            uptime: uptime,
            vmid: vmid);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
