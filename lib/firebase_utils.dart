import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/model/task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollection() {
    return FirebaseFirestore.instance
        .collection(Task.collectionName)
        .withConverter<Task>(
      fromFirestore: ((snapshot, options) =>
          Task.fromFireStore(snapshot.data()!)),
      toFirestore: (task, option) => task.toFirestore(),
    );
  }


  static Future<void> addTaskToFirestore(Task task) async {
    try {
      var taskCollectionRef = getTasksCollection();
      DocumentReference<Task> taskDocRef = taskCollectionRef.doc();
      task.id = taskDocRef.id;
      await taskDocRef.set(task);
    } catch (e) {
      print('Error adding task to Firestore: $e');
    }
  }}