/// Sanitizes Arabic text to avoid BiDi RangeError in the pdf package.
/// Removes combining marks and diacritics that crash the bidi normalizer.
String sanitizeForPdf(String? text) {
  if (text == null || text.isEmpty) return '';

  // Remove Arabic diacritics (tashkeel) that cause BiDi crashes
  // Fathah, Dammah, Kasrah, Sukun, Shadda, Tanwin, etc.
  final diacritics = RegExp(
    '[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E4\u06E7\u06E8\u06EA-\u06ED\u0890-\u0891\u08D3-\u08FF\u0300-\u036F\uFE70-\uFE7F]',
  );

  // Remove zero-width characters that confuse BiDi
  final zeroWidth = RegExp('[\u200B-\u200F\u202A-\u202E\u2060-\u2069\uFEFF]');

  return text
      .replaceAll(diacritics, '')
      .replaceAll(zeroWidth, '')
      .replaceAll('\u0000', '') // null bytes
      .trim();
}

/// Sanitizes a dynamic value for PDF display
String pdfSafe(dynamic value, [String fallback = '—']) {
  if (value == null) return fallback;
  final str = value.toString().trim();
  if (str.isEmpty) return fallback;
  return sanitizeForPdf(str);
}
