class SelectOption<T> {
  final String displayName;
  final String key;
  final T value;

  SelectOption(
      {required this.displayName, required this.key, required this.value});
}
