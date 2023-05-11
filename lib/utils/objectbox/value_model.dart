import 'package:objectbox/objectbox.dart';
// import 'objectbox.g.dart';

// ignore_for_file: public_member_api_docs

@Entity()
class ValueModel {
  int id;

  int value;

  ValueModel({
    this.value = 0,
    this.id = 0,
  });
}
