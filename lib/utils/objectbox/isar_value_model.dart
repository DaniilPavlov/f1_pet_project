import 'package:isar/isar.dart';
// import 'objectbox.g.dart';
part 'isar_value_model.g.dart';

// ignore_for_file: public_member_api_docs

@collection
class IsarValueModel {
  Id id = Isar.autoIncrement;

  int? value;
}
