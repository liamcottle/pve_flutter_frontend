// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pve_cluster_tasks_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PveClusterTasksModel> _$pveClusterTasksModelSerializer =
    new _$PveClusterTasksModelSerializer();

class _$PveClusterTasksModelSerializer
    implements StructuredSerializer<PveClusterTasksModel> {
  @override
  final Iterable<Type> types = const [
    PveClusterTasksModel,
    _$PveClusterTasksModel
  ];
  @override
  final String wireName = 'PveClusterTasksModel';

  @override
  Iterable<Object> serialize(
      Serializers serializers, PveClusterTasksModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'starttime',
      serializers.serialize(object.startTime,
          specifiedType: const FullType(DateTime)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'upid',
      serializers.serialize(object.upid, specifiedType: const FullType(String)),
      'user',
      serializers.serialize(object.user, specifiedType: const FullType(String)),
      'node',
      serializers.serialize(object.node, specifiedType: const FullType(String)),
    ];
    if (object.endTime != null) {
      result
        ..add('endtime')
        ..add(serializers.serialize(object.endTime,
            specifiedType: const FullType(DateTime)));
    }
    if (object.status != null) {
      result
        ..add('status')
        ..add(serializers.serialize(object.status,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  PveClusterTasksModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PveClusterTasksModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'starttime':
          result.startTime = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'endtime':
          result.endTime = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'upid':
          result.upid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'user':
          result.user = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'node':
          result.node = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$PveClusterTasksModel extends PveClusterTasksModel {
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String status;
  @override
  final String type;
  @override
  final String upid;
  @override
  final String user;
  @override
  final String node;

  factory _$PveClusterTasksModel(
          [void Function(PveClusterTasksModelBuilder) updates]) =>
      (new PveClusterTasksModelBuilder()..update(updates)).build();

  _$PveClusterTasksModel._(
      {this.startTime,
      this.endTime,
      this.status,
      this.type,
      this.upid,
      this.user,
      this.node})
      : super._() {
    if (startTime == null) {
      throw new BuiltValueNullFieldError('PveClusterTasksModel', 'startTime');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('PveClusterTasksModel', 'type');
    }
    if (upid == null) {
      throw new BuiltValueNullFieldError('PveClusterTasksModel', 'upid');
    }
    if (user == null) {
      throw new BuiltValueNullFieldError('PveClusterTasksModel', 'user');
    }
    if (node == null) {
      throw new BuiltValueNullFieldError('PveClusterTasksModel', 'node');
    }
  }

  @override
  PveClusterTasksModel rebuild(
          void Function(PveClusterTasksModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PveClusterTasksModelBuilder toBuilder() =>
      new PveClusterTasksModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PveClusterTasksModel &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        status == other.status &&
        type == other.type &&
        upid == other.upid &&
        user == other.user &&
        node == other.node;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, startTime.hashCode), endTime.hashCode),
                        status.hashCode),
                    type.hashCode),
                upid.hashCode),
            user.hashCode),
        node.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PveClusterTasksModel')
          ..add('startTime', startTime)
          ..add('endTime', endTime)
          ..add('status', status)
          ..add('type', type)
          ..add('upid', upid)
          ..add('user', user)
          ..add('node', node))
        .toString();
  }
}

class PveClusterTasksModelBuilder
    implements Builder<PveClusterTasksModel, PveClusterTasksModelBuilder> {
  _$PveClusterTasksModel _$v;

  DateTime _startTime;
  DateTime get startTime => _$this._startTime;
  set startTime(DateTime startTime) => _$this._startTime = startTime;

  DateTime _endTime;
  DateTime get endTime => _$this._endTime;
  set endTime(DateTime endTime) => _$this._endTime = endTime;

  String _status;
  String get status => _$this._status;
  set status(String status) => _$this._status = status;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  String _upid;
  String get upid => _$this._upid;
  set upid(String upid) => _$this._upid = upid;

  String _user;
  String get user => _$this._user;
  set user(String user) => _$this._user = user;

  String _node;
  String get node => _$this._node;
  set node(String node) => _$this._node = node;

  PveClusterTasksModelBuilder();

  PveClusterTasksModelBuilder get _$this {
    if (_$v != null) {
      _startTime = _$v.startTime;
      _endTime = _$v.endTime;
      _status = _$v.status;
      _type = _$v.type;
      _upid = _$v.upid;
      _user = _$v.user;
      _node = _$v.node;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PveClusterTasksModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PveClusterTasksModel;
  }

  @override
  void update(void Function(PveClusterTasksModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PveClusterTasksModel build() {
    final _$result = _$v ??
        new _$PveClusterTasksModel._(
            startTime: startTime,
            endTime: endTime,
            status: status,
            type: type,
            upid: upid,
            user: user,
            node: node);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
