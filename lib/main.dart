import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'package:contacts_management/add_contacts.dart';
import 'package:contacts_management/update_contact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

  void _saveData() async {
    final name = _nameController.text;
    final number = int.tryParse(_numberController.text) ?? 0;
    int insertId = await databasehelper.insertContact(name, number);
    List<Map<String, dynamic>> updatedList = await databasehelper.getData();
    setState(() {
      dataList = updatedList;
    });
    _nameController.text = '';
    _numberController.text = '';
  }

  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  void _fetchUsers() async {
    List<Map<String, dynamic>> userList = await databasehelper.getData();
    setState(() {
      dataList = userList;
    });
  }

  void fetchData() async {
    List<Map<String, dynamic>> fetchedData = await databasehelper.getData();
    setState(() {
      dataList = fetchedData;
    });
  }

  void searchContacts(String keyword) async {
    List<Map<String, dynamic>> searchResult = await databasehelper.searchNotes(keyword);
    setState(() {
      dataList = searchResult;
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
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Contacts Buddy"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddContact()),
                  ).then((result) {
                    if (result == true) {
                      fetchData();
                    }
                  });
                },
                icon: const Icon(Icons.add),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      searchContacts(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Form(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
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
                                      fetchData();
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),

                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
