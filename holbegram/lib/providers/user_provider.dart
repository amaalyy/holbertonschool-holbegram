import '../models/user.dart';
import '../methods/auth_methods.dart';
import 'package:logger/logger.dart';

class UserProvider {
  final AuthMethods _authMethods = AuthMethods();
  Users? _user;

  final Logger _logger = Logger();

  Future<void> fetchUserDetails(String userId) async {
    try {
      _user = await _authMethods.getUserDetails(userId);
    } catch (e) {
      _logger.e("Error fetching user details: $e");
    }
  }

  Users? get user => _user;
}
