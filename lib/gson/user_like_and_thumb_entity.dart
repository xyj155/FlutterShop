class UserLikeAndThumbEntity {
	String msg;
	int code;
	List<UserLikeAndThumbData> data;

	UserLikeAndThumbEntity({this.msg, this.code, this.data});

	UserLikeAndThumbEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<UserLikeAndThumbData>();(json['data'] as List).forEach((v) { data.add(new UserLikeAndThumbData.fromJson(v)); });
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

class UserLikeAndThumbData {
	String postUserId;
	UserLikeAndThumbDataPost post;
	String createTime;
	String isRead;
	int id;
	String postId;
	String userId;
	UserLikeAndThumbDataUser user;

	UserLikeAndThumbData({this.postUserId, this.post, this.createTime, this.isRead, this.id, this.postId, this.userId, this.user});

	UserLikeAndThumbData.fromJson(Map<String, dynamic> json) {
		postUserId = json['postUserId'];
		post = json['post'] != null ? new UserLikeAndThumbDataPost.fromJson(json['post']) : null;
		createTime = json['createTime'];
		isRead = json['isRead'];
		id = json['id'];
		postId = json['postId'];
		userId = json['userId'];
		user = json['user'] != null ? new UserLikeAndThumbDataUser.fromJson(json['user']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['postUserId'] = this.postUserId;
		if (this.post != null) {
      data['post'] = this.post.toJson();
    }
		data['createTime'] = this.createTime;
		data['isRead'] = this.isRead;
		data['id'] = this.id;
		data['postId'] = this.postId;
		data['userId'] = this.userId;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
		return data;
	}
}

class UserLikeAndThumbDataPost {
	int visible;
	String postContent;
	int postType;
	dynamic postTopic;
	int userId;
	String commentCount;
	dynamic duration;
	String shareCount;
	String createTime;
	String location;
	int id;
	String thumbCount;
	dynamic lantitude;
	dynamic longitude;

	UserLikeAndThumbDataPost({this.visible, this.postContent, this.postType, this.postTopic, this.userId, this.commentCount, this.duration, this.shareCount, this.createTime, this.location, this.id, this.thumbCount, this.lantitude, this.longitude});

	UserLikeAndThumbDataPost.fromJson(Map<String, dynamic> json) {
		visible = json['visible'];
		postContent = json['postContent'];
		postType = json['postType'];
		postTopic = json['postTopic'];
		userId = json['userId'];
		commentCount = json['commentCount'];
		duration = json['duration'];
		shareCount = json['shareCount'];
		createTime = json['createTime'];
		location = json['location'];
		id = json['id'];
		thumbCount = json['thumbCount'];
		lantitude = json['lantitude'];
		longitude = json['longitude'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['visible'] = this.visible;
		data['postContent'] = this.postContent;
		data['postType'] = this.postType;
		data['postTopic'] = this.postTopic;
		data['userId'] = this.userId;
		data['commentCount'] = this.commentCount;
		data['duration'] = this.duration;
		data['shareCount'] = this.shareCount;
		data['createTime'] = this.createTime;
		data['location'] = this.location;
		data['id'] = this.id;
		data['thumbCount'] = this.thumbCount;
		data['lantitude'] = this.lantitude;
		data['longitude'] = this.longitude;
		return data;
	}
}

class UserLikeAndThumbDataUser {
	String nickname;
	String avatar;
	int id;

	UserLikeAndThumbDataUser({this.nickname, this.avatar, this.id});

	UserLikeAndThumbDataUser.fromJson(Map<String, dynamic> json) {
		nickname = json['nickname'];
		avatar = json['avatar'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['nickname'] = this.nickname;
		data['avatar'] = this.avatar;
		data['id'] = this.id;
		return data;
	}
}
