import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/api_model.dart';

class FirestoreSevice{
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future createApiInfo({
    required String url,
    required int retryCount,
    required int responseStatus,
    required int periodSeconds,
    required String method,
    required int lastStatusCode,
    required int lastRetryCount,
    required bool isApiWorking,
  }) async {
    final apiInfoFire = FirebaseFirestore.instance.collection('Person').doc(_auth.currentUser?.uid).collection('ApiInfos').doc();

    final api = ApiModel(
        id: apiInfoFire.id,
        url: url,
        retryCount: retryCount,
        responseStatus: responseStatus,
        periodSeconds: periodSeconds,
        method: method,
        lastStatusCode: lastStatusCode,
        lastRetryCount: lastRetryCount,
        isApiWorking: false);

    final json = api.toJson();

    await apiInfoFire.set(json);
  }

  Stream<List<ApiModel>> readApiInfos() =>
      FirebaseFirestore.instance.collection('Person').doc(_auth.currentUser?.uid).collection('ApiInfos').snapshots(

      ).map((snapshot) => snapshot.docs.map((doc) =>ApiModel.fromJson(doc.data())).toList());


}
/*Widget buidApiInfo(ApiModel apiModel)=> ListTile(

  leading: Text("${apiModel.isApiWorking}"),
  title: Text(apiModel.url!),
  subtitle: Text(apiModel.method!),

);*/








