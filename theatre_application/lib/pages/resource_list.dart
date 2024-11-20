import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResourceListPage extends StatefulWidget {
  const ResourceListPage({super.key});

  @override
  State<ResourceListPage> createState() => _ResourceListPageState();
}

class _ResourceListPageState extends State<ResourceListPage> {
  final CollectionReference _resourceDB = FirebaseFirestore.instance.collection('resources');

  late Stream<QuerySnapshot<Object?>> _resources = Stream.fromFuture(_resourceDB.get());

  bool sort = false;
  int sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: _resources,
        builder: (context, snapshot){
          if (snapshot.hasData) {            
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
                    onSortColumn(columnIndex, ascending);
                    for (final d in data) {
                      print(d.data());
                    }
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
                const DataColumn(label: Text("")),
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
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _resourceDB.doc(document.id).delete();
                              setState(() {
                                _resources = Stream.fromFuture(_resourceDB.get());
                              });
                            },
                          ),
                        ],
                      )),
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