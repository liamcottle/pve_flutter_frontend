// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pve_nodes_storage_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PveNodesStorageModel> _$pveNodesStorageModelSerializer =
    new _$PveNodesStorageModelSerializer();

class _$PveNodesStorageModelSerializer
    implements StructuredSerializer<PveNodesStorageModel> {
  @override
  final Iterable<Type> types = const [
    PveNodesStorageModel,
    _$PveNodesStorageModel
  ];
  @override
  final String wireName = 'PveNodesStorageModel';

  @override
  Iterable<Object> serialize(
      Serializers serializers, PveNodesStorageModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'content',
      serializers.serialize(object.content,
          specifiedType: const FullType(String)),
      'storage',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
    ];
    if (object.active != null) {
      result
        ..add('active')
        ..add(serializers.serialize(object.active,
            specifiedType: const FullType(bool)));
    }
    if (object.freeSpace != null) {
      result
        ..add('avail')
        ..add(serializers.serialize(object.freeSpace,
            specifiedType: const FullType(int)));
    }
    if (object.enabled != null) {
      result
        ..add('enabled')
        ..add(serializers.serialize(object.enabled,
            specifiedType: const FullType(bool)));
    }
    if (object.shared != null) {
      result
        ..add('shared')
        ..add(serializers.serialize(object.shared,
            specifiedType: const FullType(bool)));
    }
    if (object.totalSpace != null) {
      result
        ..add('total')
        ..add(serializers.serialize(object.totalSpace,
            specifiedType: const FullType(int)));
    }
    if (object.usedSpace != null) {
      result
        ..add('used')
        ..add(serializers.serialize(object.usedSpace,
            specifiedType: const FullType(int)));
    }
    if (object.usedPercent != null) {
      result
        ..add('used_fraction')
        ..add(serializers.serialize(object.usedPercent,
            specifiedType: const FullType(double)));
    }
    return result;
  }

  @override
  PveNodesStorageModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PveNodesStorageModelBuilder();

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
        case 'avail':
          result.freeSpace = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'content':
          result.content = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'enabled':
          result.enabled = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'shared':
          result.shared = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'storage':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'total':
          result.totalSpace = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'used':
          result.usedSpace = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'used_fraction':
          result.usedPercent = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$PveNodesStorageModel extends PveNodesStorageModel {
  @override
  final bool active;
  @override
  final int freeSpace;
  @override
  final String content;
  @override
  final bool enabled;
  @override
  final bool shared;
  @override
  final String id;
  @override
  final int totalSpace;
  @override
  final String type;
  @override
  final int usedSpace;
  @override
  final double usedPercent;

  factory _$PveNodesStorageModel(
          [void Function(PveNodesStorageModelBuilder) updates]) =>
      (new PveNodesStorageModelBuilder()..update(updates)).build();

  _$PveNodesStorageModel._(
      {this.active,
      this.freeSpace,
      this.content,
      this.enabled,
      this.shared,
      this.id,
      this.totalSpace,
      this.type,
      this.usedSpace,
      this.usedPercent})
      : super._() {
    if (content == null) {
      throw new BuiltValueNullFieldError('PveNodesStorageModel', 'content');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('PveNodesStorageModel', 'id');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('PveNodesStorageModel', 'type');
    }
  }

  @override
  PveNodesStorageModel rebuild(
          void Function(PveNodesStorageModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PveNodesStorageModelBuilder toBuilder() =>
      new PveNodesStorageModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PveNodesStorageModel &&
        active == other.active &&
        freeSpace == other.freeSpace &&
        content == other.content &&
        enabled == other.enabled &&
        shared == other.shared &&
        id == other.id &&
        totalSpace == other.totalSpace &&
        type == other.type &&
        usedSpace == other.usedSpace &&
        usedPercent == other.usedPercent;
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
                                    $jc($jc(0, active.hashCode),
                                        freeSpace.hashCode),
                                    content.hashCode),
                                enabled.hashCode),
                            shared.hashCode),
                        id.hashCode),
                    totalSpace.hashCode),
                type.hashCode),
            usedSpace.hashCode),
        usedPercent.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PveNodesStorageModel')
          ..add('active', active)
          ..add('freeSpace', freeSpace)
          ..add('content', content)
          ..add('enabled', enabled)
          ..add('shared', shared)
          ..add('id', id)
          ..add('totalSpace', totalSpace)
          ..add('type', type)
          ..add('usedSpace', usedSpace)
          ..add('usedPercent', usedPercent))
        .toString();
  }
}

class PveNodesStorageModelBuilder
    implements Builder<PveNodesStorageModel, PveNodesStorageModelBuilder> {
  _$PveNodesStorageModel _$v;

  bool _active;
  bool get active => _$this._active;
  set active(bool active) => _$this._active = active;

  int _freeSpace;
  int get freeSpace => _$this._freeSpace;
  set freeSpace(int freeSpace) => _$this._freeSpace = freeSpace;

  String _content;
  String get content => _$this._content;
  set content(String content) => _$this._content = content;

  bool _enabled;
  bool get enabled => _$this._enabled;
  set enabled(bool enabled) => _$this._enabled = enabled;

  bool _shared;
  bool get shared => _$this._shared;
  set shared(bool shared) => _$this._shared = shared;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  int _totalSpace;
  int get totalSpace => _$this._totalSpace;
  set totalSpace(int totalSpace) => _$this._totalSpace = totalSpace;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  int _usedSpace;
  int get usedSpace => _$this._usedSpace;
  set usedSpace(int usedSpace) => _$this._usedSpace = usedSpace;

  double _usedPercent;
  double get usedPercent => _$this._usedPercent;
  set usedPercent(double usedPercent) => _$this._usedPercent = usedPercent;

  PveNodesStorageModelBuilder();

  PveNodesStorageModelBuilder get _$this {
    if (_$v != null) {
      _active = _$v.active;
      _freeSpace = _$v.freeSpace;
      _content = _$v.content;
      _enabled = _$v.enabled;
      _shared = _$v.shared;
      _id = _$v.id;
      _totalSpace = _$v.totalSpace;
      _type = _$v.type;
      _usedSpace = _$v.usedSpace;
      _usedPercent = _$v.usedPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PveNodesStorageModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PveNodesStorageModel;
  }

  @override
  void update(void Function(PveNodesStorageModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PveNodesStorageModel build() {
    final _$result = _$v ??
        new _$PveNodesStorageModel._(
            active: active,
            freeSpace: freeSpace,
            content: content,
            enabled: enabled,
            shared: shared,
            id: id,
            totalSpace: totalSpace,
            type: type,
            usedSpace: usedSpace,
            usedPercent: usedPercent);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
