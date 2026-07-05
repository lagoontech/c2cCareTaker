/// Shared null-safe helpers for API models and UI.
class NullSafe {
  NullSafe._();

  static String orEmpty(String? value) => value ?? '';

  static String displayName(String? firstName, String? lastName) {
    final parts = [firstName, lastName]
        .where((part) => part != null && part.trim().isNotEmpty)
        .map((part) => part!.trim())
        .toList();
    return parts.isEmpty ? 'Unknown' : parts.join(' ');
  }

  static DateTime? firstDate(List<DateTime>? dates) {
    if (dates == null || dates.isEmpty) return null;
    return dates.first;
  }

  static DateTime? lastDate(List<DateTime>? dates) {
    if (dates == null || dates.isEmpty) return null;
    return dates.last;
  }

  static bool hasDates(List<DateTime>? dates) =>
      dates != null && dates.isNotEmpty;
}
