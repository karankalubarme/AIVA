import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'appwrite_service.dart';

class AppwriteDataService {
  final Databases _databases = AppwriteService.databases;
  final Account _account = AppwriteService.account;

  static const String databaseId = '69dd27f50026eb5b8557';
  static const String tasksCollectionId = '69dd29950015e2a94b94';
  static const String remindersCollectionId = '69dd2a9b001469d19ea5';

  // --- Study Planner (Tasks) ---

  Future<List<models.Document>> getTasks() async {
    try {
      final user = await _account.get();
      final response = await _databases.listDocuments(
        databaseId: databaseId,
        collectionId: tasksCollectionId,
        queries: [
          Query.equal('userId', user.$id),
        ],
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
