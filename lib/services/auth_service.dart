import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Instances of Firebase Authentication and Firestore Database
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. SIGN UP USER & SAVE DATA
  Future<String?> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // A. Create User in Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // B. Save User Details (Name, Email, UID) to Firestore Database
      await _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'name': name,
        'email': email,
        'createdAt': DateTime.now(),
      });

      return null; // Success (null means no error)
    } on FirebaseAuthException catch (e) {
      return e.message; // Return specific error (e.g., "Email already in use")
    } catch (e) {
      return e.toString(); // Return generic error
    }
  }

  // 2. LOGIN USER
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error (e.g., "Wrong password")
    } catch (e) {
      return e.toString();
    }
  }

  // 3. GET CURRENT USER DATA (For Profile/Dashboard)
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      // Get the current logged-in user
      User? user = _auth.currentUser;

      if (user != null) {
        // Fetch their document from the 'users' collection
        DocumentSnapshot snap = await _firestore.collection('users').doc(user.uid).get();
        return snap.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print("Error fetching user data: ${e.toString()}");
      return null;
    }
  }

  // 4. SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}