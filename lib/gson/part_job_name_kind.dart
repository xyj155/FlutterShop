class PartJobNameEntity {
	String msg;
	int code;
	List<PartJobNameData> data;

	PartJobNameEntity({this.msg, this.code, this.data});

	PartJobNameEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<PartJobNameData>();(json['data'] as List).forEach((v) { data.add(new PartJobNameData.fromJson(v)); });
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

class PartJobNameData {
	List<PartJobNameDatachild> children;
	int id;
	String title;
	String craateAt;
	int parentId;

	PartJobNameData({this.children, this.id, this.title, this.craateAt, this.parentId});

	PartJobNameData.fromJson(Map<String, dynamic> json) {
		if (json['children'] != null) {
			children = new List<PartJobNameDatachild>();(json['children'] as List).forEach((v) { children.add(new PartJobNameDatachild.fromJson(v)); });
		}
		id = json['id'];
		title = json['title'];
		craateAt = json['craateAt'];
		parentId = json['parentId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.children != null) {
      data['children'] =  this.children.map((v) => v.toJson()).toList();
    }
		data['id'] = this.id;
		data['title'] = this.title;
		data['craateAt'] = this.craateAt;
		data['parentId'] = this.parentId;
		return data;
	}
}

class PartJobNameDatachild {
	int id;
	String title;
	String craateAt;
	int parentId;

	PartJobNameDatachild({this.id, this.title, this.craateAt, this.parentId});

	PartJobNameDatachild.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		title = json['title'];
		craateAt = json['craateAt'];
		parentId = json['parentId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['title'] = this.title;
		data['craateAt'] = this.craateAt;
		data['parentId'] = this.parentId;
		return data;
	}
}
