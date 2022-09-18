class ApiModel {
  String? id;
   String? url;
   int? retryCount;
   int? responseStatus;
   int? periodSeconds;
   String? method;
   int? lastStatusCode;
   int? lastRetryCount;
   bool? isApiWorking;

  ApiModel({
    required this.id,
    required this.url,
    required this.retryCount,
    required this.responseStatus,
    required this.periodSeconds,
    required this.method,
    required this.lastStatusCode,
    required this.lastRetryCount,
    required this.isApiWorking,
  });

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'url': url,
        'retryCount': retryCount,
        'responseStatus': responseStatus,
        'periodSeconds': periodSeconds,
        'method': method,
        'lastStatusCode': lastStatusCode,
        'lastRetryCount': lastRetryCount,
        'isApiWorking': isApiWorking
      };

  static ApiModel fromJson(Map<String, dynamic>json) =>
      ApiModel(
        id: json['id'],
        url: json['url'],
        retryCount: json['retryCount'],
        responseStatus: json['responseStatus'],
        periodSeconds: json['periodSeconds'],
        method: json['method'],
        lastStatusCode: json['lastStatusCode'],
        lastRetryCount: json['lastRetryCount'],
        isApiWorking: json['isApiWorking'],);
}