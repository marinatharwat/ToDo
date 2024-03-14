import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/model/my_user.dart';
import 'package:todo/model/task.dart';

class FirebaseUtils {

  static CollectionReference<Task> getTasksCollection(String uId) {
    return getUserCollection().doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
      fromFirestore: ((snapshot, options) =>
          Task.fromFireStore(snapshot.data()!)),
      toFirestore: (task, option) => task.toFirestore(),
    );
  }


  static Future<void> addTaskToFirestore(Task task,String uId) async {
    try {
      var taskCollectionRef = getTasksCollection(uId);
      DocumentReference<Task> taskDocRef = taskCollectionRef.doc();
      task.id = taskDocRef.id;
      await taskDocRef.set(task);
    } catch (e) {
      print('Error adding task to Firestore: $e');
    }
  }


 static   CollectionReference <MyUser> getUserCollection(){
 return  FirebaseFirestore.instance.collection(MyUser.collectionName).

   withConverter<MyUser>(
       fromFirestore: ((snapshot,options)=>MyUser.fromFireStore(snapshot.data() ) ),

       toFirestore:(user,_)=> user.toFireStore()
   );
  }
  static Future<void> addUserForFirestore(MyUser myUser) {
    return
      FirebaseFirestore.instance.collection('users')
          .doc(myUser.id).set({
      'name': myUser.name,
      'email': myUser.email,
        'id':myUser.id
    });
  }

  static Future<MyUser?> readUserFromFireStore(String uId) async{
   var querySnapshot=  await getUserCollection().doc(uId).get();
   return querySnapshot.data();
  }




  static Future<void> updateTask(String? userId, String? taskId, Map<String, dynamic> newTask) {
    if (userId != null && taskId != null) {
      var taskCollection = getTasksCollection(userId);
      return taskCollection.doc(taskId).update(newTask);
    } else {
      throw ArgumentError('userId and taskId must not be null.');
    }
  }



  static Future<void> deleteTask(String? uId, String? taskId) async {
    var taskCollection = getTasksCollection(uId!); // Pass the actual uId here
    await taskCollection.doc(taskId).delete(); // No need for 'return' since delete() returns void
  }


}



