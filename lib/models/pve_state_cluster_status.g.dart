// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pve_state_cluster_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PveClusterStatusState extends PveClusterStatusState {
  @override
  final BuiltList<PveClusterStatusModel> model;

  factory _$PveClusterStatusState(
          [void Function(PveClusterStatusStateBuilder) updates]) =>
      (new PveClusterStatusStateBuilder()..update(updates)).build();

  _$PveClusterStatusState._({this.model}) : super._() {
    if (model == null) {
      throw new BuiltValueNullFieldError('PveClusterStatusState', 'model');
    }
  }

  @override
  PveClusterStatusState rebuild(
          void Function(PveClusterStatusStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PveClusterStatusStateBuilder toBuilder() =>
      new PveClusterStatusStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PveClusterStatusState && model == other.model;
  }

  @override
  int get hashCode {
    return $jf($jc(0, model.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PveClusterStatusState')
          ..add('model', model))
        .toString();
  }
}

class PveClusterStatusStateBuilder
    implements Builder<PveClusterStatusState, PveClusterStatusStateBuilder> {
  _$PveClusterStatusState _$v;

  ListBuilder<PveClusterStatusModel> _model;
  ListBuilder<PveClusterStatusModel> get model =>
      _$this._model ??= new ListBuilder<PveClusterStatusModel>();
  set model(ListBuilder<PveClusterStatusModel> model) => _$this._model = model;

  PveClusterStatusStateBuilder();

  PveClusterStatusStateBuilder get _$this {
    if (_$v != null) {
      _model = _$v.model?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PveClusterStatusState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PveClusterStatusState;
  }

  @override
  void update(void Function(PveClusterStatusStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PveClusterStatusState build() {
    _$PveClusterStatusState _$result;
    try {
      _$result = _$v ?? new _$PveClusterStatusState._(model: model.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'model';
        model.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'PveClusterStatusState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
