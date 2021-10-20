extension StringExtension on String {
  String capitalize() {
    if (this[0] == 'x' || (this[0] == 'i' && this[1] == 'i')) {
      return toUpperCase();
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.capitalize())
      .join(" ");
}
