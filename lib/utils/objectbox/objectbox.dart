import 'package:f1_pet_project/objectbox.g.dart';
import 'package:f1_pet_project/utils/objectbox/value_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// import 'objectbox.g.dart';

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  /// A Box of notes.
  late final Box<ValueModel> _value;

  ObjectBox._create(this._store) {
    _value = Box<ValueModel>(_store);

    // _noteBox = Box<Note>(_store);

    // // Add some demo data if the box is empty.
    if (_value.isEmpty()) {
      _putDemoData(5);
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Note: setting a unique directory is recommended if running on desktop
    // platforms. If none is specified, the default directory is created in the
    // users documents directory, which will not be unique between apps.
    // On mobile this is typically fine, as each app has its own directory
    // structure.

    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart

    final store = await openStore(
      directory:
          p.join((await getApplicationDocumentsDirectory()).path, 'obx-demo'),
    );
    return ObjectBox._create(store);
  }

  void _putDemoData(int newValue) {
    _value.put(ValueModel(value: newValue));
  }

  // Stream<List<Note>> getNotes() {
  //   // Query for all notes, sorted by their date.
  //   // https://docs.objectbox.io/queries
  //   final builder = _noteBox.query().order(Note_.date, flags: Order.descending);
  //   // Build and watch the query,
  //   // set triggerImmediately to emit the query immediately on listen.
  //   return builder
  //       .watch(triggerImmediately: true)
  //       // Map it to a list of notes to be used by a StreamBuilder.
  //       .map((query) => query.find());
  // }

  // /// Add a note.
  // ///
  // /// To avoid frame drops, run ObjectBox operations that take longer than a
  // /// few milliseconds, e.g. putting many objects, asynchronously.
  // /// For this example only a single object is put which would also be fine if
  // /// done using [Box.put].
  // Future<void> addNote(String text) => _noteBox.putAsync(Note(text));

  // Future<void> removeNote(int id) => _noteBox.removeAsync(id);

  int getValue() => _value.getAll().first.value;
}
