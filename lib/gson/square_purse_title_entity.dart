class SquarePurseTitleEntity {
	String msg;
	int code;
	List<SquarePurseTitleData> data;

	SquarePurseTitleEntity({this.msg, this.code, this.data});

	SquarePurseTitleEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<SquarePurseTitleData>();(json['data'] as List).forEach((v) { data.add(new SquarePurseTitleData.fromJson(v)); });
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

class SquarePurseTitleData {
	String purseKind;
	String subtitle;
	int id;
	String createAt;

	SquarePurseTitleData({this.purseKind, this.subtitle, this.id, this.createAt});

	SquarePurseTitleData.fromJson(Map<String, dynamic> json) {
		purseKind = json['purseKind'];
		subtitle = json['subtitle'];
		id = json['id'];
		createAt = json['createAt'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['purseKind'] = this.purseKind;
		data['subtitle'] = this.subtitle;
		data['id'] = this.id;
		data['createAt'] = this.createAt;
		return data;
	}
}
