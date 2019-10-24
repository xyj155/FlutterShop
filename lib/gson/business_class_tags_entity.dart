class BusinessClassTagsEntity {
	String msg;
	int code;
	List<BusinessClassTagsData> data;

	BusinessClassTagsEntity({this.msg, this.code, this.data});

	BusinessClassTagsEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<BusinessClassTagsData>();(json['data'] as List).forEach((v) { data.add(new BusinessClassTagsData.fromJson(v)); });
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

class BusinessClassTagsData {
	int id;
	String businessTag;

	BusinessClassTagsData({this.id, this.businessTag});

	BusinessClassTagsData.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		businessTag = json['businessTag'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['businessTag'] = this.businessTag;
		return data;
	}
}
