class SwapiListResponse<T> {
  final int count;
  final List<T> results;

  const SwapiListResponse({required this.count, required this.results});

  factory SwapiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) itemFromJson,
  ) {
    return SwapiListResponse<T>(
      count: (json['count'] as num?)?.toInt() ?? 0,
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => itemFromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
