import 'package:hive/hive.dart';
part 'api_info_model.g.dart';

@HiveType(typeId: 1)
class ApiInfoModel {
  @HiveField(0)
  String url;

  @HiveField(1)
  String method;

  @HiveField(2)
  int responseStatus;

  @HiveField(3)
  int retryCount;

  @HiveField(4)
  int periodSeconds;

  @HiveField(5)
  bool? isApiWorking;

  @HiveField(6)
  int? lastStatusCode;

  @HiveField(7)
  int? lastRetryCount;
  ApiInfoModel(this.url, this.method, this.responseStatus, this.retryCount,
      this.periodSeconds);
}

