// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pve_login_states.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PveLoginState extends PveLoginState {
  @override
  final bool isUsernameValid;
  @override
  final bool isPasswordValid;
  @override
  final bool isSubmitting;
  @override
  final bool isSuccess;
  @override
  final String errorMessage;
  @override
  final proxclient.Client apiClient;

  factory _$PveLoginState([void Function(PveLoginStateBuilder) updates]) =>
      (new PveLoginStateBuilder()..update(updates)).build();

  _$PveLoginState._(
      {this.isUsernameValid,
      this.isPasswordValid,
      this.isSubmitting,
      this.isSuccess,
      this.errorMessage,
      this.apiClient})
      : super._() {
    if (isUsernameValid == null) {
      throw new BuiltValueNullFieldError('PveLoginState', 'isUsernameValid');
    }
    if (isPasswordValid == null) {
      throw new BuiltValueNullFieldError('PveLoginState', 'isPasswordValid');
    }
    if (isSubmitting == null) {
      throw new BuiltValueNullFieldError('PveLoginState', 'isSubmitting');
    }
    if (isSuccess == null) {
      throw new BuiltValueNullFieldError('PveLoginState', 'isSuccess');
    }
    if (errorMessage == null) {
      throw new BuiltValueNullFieldError('PveLoginState', 'errorMessage');
    }
  }

  @override
  PveLoginState rebuild(void Function(PveLoginStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PveLoginStateBuilder toBuilder() => new PveLoginStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PveLoginState &&
        isUsernameValid == other.isUsernameValid &&
        isPasswordValid == other.isPasswordValid &&
        isSubmitting == other.isSubmitting &&
        isSuccess == other.isSuccess &&
        errorMessage == other.errorMessage &&
        apiClient == other.apiClient;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc(0, isUsernameValid.hashCode),
                        isPasswordValid.hashCode),
                    isSubmitting.hashCode),
                isSuccess.hashCode),
            errorMessage.hashCode),
        apiClient.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PveLoginState')
          ..add('isUsernameValid', isUsernameValid)
          ..add('isPasswordValid', isPasswordValid)
          ..add('isSubmitting', isSubmitting)
          ..add('isSuccess', isSuccess)
          ..add('errorMessage', errorMessage)
          ..add('apiClient', apiClient))
        .toString();
  }
}

class PveLoginStateBuilder
    implements Builder<PveLoginState, PveLoginStateBuilder> {
  _$PveLoginState _$v;

  bool _isUsernameValid;
  bool get isUsernameValid => _$this._isUsernameValid;
  set isUsernameValid(bool isUsernameValid) =>
      _$this._isUsernameValid = isUsernameValid;

  bool _isPasswordValid;
  bool get isPasswordValid => _$this._isPasswordValid;
  set isPasswordValid(bool isPasswordValid) =>
      _$this._isPasswordValid = isPasswordValid;

  bool _isSubmitting;
  bool get isSubmitting => _$this._isSubmitting;
  set isSubmitting(bool isSubmitting) => _$this._isSubmitting = isSubmitting;

  bool _isSuccess;
  bool get isSuccess => _$this._isSuccess;
  set isSuccess(bool isSuccess) => _$this._isSuccess = isSuccess;

  String _errorMessage;
  String get errorMessage => _$this._errorMessage;
  set errorMessage(String errorMessage) => _$this._errorMessage = errorMessage;

  proxclient.Client _apiClient;
  proxclient.Client get apiClient => _$this._apiClient;
  set apiClient(proxclient.Client apiClient) => _$this._apiClient = apiClient;

  PveLoginStateBuilder();

  PveLoginStateBuilder get _$this {
    if (_$v != null) {
      _isUsernameValid = _$v.isUsernameValid;
      _isPasswordValid = _$v.isPasswordValid;
      _isSubmitting = _$v.isSubmitting;
      _isSuccess = _$v.isSuccess;
      _errorMessage = _$v.errorMessage;
      _apiClient = _$v.apiClient;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PveLoginState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PveLoginState;
  }

  @override
  void update(void Function(PveLoginStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PveLoginState build() {
    final _$result = _$v ??
        new _$PveLoginState._(
            isUsernameValid: isUsernameValid,
            isPasswordValid: isPasswordValid,
            isSubmitting: isSubmitting,
            isSuccess: isSuccess,
            errorMessage: errorMessage,
            apiClient: apiClient);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
