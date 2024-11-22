import 'package:flutter/material.dart';
import '../resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../globals.dart' as globals;

class ResourceDetails extends StatefulWidget{
  const ResourceDetails({super.key, required this.resource});

  final Resource resource;

  @override
  State<StatefulWidget> createState() => _ResourceDetailsState();
}

class _ResourceDetailsState extends State<ResourceDetails> {
  late Resource myResource;
  late Text appBarTitleText;
  late TextEditingController nameController;
  late TextEditingController locationController;

  bool isFormEditable = false;
  bool inEditingMode = false;
  
  @override
  void initState() {
    myResource = widget.resource;
    appBarTitleText = Text(myResource.name);
    nameController = TextEditingController.fromValue(TextEditingValue(text: myResource.name));
    locationController = TextEditingController.fromValue(TextEditingValue(text: myResource.location));
    super.initState();
  }
  
  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(myResource.name),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text("Resource Name:"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    Flexible(
                      child: TextFormField(
                        enabled: isFormEditable,
                        controller: nameController,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Location:"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    Flexible(
                      child: TextFormField(
                        enabled: isFormEditable,
                        controller: locationController,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(inEditingMode) ...[
              Ink(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: IconButton(
                  icon: Icon(Icons.save),
                  color: Colors.white,
                  tooltip: "Save",
                  onPressed: (){
                    myResource.name = nameController.text;
                    myResource.location = locationController.text;
                    myResource.addResource();
                    setState(() {
                      isFormEditable = false;
                      inEditingMode = false;
                    });
                  },
                ),
              ),  
              Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
              Ink(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  tooltip: "Cancel",
                  onPressed: (){
                    setState(() {
                      isFormEditable = false;
                      inEditingMode = false;
                      nameController.text = myResource.name;
                      locationController.text = myResource.location;
                    });
                  },
                ),
              ),              
            ] else ...[
              Ink(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.white,
                  tooltip: "Edit",
                  onPressed: (){
                    setState(() {
                      isFormEditable = true;
                      inEditingMode = true;
                    });
                  },
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
              Ink(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.white,
                  tooltip: "Delete",
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Text("Are you sure you want to delete ${myResource.name}?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance.collection(globals.resourceDBName).doc(myResource.id).delete();
                              Navigator.pop(context, 'OK');
                              Navigator.pop(context, 'Deleted');
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
                ),
              )
            ]
          ],
        )
      ) 
    );
  }
}