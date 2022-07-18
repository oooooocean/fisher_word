import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:frontend/models/paging_data.dart';

mixin RefreshMixin<T> {
  final refreshController = RefreshController(initialRefresh: true);

  List<T> get items => paging.items;
  final PagingData<T> paging = PagingData(0, []);

  Future<PagingData> startRefresh(RefreshType refreshType) {
    paging.prepare(refreshType);
    return refreshRequest.then((value) {
      paging.merge(value, refreshType);
      if (refreshType == RefreshType.refresh) {
        refreshController.refreshCompleted(resetFooterState: true);
        if (paging.isEnd) refreshController.loadNoData();
      } else {
        paging.isEnd ? refreshController.loadNoData() : refreshController.loadComplete();
      }
      return paging;
    });
  }

  Future<PagingData<T>> get refreshRequest => throw UnimplementedError('子类必须重写');
}
