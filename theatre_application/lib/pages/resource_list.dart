import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../resource.dart';
import '../widgets/form.dart';

class ResourceListPage extends StatefulWidget {
  const ResourceListPage({super.key});

  @override
  State<ResourceListPage> createState() => _ResourceListPageState();
}

class _ResourceListPageState extends State<ResourceListPage> {
  bool sort = false;
  int sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(globals.resourceDBName).snapshots(),
          builder: (context, snapshot){
            if (snapshot.hasError) return const Text("error");
            if (!snapshot.hasData) return const CircularProgressIndicator();
            
            var data = snapshot.data!.docs;
            var length = data.length;
            onSortColumn(int columnIndex, bool ascending) {
              String column;
              switch(columnIndex) {
                case 0:
                  column = "resource_name";
                case 1:
                  column = "location";
                default:
                  return;
              }
              if (!ascending) {
                data.sort((a,b) => a.get(column).toString().compareTo(b.get(column).toString()));
              } else {
                data.sort((a,b) => b.get(column).toString().compareTo(a.get(column).toString()));
              }
            }
            return DataTable(
              sortAscending: sort,
              sortColumnIndex: sortColumnIndex,
              columns: <DataColumn>[
                DataColumn(
                  label: const Text("Name"),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (sortColumnIndex != columnIndex) {
                        sort = true;
                      } else {
                        sort = !sort;
                      }
                      sortColumnIndex = columnIndex;
                    });
                  },
                ),
                DataColumn(
                  label: const Text("Location"),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (sortColumnIndex != columnIndex) {
                        sort = true;
                      } else {
                        sort = !sort;
                      }
                      sortColumnIndex = columnIndex;
                    });
                  },
                  ),
                const DataColumn(label: Text("Available")),
                const DataColumn(label: Text("")),
              ], 
              rows: List<DataRow>.generate(
                length,
                (int index) {
                  onSortColumn(sortColumnIndex, sort);
                  var document = data[index];
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(document.get("resource_name"))),
                      DataCell(Text(document.get("location"))),
                      DataCell(Text(document.get("available").toString())),
                      DataCell(Row(
                        children: [
                          EditIcon(document: document),
                          DeleteIcon(document: document),
                        ],
                      )),
                    ],
                  );
                }
              )
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: FormWidget(resource: Resource.empty()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
