abstract class PveGuestIdSelectorEvent {}

class LoadNextFreeId extends PveGuestIdSelectorEvent {}

class ValidateInput extends PveGuestIdSelectorEvent {
  final String id;

  ValidateInput(this.id);
}