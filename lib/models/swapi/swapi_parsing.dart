int? swapiInt(dynamic value) => _swapiNumber(value)?.toInt();

double? swapiDouble(dynamic value) => _swapiNumber(value)?.toDouble();

DateTime? swapiDate(dynamic value) {
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

String? swapiUrl(dynamic value) {
  if (value is String && value.isNotEmpty) {
    return value;
  }
  return null;
}

List<String> swapiUrls(dynamic value) {
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  return const [];
}

int? swapiId(String? url) {
  if (url == null || url.isEmpty) {
    return null;
  }

  final segments = Uri.tryParse(
    url,
  )?.pathSegments.where((segment) => segment.isNotEmpty).toList();
  if (segments == null || segments.isEmpty) {
    return null;
  }

  return int.tryParse(segments.last);
}

extension SwapiUrlListX on List<String> {
  List<int> get ids => map(swapiId).whereType<int>().toList(growable: false);
}

num? _swapiNumber(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value;
  }

  final text = value.toString().trim();
  if (text.isEmpty) {
    return null;
  }

  const notAvailable = {'unknown', 'n/a', 'na', 'none', 'indefinite', 'null'};
  if (notAvailable.contains(text.toLowerCase())) {
    return null;
  }

  return num.tryParse(text.replaceAll(',', ''));
}
