// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pve_nodes_storage_content_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PveNodesStorageContentModel>
    _$pveNodesStorageContentModelSerializer =
    new _$PveNodesStorageContentModelSerializer();

class _$PveNodesStorageContentModelSerializer
    implements StructuredSerializer<PveNodesStorageContentModel> {
  @override
  final Iterable<Type> types = const [
    PveNodesStorageContentModel,
    _$PveNodesStorageContentModel
  ];
  @override
  final String wireName = 'PveNodesStorageContentModel';

  @override
  Iterable<Object> serialize(
      Serializers serializers, PveNodesStorageContentModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'format',
      serializers.serialize(object.format,
          specifiedType: const FullType(String)),
      'size',
      serializers.serialize(object.size, specifiedType: const FullType(int)),
      'volid',
      serializers.serialize(object.volid,
          specifiedType: const FullType(String)),
    ];
    if (object.parent != null) {
      result
        ..add('parent')
        ..add(serializers.serialize(object.parent,
            specifiedType: const FullType(String)));
    }
    if (object.used != null) {
      result
        ..add('used')
        ..add(serializers.serialize(object.used,
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
  PveNodesStorageContentModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PveNodesStorageContentModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'format':
          result.format = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'parent':
          result.parent = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'size':
          result.size = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'used':
          result.used = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'vmid':
          result.vmid = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'volid':
          result.volid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$PveNodesStorageContentModel extends PveNodesStorageContentModel {
  @override
  final String format;
  @override
  final String parent;
  @override
  final int size;
  @override
  final int used;
  @override
  final int vmid;
  @override
  final String volid;

  factory _$PveNodesStorageContentModel(
          [void Function(PveNodesStorageContentModelBuilder) updates]) =>
      (new PveNodesStorageContentModelBuilder()..update(updates)).build();

  _$PveNodesStorageContentModel._(
      {this.format, this.parent, this.size, this.used, this.vmid, this.volid})
      : super._() {
    if (format == null) {
      throw new BuiltValueNullFieldError(
          'PveNodesStorageContentModel', 'format');
    }
    if (size == null) {
      throw new BuiltValueNullFieldError('PveNodesStorageContentModel', 'size');
    }
    if (volid == null) {
      throw new BuiltValueNullFieldError(
          'PveNodesStorageContentModel', 'volid');
    }
  }

  @override
  PveNodesStorageContentModel rebuild(
          void Function(PveNodesStorageContentModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PveNodesStorageContentModelBuilder toBuilder() =>
      new PveNodesStorageContentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PveNodesStorageContentModel &&
        format == other.format &&
        parent == other.parent &&
        size == other.size &&
        used == other.used &&
        vmid == other.vmid &&
        volid == other.volid;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, format.hashCode), parent.hashCode),
                    size.hashCode),
                used.hashCode),
            vmid.hashCode),
        volid.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PveNodesStorageContentModel')
          ..add('format', format)
          ..add('parent', parent)
          ..add('size', size)
          ..add('used', used)
          ..add('vmid', vmid)
          ..add('volid', volid))
        .toString();
  }
}

class PveNodesStorageContentModelBuilder
    implements
        Builder<PveNodesStorageContentModel,
            PveNodesStorageContentModelBuilder> {
  _$PveNodesStorageContentModel _$v;

  String _format;
  String get format => _$this._format;
  set format(String format) => _$this._format = format;

  String _parent;
  String get parent => _$this._parent;
  set parent(String parent) => _$this._parent = parent;

  int _size;
  int get size => _$this._size;
  set size(int size) => _$this._size = size;

  int _used;
  int get used => _$this._used;
  set used(int used) => _$this._used = used;

  int _vmid;
  int get vmid => _$this._vmid;
  set vmid(int vmid) => _$this._vmid = vmid;

  String _volid;
  String get volid => _$this._volid;
  set volid(String volid) => _$this._volid = volid;

  PveNodesStorageContentModelBuilder();

  PveNodesStorageContentModelBuilder get _$this {
    if (_$v != null) {
      _format = _$v.format;
      _parent = _$v.parent;
      _size = _$v.size;
      _used = _$v.used;
      _vmid = _$v.vmid;
      _volid = _$v.volid;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PveNodesStorageContentModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PveNodesStorageContentModel;
  }

  @override
  void update(void Function(PveNodesStorageContentModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PveNodesStorageContentModel build() {
    final _$result = _$v ??
        new _$PveNodesStorageContentModel._(
            format: format,
            parent: parent,
            size: size,
            used: used,
            vmid: vmid,
            volid: volid);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
