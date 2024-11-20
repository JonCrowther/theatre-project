import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResourceListPage extends StatefulWidget {
  const ResourceListPage({super.key});

  @override
  State<ResourceListPage> createState() => _ResourceListPageState();
}

class _ResourceListPageState extends State<ResourceListPage> {
  final CollectionReference _resourceDB = FirebaseFirestore.instance.collection('resources');

  late final resources = _resourceDB.get();
  late final documents = resources.then((value) {
    var d = value.docs;
    // Start with items sorted by resource_name
    d.sort((a,b) => a.get("resource_name").toString().compareTo(b.get("resource_name").toString()));
    return d;
  });
    
  bool sort = false;
  int sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: documents,
        builder: (context, snapshot){
          if (snapshot.hasData) {
            var data = snapshot.data;
            var length = data!.length;
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
                    onSortColumn(columnIndex, ascending);
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
                    onSortColumn(columnIndex, ascending);
                  },
                  ),
                const DataColumn(label: Text("Available")),
              ], 
              rows: List<DataRow>.generate(
                length,
                (int index) {
                  var document = data[index];
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(document.get("resource_name"))),
                      DataCell(Text(document.get("location"))),
                      DataCell(Text(document.get("available").toString())),
                    ],
                  );
                }
              )
            );
          }
          if (snapshot.hasError) return const Text("error");
          return const CircularProgressIndicator();
        },
      )
    );
  }
}