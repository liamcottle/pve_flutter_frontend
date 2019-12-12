// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pve_cluster_status_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PveClusterStatusModel> _$pveClusterStatusModelSerializer =
    new _$PveClusterStatusModelSerializer();

class _$PveClusterStatusModelSerializer
    implements StructuredSerializer<PveClusterStatusModel> {
  @override
  final Iterable<Type> types = const [
    PveClusterStatusModel,
    _$PveClusterStatusModel
  ];
  @override
  final String wireName = 'PveClusterStatusModel';

  @override
  Iterable<Object> serialize(
      Serializers serializers, PveClusterStatusModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
    ];
    if (object.ip != null) {
      result
        ..add('ip')
        ..add(serializers.serialize(object.ip,
            specifiedType: const FullType(String)));
    }
    if (object.level != null) {
      result
        ..add('level')
        ..add(serializers.serialize(object.level,
            specifiedType: const FullType(String)));
    }
    if (object.local != null) {
      result
        ..add('local')
        ..add(serializers.serialize(object.local,
            specifiedType: const FullType(bool)));
    }
    if (object.nodeid != null) {
      result
        ..add('nodeid')
        ..add(serializers.serialize(object.nodeid,
            specifiedType: const FullType(int)));
    }
    if (object.nodes != null) {
      result
        ..add('nodes')
        ..add(serializers.serialize(object.nodes,
            specifiedType: const FullType(int)));
    }
    if (object.online != null) {
      result
        ..add('online')
        ..add(serializers.serialize(object.online,
            specifiedType: const FullType(bool)));
    }
    if (object.quorate != null) {
      result
        ..add('quorate')
        ..add(serializers.serialize(object.quorate,
            specifiedType: const FullType(bool)));
    }
    if (object.version != null) {
      result
        ..add('version')
        ..add(serializers.serialize(object.version,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  PveClusterStatusModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PveClusterStatusModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'ip':
          result.ip = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'level':
          result.level = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'local':
          result.local = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'nodeid':
          result.nodeid = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'nodes':
          result.nodes = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'online':
          result.online = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'quorate':
          result.quorate = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'version':
          result.version = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$PveClusterStatusModel extends PveClusterStatusModel {
  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final String ip;
  @override
  final String level;
  @override
  final bool local;
  @override
  final int nodeid;
  @override
  final int nodes;
  @override
  final bool online;
  @override
  final bool quorate;
  @override
  final int version;

  factory _$PveClusterStatusModel(
          [void Function(PveClusterStatusModelBuilder) updates]) =>
      (new PveClusterStatusModelBuilder()..update(updates)).build();

  _$PveClusterStatusModel._(
      {this.id,
      this.name,
      this.type,
      this.ip,
      this.level,
      this.local,
      this.nodeid,
      this.nodes,
      this.online,
      this.quorate,
      this.version})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('PveClusterStatusModel', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('PveClusterStatusModel', 'name');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('PveClusterStatusModel', 'type');
    }
  }

  @override
  PveClusterStatusModel rebuild(
          void Function(PveClusterStatusModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PveClusterStatusModelBuilder toBuilder() =>
      new PveClusterStatusModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PveClusterStatusModel &&
        id == other.id &&
        name == other.name &&
        type == other.type &&
        ip == other.ip &&
        level == other.level &&
        local == other.local &&
        nodeid == other.nodeid &&
        nodes == other.nodes &&
        online == other.online &&
        quorate == other.quorate &&
        version == other.version;
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
                                    $jc($jc($jc(0, id.hashCode), name.hashCode),
                                        type.hashCode),
                                    ip.hashCode),
                                level.hashCode),
                            local.hashCode),
                        nodeid.hashCode),
                    nodes.hashCode),
                online.hashCode),
            quorate.hashCode),
        version.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PveClusterStatusModel')
          ..add('id', id)
          ..add('name', name)
          ..add('type', type)
          ..add('ip', ip)
          ..add('level', level)
          ..add('local', local)
          ..add('nodeid', nodeid)
          ..add('nodes', nodes)
          ..add('online', online)
          ..add('quorate', quorate)
          ..add('version', version))
        .toString();
  }
}

class PveClusterStatusModelBuilder
    implements Builder<PveClusterStatusModel, PveClusterStatusModelBuilder> {
  _$PveClusterStatusModel _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  String _ip;
  String get ip => _$this._ip;
  set ip(String ip) => _$this._ip = ip;

  String _level;
  String get level => _$this._level;
  set level(String level) => _$this._level = level;

  bool _local;
  bool get local => _$this._local;
  set local(bool local) => _$this._local = local;

  int _nodeid;
  int get nodeid => _$this._nodeid;
  set nodeid(int nodeid) => _$this._nodeid = nodeid;

  int _nodes;
  int get nodes => _$this._nodes;
  set nodes(int nodes) => _$this._nodes = nodes;

  bool _online;
  bool get online => _$this._online;
  set online(bool online) => _$this._online = online;

  bool _quorate;
  bool get quorate => _$this._quorate;
  set quorate(bool quorate) => _$this._quorate = quorate;

  int _version;
  int get version => _$this._version;
  set version(int version) => _$this._version = version;

  PveClusterStatusModelBuilder();

  PveClusterStatusModelBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _type = _$v.type;
      _ip = _$v.ip;
      _level = _$v.level;
      _local = _$v.local;
      _nodeid = _$v.nodeid;
      _nodes = _$v.nodes;
      _online = _$v.online;
      _quorate = _$v.quorate;
      _version = _$v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PveClusterStatusModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PveClusterStatusModel;
  }

  @override
  void update(void Function(PveClusterStatusModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PveClusterStatusModel build() {
    final _$result = _$v ??
        new _$PveClusterStatusModel._(
            id: id,
            name: name,
            type: type,
            ip: ip,
            level: level,
            local: local,
            nodeid: nodeid,
            nodes: nodes,
            online: online,
            quorate: quorate,
            version: version);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
