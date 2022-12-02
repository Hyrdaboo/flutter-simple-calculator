// ignore_for_file: non_constant_identifier_names

class Stack<E> {
  // ignore: prefer_final_fields
  var _list = <E>[];

  void push(E value) => _list.add(value);

  E removeLast() {
    if (_list.isEmpty) {
      throw Exception("Error");
    }
    return _list.removeLast();
  }

  E pop() => removeLast();

  E get peek => _list.last;
  int get length => _list.length;
  List<E> get getList => _list.toList();

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();
}
