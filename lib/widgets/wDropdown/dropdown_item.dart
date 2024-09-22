class DropdownItem{
  String value;
  String title;

  DropdownItem({required this.value, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'title': title,
    };
  }

  factory DropdownItem.fromMap(Map<String, dynamic> map) {
    return DropdownItem(
      value: map['value'],
      title: map['title'],
    );
  }
}