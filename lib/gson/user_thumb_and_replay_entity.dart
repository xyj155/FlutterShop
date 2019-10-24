class UserThumbAndReplayEntity {
	String msg;
	int code;
	List<UserThumbAndReplayData> data;

	UserThumbAndReplayEntity({this.msg, this.code, this.data});

	UserThumbAndReplayEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<UserThumbAndReplayData>();(json['data'] as List).forEach((v) { data.add(new UserThumbAndReplayData.fromJson(v)); });
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

class UserThumbAndReplayData {
	int unreadThumb;
	int unreadComment;

	UserThumbAndReplayData({this.unreadThumb, this.unreadComment});

	UserThumbAndReplayData.fromJson(Map<String, dynamic> json) {
		unreadThumb = json['unreadThumb'];
		unreadComment = json['unreadComment'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['unreadThumb'] = this.unreadThumb;
		data['unreadComment'] = this.unreadComment;
		return data;
	}
}
