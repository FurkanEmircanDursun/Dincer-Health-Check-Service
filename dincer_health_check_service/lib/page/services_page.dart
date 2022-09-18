import 'package:dincer_health_check_service/page/edit_data_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../model/api_model.dart';
import '../service/firestore.dart';
import 'add_data_page.dart';

class ServicesPage extends StatefulWidget {
  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  FirestoreSevice _firestoreSevice=FirestoreSevice();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddDataPage()));
        },),

      body: SafeArea(
        child: Center(
          child:  StreamBuilder<List<ApiModel>>(

              stream: _firestoreSevice.readApiInfos(),
              builder: (context,snapshot){
                if (snapshot.hasData) {
                  var datalist = snapshot.data;
                  return ListView.builder(
                  itemBuilder: (context, index) {
                    var dataRightNow = datalist![index];

                    return Card(
                      child: ListTile(

                        title: Text(dataRightNow.url!),
                        subtitle: Text(dataRightNow.method!),
                        onTap: () {
                          print("my index =" + index.toString());
                          EditDataPage.index = index;
                          EditDataPage.dataRightNow = dataRightNow;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditDataPage()));
                        },
                      ),
                    );
                  },
                  itemCount: datalist?.length,
                    );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
