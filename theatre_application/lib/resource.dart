import 'package:cloud_firestore/cloud_firestore.dart';

class Resource {
  String id = "";
  String name = "";
  String location = "";
  bool available = false;

  @override
  String toString() {
    return "id $id\nname $name\nlocation $location\navailable $available";
  }

  Resource(this.id, this.name, this.location, this.available);
  Resource.empty() {
    id = "";
    name = "";
    location = "";
    available = false;
  }
  Resource.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    id = document.id;
    name = document.get('resource_name');
    location = document.get('location');
    available = document.get('available');
  }

  CollectionReference resourceDB = FirebaseFirestore.instance.collection('resources');
  Future<void> addResource() {
    Map<String, dynamic> r = {
      'resource_name': name,
      'location': location,
      'available': available,
    };
    
    if (id == "") {
      return resourceDB.add(r);
    } else {
      return resourceDB.doc(id).update(r);
    }
  }
}