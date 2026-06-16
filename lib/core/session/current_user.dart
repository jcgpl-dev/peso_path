class CurrentUser {
  String? _userId;

  String? get userId => _userId;

  bool get isLoggedIn => _userId != null;

  void setUser(String userId) {
    _userId = userId;
  }

  void clear() {
    _userId = null;
  }

  String requireUserId() {
    if (_userId == null) {
      throw Exception('No logged in user');
    }

    return _userId!;
  }
}
