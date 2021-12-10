import 'package:meta/meta.dart';

class PveFormFieldState<T> {
  final T value;

  final String? errorText;

  final bool isRequired;

  final bool isValidating;

  final bool enabled;


  PveFormFieldState({required this.value, this.isRequired = false, this.isValidating = false, this.enabled = true, this.errorText});

  /// True if this field has any validation errors.
  bool get hasError => errorText != null;


}