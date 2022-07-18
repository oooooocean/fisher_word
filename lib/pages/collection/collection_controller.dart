import 'package:frontend/models/collection.dart';
import 'package:frontend/services/db.dart';
import 'package:get/get.dart';

class CollectionController extends GetxController with StateMixin<List<Collection>> {
  List<Collection> get collections => state!;

  delete(int index) {
    final collection = collections[index];
    DB.shared.deleteCollection(collection);
    collections.removeAt(index);
    change(collections, status: RxStatus.success());
  }

  @override
  void onReady() {
    DB.shared.collections().then((value) {
      change(value, status: RxStatus.success());
    });
    super.onReady();
  }
}
