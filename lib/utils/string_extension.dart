List<String> _romanNumbers = [
  'i',
  'v',
  'x',
  'l',
  'c',
  'd',
  'm',
];

bool _isRomanNumber(String string) {
  for (var i in string.runes) {
    if (!_romanNumbers.contains(String.fromCharCode(i))) {
      return false;
    }
  }
  return true;
}

extension StringExtension on String {
  String capitalize() {
    return _isRomanNumber(this)
        ? toUpperCase()
        : "${this[0].toUpperCase()}${substring(1)}";
  }

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.capitalize())
      .join(" ");
}
