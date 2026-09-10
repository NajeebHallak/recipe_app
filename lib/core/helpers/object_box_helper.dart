import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:recipe/objectbox.g.dart';

class ObjectBoxHelper {
  /// The Store of this app.
  late final Store store;

  ObjectBoxHelper._create(this.store);

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxHelper> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() is defined in the generated objectbox.g.dart
    final store = await openStore(directory: p.join(docsDir.path, "obx-recipes"));
    return ObjectBoxHelper._create(store);
  }
}
