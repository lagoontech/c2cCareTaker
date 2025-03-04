class ServiceStatusModel{

  String ?serviceDate;
  int ?status;

  ServiceStatusModel({this.serviceDate, this.status});


  factory ServiceStatusModel.fromJson(Map<String,dynamic> json){
    return ServiceStatusModel(
      serviceDate: json['appointment_date'] as String?,
      status: json['service_status'] as int?,
    );
  }

}