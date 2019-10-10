class UserReceiveAddressEntity {
	String msg;
	int code;
	List<UserReceiveAddressData> data;

	UserReceiveAddressEntity({this.msg, this.code, this.data});

	UserReceiveAddressEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<UserReceiveAddressData>();(json['data'] as List).forEach((v) { data.add(new UserReceiveAddressData.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		data['code'] = this.code;
		if (this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class UserReceiveAddressData {
	String sexTag;
	String localCity;
	String userTel;
	String currentCity;
	int id;
	String addressNum;
	int userId;
	String username;

	UserReceiveAddressData({this.sexTag, this.localCity, this.userTel, this.currentCity, this.id, this.addressNum, this.userId, this.username});

	UserReceiveAddressData.fromJson(Map<String, dynamic> json) {
		sexTag = json['sexTag'];
		localCity = json['localCity'];
		userTel = json['userTel'];
		currentCity = json['currentCity'];
		id = json['id'];
		addressNum = json['addressNum'];
		userId = json['userId'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['sexTag'] = this.sexTag;
		data['localCity'] = this.localCity;
		data['userTel'] = this.userTel;
		data['currentCity'] = this.currentCity;
		data['id'] = this.id;
		data['addressNum'] = this.addressNum;
		data['userId'] = this.userId;
		data['username'] = this.username;
		return data;
	}
}
