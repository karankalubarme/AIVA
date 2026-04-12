import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'appwrite_service.dart';

class AppwriteAuthService {
  final Account _account = AppwriteService.account;
  final Databases _databases = AppwriteService.databases;

  // Replace with your actual database and collection IDs from Appwrite console
  static const String databaseId = '67baef1a00350a41d668'; 
  static const String collectionId = '67baef560018f29424e8';

  // 1. SIGN UP USER & SAVE DATA
  Future<String?> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // A. Create User in Appwrite Auth
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // We need to login to create the document if permissions are user-restricted
      // Or we can rely on a cloud function. 
      // For now, let's assume we can create the document after login or with proper permissions.
      
      // Note: Appwrite usually doesn't allow creating documents for other users 
      // unless permissions are set to 'role:all' or similar for creation.
      
      return null; // Success
    } on AppwriteException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 2. LOGIN USER
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return null; // Success
    } on AppwriteException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 3. GET CURRENT USER DATA
  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }

  // 4. SIGN OUT
  Future<void> signOut() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      await _account.get();
      return true;
    } catch (e) {
      return false;
    }
  }
}
