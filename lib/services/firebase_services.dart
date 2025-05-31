import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create
  Future<void> createData(String collectionName, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).add(data);
    } catch (e) {

      if (kDebugMode) {
        print('Error creating data: $e');
      }
      throw Exception('Failed to create data: $e');
    }
  }

  // Read
  Future<List<Map<String, dynamic>>> fetchData(String collectionName) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {

      print('Error fetching data: $e');
      throw Exception('Failed to fetch data: $e');
    }
  }

  // Update
  Future<void> updateData(String collectionName, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).update(data);
    } catch (e) {

      print('Error updating data: $e');
      throw Exception('Failed to update data: $e');
    }
  }

  // Delete
  Future<void> deleteData(String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
    } catch (e) {

      print('Error deleting data: $e');
      throw Exception('Failed to delete data: $e');
    }
  }
}
// extension ChatFirestoreExtension on FirestoreService {
//   /// Listen to chat messages in real-time
//   Stream<List<ChatMessage>> streamMessages(String collectionName) {
//     return _firestore
//         .collection(collectionName)
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final data = doc.data();
//         return ChatMessage(
//           text: data['text'] ?? '',
//           isSender: data['isSender'] ?? false,
//           timestamp: (data['timestamp'] as Timestamp).toDate(),
//           username: data['username'] ?? '',
//           userId: data['userId'] ?? '',
//         );
//       }).toList();
//     });
//   }
//
//   /// Send a message to Firestore
//   Future<void> sendMessageToFirestore(String collectionName, ChatMessage message) async {
//     await createData(collectionName, {
//       'text': message.text,
//       'isSender': message.isSender,
//       'timestamp': message.timestamp,
//       'username': message.username,
//       'userId': message.userId,
//     });
//   }
// }




class FirebaseRealtimeService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Listen to real-time data at a given path
  Stream<DatabaseEvent> streamData(String path) {
    return _dbRef.child(path).onValue;
  }

  /// Write data to a node
  Future<void> setData(String path, Map<String, dynamic> data) async {
    await _dbRef.child(path).set(data);
  }

  /// Add a new entry with a unique key (like push())
  Future<void> addData(String path, Map<String, dynamic> data) async {
    await _dbRef.child(path).push().set(data);
  }

  /// Update specific fields in an existing node
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    await _dbRef.child(path).update(data);
  }

  /// Delete data at a specific path
  Future<void> deleteData(String path) async {
    await _dbRef.child(path).remove();
  }

  /// Read data once (not listening)
  Future<DataSnapshot> readDataOnce(String path) async {
    return await _dbRef.child(path).get();
  }
}

