import 'package:frontend/models/book.dart';
import 'package:frontend/services/db.dart';
import 'package:get/get.dart';

class StatController extends GetxController with StateMixin<List<Book>> {

  List<Book> get books => value!;

  reset(Book book) {}

  @override
  void onReady() {
    DB.shared.cachedBooks.then((value) {
      DB.shared.bookStat(value);
      change(value, status: RxStatus.success());
    });
    super.onReady();
  }
}