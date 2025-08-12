import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/priority.dart';

class PriorityServices {
  static const String kPriorityCollection = 'priorityCollection';

  ///Create Priority
  Future createPriority(PriorityModel model) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(kPriorityCollection)
        .doc();
    return await FirebaseFirestore.instance
        .collection(kPriorityCollection)
        .doc(documentReference.id)
        .set(model.toJson(documentReference.id));
  }

  ///Get All Priorities
  Stream<List<PriorityModel>> getAllPriorities() {
    return FirebaseFirestore.instance
        .collection(kPriorityCollection)
        .snapshots()
        .map(
          (priorityList) => priorityList.docs
              .map(
                (priorityJson) => PriorityModel.fromJson(priorityJson.data()),
              )
              .toList(),
        );
  }

  ///Get All Priorities
  Future<List<PriorityModel>> getAllPrioritiesViaFuture() {
    return FirebaseFirestore.instance
        .collection(kPriorityCollection)
        .get()
        .then(
          (priorityList) => priorityList.docs
              .map(
                (priorityJson) => PriorityModel.fromJson(priorityJson.data()),
              )
              .toList(),
        );
  }

  ///Update Priority
  Future updatePriority(PriorityModel model) async {
    return await FirebaseFirestore.instance
        .collection(kPriorityCollection)
        .doc(model.docId)
        .update({'name': model.name});
  }

  ///Delete Priority
  Future deletePriority(PriorityModel model) async {
    return await FirebaseFirestore.instance
        .collection(kPriorityCollection)
        .doc(model.docId)
        .delete();
  }
}
