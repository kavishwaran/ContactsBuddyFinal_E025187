import 'package:flutter/material.dart';
import 'databasehelper.dart';


class UpdateContact  extends StatefulWidget {
  const UpdateContact({Key? key,required this.userid}) : super(key:key);
  final int userid;

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  void fetchData() async{
    Map<String, dynamic>? data = await databasehelper.getSingleData(widget.userid);
if(data != null){
  _nameController.text = data['name'];
  _numberController.text = data['number'].toString();
}
  }
  @override
  void initState()
  {
    fetchData();
    super.initState();
  }
  void _updateData(BuildContext context)async{
    Map<String, dynamic> data = {
      'name' : _nameController.text,
      'number' : _numberController.text,
    };

    int id = await databasehelper.updateData(widget.userid, data);
    Navigator.pop(context,true);
  }
  @override
  void dispose()
  {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return const Placeholder();
    return Scaffold(
      appBar: AppBar(title: const Text('Update Contact'),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextFormField(
              controller: _numberController,
              decoration: const InputDecoration(hintText: 'Number'),
            ),
            ElevatedButton(onPressed: (){
              _updateData(context);
            }, child: const Text('Update Contact'))

          ],

        ),
      ),
    );
  }
}
