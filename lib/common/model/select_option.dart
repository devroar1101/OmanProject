class SelectOption<T> {
  final String displayName;
  final String key;
  final T value;
  String? filter;
  String? filter1;
  List<SelectOption>? childOptions;

  SelectOption(
      {required this.displayName,
      required this.key,
      required this.value,
      this.filter,
      this.filter1,
      this.childOptions});
}
