class PetStreet {
  final String Image_1;

  PetStreet({this.Image_1});

  PetStreet.fromJson(Map<String, dynamic> json) : Image_1 = json['image_1'];

  Map<String, dynamic> toJson() => {'image_1': Image_1};
}
