import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'appwrite_service.dart';

class AppwriteDataService {
  final Databases _databases = AppwriteService.databases;
  final Account _account = AppwriteService.account;

  static const String databaseId = '69dd27f50026eb5b8557';
  static const String tasksCollectionId = '69dd29950015e2a94b94';
  static const String remindersCollectionId = '69dd2a9b001469d19ea5';
  static const String ocrCollectionId = '69e1bcce002d5a30a08b'; 
  static const String chatCollectionId = '69dd2c2e002a2e4b9a1a';

  // --- Chat History ---

  Future<models.Document?> saveChatMessage(String message, String response) async {
    try {
      final user = await _account.get();
      return await _databases.createDocument(
        databaseId: databaseId,
        collectionId: chatCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': user.$id,
          'message': message,
          'response': response,
          'timestamp': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(user.$id)),
          Permission.update(Role.user(user.$id)),
          Permission.delete(Role.user(user.$id)),
        ],
      );
    } catch (e) {
      print("Error saving chat message: $e");
      return null;
    }
  }

  Future<List<models.Document>> getChatHistory() async {
    try {
      final user = await _account.get();
      final response = await _databases.listDocuments(
        databaseId: databaseId,
        collectionId: chatCollectionId,
        queries: [
          Query.equal('userId', user.$id),
          Query.orderDesc('timestamp'),
        ],
      );
      return response.documents;
    } catch (e) {
      print("Error fetching chat history: $e");
      return [];
    }
  }

  // --- Study Planner (Tasks) ---

  Future<List<models.Document>> getTasks({DateTime? date}) async {
    try {
      final user = await _account.get();
      List<String> queries = [
        Query.equal('userId', user.$id),
      ];

      // Re-enabled date filtering (Ensure 'date' index exists in Appwrite)
      if (date != null) {
        final dateStr = date.toString().split(' ')[0]; 
        queries.add(Query.equal('date', dateStr));
      }

      final response = await _databases.listDocuments(
        databaseId: databaseId,
        collectionId: tasksCollectionId,
        queries: queries,
      );
      return response.documents;
    } catch (e) {
      print("Error fetching tasks: $e");
      return [];
    }
  }

  Future<models.Document?> addTask(Map<String, dynamic> data) async {
    try {
      final user = await _account.get();
      data['userId'] = user.$id;
      return await _databases.createDocument(
        databaseId: databaseId,
        collectionId: tasksCollectionId,
        documentId: ID.unique(),
        data: data,
      );
    } on AppwriteException catch (e) {
      print("Appwrite error adding task: ${e.message} (Code: ${e.code})");
      return null;
    } catch (e) {
      print("General error adding task: $e");
      return null;
    }
  }

  Future<void> updateTask(String documentId, Map<String, dynamic> data) async {
    try {
      await _databases.updateDocument(
        databaseId: databaseId,
        collectionId: tasksCollectionId,
        documentId: documentId,
        data: data,
      );
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  Future<void> deleteTask(String documentId) async {
    try {
      await _databases.deleteDocument(
        databaseId: databaseId,
        collectionId: tasksCollectionId,
        documentId: documentId,
      );
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  // --- OCR History ---

  Future<models.Document?> saveOCRScan(String text) async {
    try {
      // Check if ID is still a placeholder
      if (ocrCollectionId.contains('YOUR_ACTUAL')) {
        print("⚠️ Appwrite OCR Collection ID not set. Please update appwrite_data_service.dart");
        return null;
      }

      final user = await _account.get();
      return await _databases.createDocument(
        databaseId: databaseId,
        collectionId: ocrCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': user.$id,
          'text': text,
          'timestamp': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(user.$id)),
          Permission.update(Role.user(user.$id)),
          Permission.delete(Role.user(user.$id)),
        ],
      );
    } catch (e) {
      print("Error saving OCR scan: $e");
      return null;
    }
  }

  Future<List<models.Document>> getOCRHistory() async {
    try {
      final user = await _account.get();
      final response = await _databases.listDocuments(
        databaseId: databaseId,
        collectionId: ocrCollectionId,
        queries: [
          Query.equal('userId', user.$id),
          Query.orderDesc('timestamp'),
        ],
      );
      return response.documents;
    } catch (e) {
      print("Error fetching OCR history: $e");
      return [];
    }
  }

  // --- Reminders ---

  Future<List<models.Document>> getReminders() async {
    try {
      final user = await _account.get();
      final response = await _databases.listDocuments(
        databaseId: databaseId,
        collectionId: remindersCollectionId,
        queries: [
          Query.equal('userId', user.$id),
        ],
      );
      return response.documents;
    } catch (e) {
      print("Error fetching reminders: $e");
      return [];
    }
  }

  Future<models.Document?> addReminder(Map<String, dynamic> data) async {
    try {
      final user = await _account.get();
      data['userId'] = user.$id;
      return await _databases.createDocument(
        databaseId: databaseId,
        collectionId: remindersCollectionId,
        documentId: ID.unique(),
        data: data,
      );
    } catch (e) {
      print("Error adding reminder: $e");
      return null;
    }
  }

  Future<void> deleteReminder(String documentId) async {
    try {
      await _databases.deleteDocument(
        databaseId: databaseId,
        collectionId: remindersCollectionId,
        documentId: documentId,
      );
    } catch (e) {
      print("Error deleting reminder: $e");
    }
  }
}
