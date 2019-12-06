import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

class PveBoolSerializer implements PrimitiveSerializer<bool> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>([bool]);
  @override
  final String wireName = 'bool';

  @override
  Object serialize(Serializers serializers, bool boolean,
      {FullType specifiedType = FullType.unspecified}) {
    return boolean ? 1 : 0;
  }

  @override
  bool deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return serialized == 0 ? false : true;
  }
}