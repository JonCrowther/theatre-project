import 'package:cloud_firestore/cloud_firestore.dart';

class Resource {
  String name = 'DefaultName';
  String location = 'DefaultLocation';
  bool available = false;

  CollectionReference resourceDB = FirebaseFirestore.instance.collection('resources');
  Future<void> addResource() {
    return resourceDB.add({
        'resource_name': name,
        'location': location,
        'available': available,
    });
  }
}