class SchoolActivityEntity {
	String msg;
	int code;
	List<SchoolActivityData> data;

	SchoolActivityEntity({this.msg, this.code, this.data});

	SchoolActivityEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<SchoolActivityData>();(json['data'] as List).forEach((v) { data.add(new SchoolActivityData.fromJson(v)); });
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

class SchoolActivityData {
	String webUrl;
	String activityPictureUrl;
	String activityName;
	int id;
	String createAt;

	SchoolActivityData({this.webUrl, this.activityPictureUrl, this.activityName, this.id, this.createAt});

	SchoolActivityData.fromJson(Map<String, dynamic> json) {
		webUrl = json['webUrl'];
		activityPictureUrl = json['activityPictureUrl'];
		activityName = json['activityName'];
		id = json['id'];
		createAt = json['createAt'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['webUrl'] = this.webUrl;
		data['activityPictureUrl'] = this.activityPictureUrl;
		data['activityName'] = this.activityName;
		data['id'] = this.id;
		data['createAt'] = this.createAt;
		return data;
	}
}
