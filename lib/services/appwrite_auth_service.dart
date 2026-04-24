import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'appwrite_service.dart';

class AppwriteAuthService {
  final Account _account = AppwriteService.account;
  final Databases _databases = AppwriteService.databases;
  final Storage _storage = Storage(AppwriteService.client);

  // Replace with your actual bucket ID from Appwrite console
  // TODO: Replace this with your ACTUAL bucket ID from Appwrite Console > Storage
  static const String bucketId = '69dc7d600039be7504af';
  static const String databaseId = '67baef1a00350a41d668'; 
  static const String collectionId = '67baef560018f29424e8';
  static const String projectId = '69dbcfd4000f59260ab6';

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

  // 3b. UPDATE USER DATA
  Future<String?> updateUserName(String name) async {
    try {
      await _account.updateName(name: name);
      return null;
    } on AppwriteException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateUserPassword(String password) async {
    try {
      await _account.updatePassword(password: password);
      return null;
    } on AppwriteException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 3c. UPDATE PROFILE PICTURE
  Future<String?> uploadProfilePicture(String filePath) async {
    try {
      final user = await _account.get();
      
      // Upload file to bucket
      final file = await _storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: filePath),
      );

      // Update user preferences or store in a separate collection.
      // For simplicity, we can update user prefs with the file ID.
      await _account.updatePrefs(prefs: {
        'profile_id': file.$id,
      });

      return null;
    } on AppwriteException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  String getProfileImageUrl(String fileId) {
    return '${AppwriteService.client.endPoint}/storage/buckets/$bucketId/files/$fileId/view?project=$projectId';
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

  // 5. RESET PASSWORD
  Future<String?> requestPasswordReset(String email) async {
    try {
      // Create a password recovery request
      // This will send an email to the user with a recovery link.
      // Note: The URL must be a valid domain or deep link allowed in Appwrite Console
      await _account.createRecovery(
        email: email,
        url: 'https://aiva-engineering.web.app/reset-password', 
      );
      return null; // Success
    } on AppwriteException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 6. CONFIRM PASSWORD RESET (Used after user clicks email link)
  Future<String?> confirmPasswordReset({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    try {
      await _account.updateRecovery(
        userId: userId,
        secret: secret,
        password: newPassword,
      );
      return null; // Success
    } on AppwriteException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}
