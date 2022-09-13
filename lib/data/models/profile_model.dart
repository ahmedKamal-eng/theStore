// {
// "status": true,
// "message": null,
// "data": {
// "id": 2972,
// "name": "ahmed kamal ali",
// "email": "ahmed23@gmail.com",
// "phone": "01097308727",
// "image": "https://student.valuxapps.com/storage/assets/defaults/user.jpg",
// "points": 0,
// "credit": 0,
// "token": "V0t6JvI0rszcYBY8NEHYuDimu2SmbYyGUbMr2rVjmsNFTR2DZmAQmBiCiKf2MHtOQHaZ40"
// }
// }

class ProfileModel {
 late bool status;
 late String message;
 late ProfileData data;
  ProfileModel(this.status,this.message,this.data);

  factory ProfileModel.fromJson(json){
    return ProfileModel(json['status'], json['message'], ProfileData.fromJson(json['data']));
  }
}

class ProfileData{
 late int id;
 late String name;
 late String email;
 late String image;
 late String phone;
  String token;
  ProfileData(this.id,this.name,this.email,this.image,this.token);

  factory ProfileData.fromJson(json){
    return ProfileData(json['id'], json['name'], json['email'], json['image'], json['token']);
  }

}