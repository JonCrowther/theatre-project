import 'package:flutter/material.dart';
import '../resource.dart';

class ResourceDetails extends StatefulWidget{
  const ResourceDetails({super.key, required this.resource});

  final Resource resource;

  @override
  State<StatefulWidget> createState() => _ResourceDetailsState();
}

class _ResourceDetailsState extends State<ResourceDetails> {
  late Resource myResource;
  late Text appBarTitleText;
  TextEditingController? nameController;
  TextEditingController? locationController;

  bool isFormEditable = false;
  
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
    nameController!.dispose();
    locationController!.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: appBarTitleText,
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
                  });
                },
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
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
                    nameController!.text = myResource.name;
                    locationController!.text = myResource.location;
                  });
                },
              ),
            )
          ],
        )
      ) 
    );
  }
}