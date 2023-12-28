import 'package:contacts_management/update_contact.dart';
import 'package:flutter/material.dart';
import 'databasehelper.dart';


class AddContact  extends StatefulWidget {


  @override
  State<AddContact> createState() => _AddContact();
}

class _AddContact extends State<AddContact> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

  void _saveData() async {
    final name = _nameController.text;
    final number = int.tryParse(_numberController.text) ?? 0;
    // Check if name is empty
    if (name.isEmpty) {
      _showSnackBar("Name cannot be empty");
      return;
    }

    // Check if number is zero or negative
    if (number <= 0) {
      _showSnackBar("Number must be greater than zero");
      return;
    }
    print(number);
    int insertid = await databasehelper.insertContact(name, number);
    print(insertid);
    List<Map<String, dynamic>> updatedList = await databasehelper.getData();
    setState(() {
      dataList = updatedList;
    });
    _nameController.text = '';
    _numberController.text = '';
    _showSuccessDialog('Successfully saved');
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
    void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  void _fetchUsers() async {
    List<Map<String, dynamic>> userlist = await databasehelper.getData();
    setState(() {
      dataList = userlist;
    });
  }
  void _delete(int cid) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this contact?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmed
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Not confirmed
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      int id = await databasehelper.deleteData(cid);
      List<Map<String, dynamic>> updatedData = await databasehelper.getData();
      setState(() {
        dataList = updatedData;
      });
      _showSuccessDialog('Successfully Contact Deleted');
    }

  }

  void fetchData() async{
    List<Map<String, dynamic>> fetchedData = await databasehelper.getData();
    setState(() {
      dataList = fetchedData;
    });
  }
  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Contact"),
        actions: [],
      ),
      body: Form(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "name is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text("Name"),
                      ),
                    ),
                    TextFormField(
                      controller: _numberController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Number is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text("Number"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _saveData,
                      child: const Text('Save Contact'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(dataList[index]['name']),
                          subtitle: Text('Number:${dataList[index]['number']}'),
                          trailing: Row(
                            mainAxisSize:  MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context)=> UpdateContact(userid :dataList[index]['id']),
                                  ),).then((result){
                                    if(result == true){
                                      _showSuccessDialog('Successfully Record Updated');
                                      fetchData();
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _delete(dataList[index]['id']);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          )),
    );
  }
}
