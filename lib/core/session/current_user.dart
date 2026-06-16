class CurrentUser {
  String? _userId;

  String? get userId => _userId;

  void setUserId(String id) {
    _userId = id;
  }

  void clear() {
    _userId = null;
  }

  String requireUserId() {
    final id = _userId;
    if (id == null || id.isEmpty) {
      throw StateError('No authenticated user found.');
    }
    return id;
  }
}
