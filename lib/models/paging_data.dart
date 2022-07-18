enum RefreshType { refresh, loadMore }

class PagingData<T> {
  int count;
  List<T> items;
  int current = 1;

  PagingData(this.count, this.items);

  factory PagingData.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) decoder) {
    final count = json['count'];
    final items = (json['results'] as List<dynamic>).map((e) => decoder(e)).toList();
    return PagingData(count, items);
  }

  @override
  String toString() => '分页: $count';

  bool get isEnd => items.length >= count;

  void merge(PagingData<T> other, RefreshType refreshType) {
    if (refreshType == RefreshType.refresh) items.clear();
    count = other.count;
    items.addAll(other.items);
  }

  void prepare(RefreshType refreshType) => current = refreshType == RefreshType.refresh ? 1 : (current + 1);
}
