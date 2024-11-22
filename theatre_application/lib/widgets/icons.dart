import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../resource.dart';
import '../widgets/form.dart';
import '../globals.dart' as globals;

class EditIcon extends StatelessWidget {
  const EditIcon({
    super.key,
    required this.document,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> document;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        Resource r = Resource.fromDocument(document);
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: FormWidget(resource: r),
          ),
        );
      },
    );
  }
}

class DeleteIcon extends StatelessWidget {
  const DeleteIcon({
    super.key,
    required this.document,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> document;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text("Are you sure you want to delete ${document.get("resource_name")}?"),
            actions: [
              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance.collection(globals.resourceDBName).doc(document.id).delete();
                  Navigator.pop(context, 'OK');
                },
                child: const Text("Ok"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, "Cancel"),
                child: const Text("Cancel"),
              )
            ],
          )
        );
      },
    );
  }
}
