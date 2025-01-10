import 'package:firebase_auth/firebase_auth.dart' as auth;  // Alias the Firebase User import
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/user.dart';

class DatabaseServicesUsers {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save a new user to Firestore
  static Future<void> saveUserToFirestore(User user) async {
    final currentUser = auth.FirebaseAuth.instance.currentUser;  // Use the aliased Firebase User class

    if (currentUser != null) {
      user.userID = currentUser.uid; // Set the user ID from FirebaseAuth
    } else {
      throw Exception('No user logged in');
    }

    try {
      await _db.collection('users').doc(user.userID).set(user.toMap());
      print('User added successfully.');
    } catch (e) {
      throw Exception('Failed to save user to Firestore: $e');
    }
  }

  // Fetch a user from Firestore by userID
  static Future<User?> fetchUserFromFirestore(String userID) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('users').doc(userID).get();

      if (userDoc.exists) {
        return User.fromFirestore(userDoc.data() as Map<String, dynamic>);
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch user from Firestore: $e');
    }
  }

  // Update an existing user in Firestore
  static Future<void> updateUserInFirestore(String userID, User user) async {
    try {
      await _db.collection('users').doc(userID).update(user.toMap());
      print('User updated successfully.');
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete a user by ID from Firestore
  // static Future<void> deleteUserFromFirestore(String userID) async {
  //   try {
  //     await _db.collection('users').doc(userID).delete();
  //     print('User deleted successfully.');
  //   } catch (e) {
  //     throw Exception('Failed to delete user: $e');
  //   }
  // }


  static Future delete(String userID) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    try {
      // Check if the document exists first
      var docSnapshot = await userCollection.doc(userID).get();

      if (docSnapshot.exists) {
        // If the document exists, proceed to delete
        await userCollection.doc(userID).delete();
        print("User data deleted successfully.");
      } else {
        throw Exception("User document not found.");
      }
    } catch (e) {
      throw Exception('Failed to delete user data from Firestore: $e');
    }
  }


  // Fetch the current user from Firestore based on the FirebaseAuth current user
  static Future<User?> fetchCurrentUser() async {
    final currentUser = auth.FirebaseAuth.instance.currentUser;  // Use the aliased Firebase User class

    if (currentUser != null) {
      return await fetchUserFromFirestore(currentUser.uid);
    } else {
      throw Exception('No user logged in');
    }
  }
}
