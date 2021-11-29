class ListService {
  static orderByAttribute(List<dynamic> objects) {
    objects.sort((a, b) => a['name'].compareTo(b['name']));
  }
}
