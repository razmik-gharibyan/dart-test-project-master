/// Converts value to JSON-encodable format
/// 
/// Now implemented only DateTime objects conversion
dynamic toEncodable(value) {
  if (value is DateTime) return value.toUtc().toIso8601String();
  return '';
}
