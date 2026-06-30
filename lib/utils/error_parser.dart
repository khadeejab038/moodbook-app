import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ErrorParser {
  static String getFriendlyMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'network-request-failed':
          return 'Connection lost. Please check your internet connection and try again.';
        case 'user-not-found':
          return "We couldn't find an account with that email address.";
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'This email address is already in use by another account.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-disabled':
          return 'This account has been deactivated. Please contact support.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again in a few minutes.';
        case 'weak-password':
          return 'Your password is too weak. Please use at least 6 characters.';
        case 'requires-recent-login':
          return 'For your security, please log out and log back in to complete this action.';
        default:
          return error.message ?? 'Authentication failed. Please try again.';
      }
    }
    
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return "Access denied. You don't have permission to modify this data.";
        case 'unavailable':
          return 'Service temporarily unavailable. Please try again later.';
        case 'deadline-exceeded':
          return 'The operation timed out. Please check your connection.';
        default:
          return error.message ?? 'A database error occurred. Please try again.';
      }
    }

    if (error is SocketException) {
      return 'Connection lost. Please check your internet connection and try again.';
    }

    final errStr = error.toString().toLowerCase();
    if (errStr.contains('socketexception') || errStr.contains('network') || errStr.contains('connection failed')) {
      return 'Connection lost. Please check your internet connection and try again.';
    }

    // Strip generic Exception prefix if present
    if (error is Exception) {
      final msg = error.toString();
      if (msg.startsWith('Exception: ')) {
        return msg.substring(11);
      }
    }

    return 'An unexpected error occurred. Please try again.';
  }
}
