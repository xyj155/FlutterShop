class PostCommentListEntity {
	String msg;
	int code;
	List<PostCommentListData> data;

	PostCommentListEntity({this.msg, this.code, this.data});

	PostCommentListEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<PostCommentListData>();(json['data'] as List).forEach((v) { data.add(new PostCommentListData.fromJson(v)); });
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

class PostCommentListData {
	String createTime;
	String comment;
	int id;
	int postId;
	int userId;
	PostCommentListDataUser user;

	PostCommentListData({this.createTime, this.comment, this.id, this.postId, this.userId, this.user});

	PostCommentListData.fromJson(Map<String, dynamic> json) {
		createTime = json['createTime'];
		comment = json['comment'];
		id = json['id'];
		postId = json['postId'];
		userId = json['userId'];
		user = json['user'] != null ? new PostCommentListDataUser.fromJson(json['user']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['createTime'] = this.createTime;
		data['comment'] = this.comment;
		data['id'] = this.id;
		data['postId'] = this.postId;
		data['userId'] = this.userId;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
		return data;
	}
}

class PostCommentListDataUser {
	String sex;
	String nickname;
	String isOnline;
	String avatar;
	int id;

	PostCommentListDataUser({this.sex, this.nickname, this.isOnline, this.avatar, this.id});

	PostCommentListDataUser.fromJson(Map<String, dynamic> json) {
		sex = json['sex'];
		nickname = json['nickname'];
		isOnline = json['isOnline'];
		avatar = json['avatar'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['sex'] = this.sex;
		data['nickname'] = this.nickname;
		data['isOnline'] = this.isOnline;
		data['avatar'] = this.avatar;
		data['id'] = this.id;
		return data;
	}
}
