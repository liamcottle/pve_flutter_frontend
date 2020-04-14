abstract class PveBaseState {
  String get errorMessage;
  bool get isLoading;
  bool get isBlank;
  bool get isSuccess;

  bool get isFailure => errorMessage != null && errorMessage.isNotEmpty;
}
