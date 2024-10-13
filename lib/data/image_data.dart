class ImageData{  // model/pojo class
  final String? description, picUrl, dateTime, uploaderEmail, uploaderHandle, uploaderUid;
  ImageData({
    required this.description,
    required this.picUrl,
    required this.dateTime,
    required this.uploaderEmail,
    required this.uploaderHandle,
    required this.uploaderUid,
  });
  factory ImageData.fromJson(String id, Map<String, dynamic> json){
    return ImageData(
      description: json['description'],
      picUrl: json['picUrl'],
      dateTime: json['dateTime'],
      uploaderEmail: json['uploaderEmail'],
      uploaderHandle: json['uploaderHandle']??'Unknown',
      uploaderUid: json['uploaderUid'],
    );
  }
}