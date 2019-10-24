class UserPostItemEntity {
	String msg;
	int code;
	List<UserPostItemData> data;

	UserPostItemEntity({this.msg, this.code, this.data});

	UserPostItemEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<UserPostItemData>();(json['data'] as List).forEach((v) { data.add(new UserPostItemData.fromJson(v)); });
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

class UserPostItemData {
	int visible;
	String postContent;
	String topicName;
	String topicPicUrl;
	int topicId;
	int postType;
	int like;
	dynamic postTopic;
	int userId;
	List<UserPostItemDataPicture> pictures;
	String commentCount;
	dynamic duration;
	String shareCount;
	String createTime;
	String location;
	int id;
	String thumbCount;
	UserPostItemDataUser user;
	dynamic lantitude;
	dynamic longitude;

	UserPostItemData({this.topicName, this.visible, this.topicPicUrl, this.topicId, this.postContent, this.postType, this.like, this.postTopic, this.userId, this.pictures, this.commentCount, this.duration, this.shareCount, this.createTime, this.location, this.id, this.thumbCount, this.user, this.lantitude, this.longitude});

	UserPostItemData.fromJson(Map<String, dynamic> json) {
		visible = json['visible'];
		topicId = json['topicId'];
		topicPicUrl = json['topicPicUrl'];
		postContent = json['postContent'];
		topicName = json['topicName'];
		postType = json['postType'];
		like = json['like'];
		postTopic = json['postTopic'];
		userId = json['userId'];
		if (json['pictures'] != null) {
			pictures = new List<UserPostItemDataPicture>();(json['pictures'] as List).forEach((v) { pictures.add(new UserPostItemDataPicture.fromJson(v)); });
		}
		commentCount = json['commentCount'];
		duration = json['duration'];
		shareCount = json['shareCount'];
		createTime = json['createTime'];
		location = json['location'];
		id = json['id'];
		thumbCount = json['thumbCount'];
		user = json['user'] != null ? new UserPostItemDataUser.fromJson(json['user']) : null;
		lantitude = json['lantitude'];
		longitude = json['longitude'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['visible'] = this.visible;
		data['postContent'] = this.postContent;
		data['topicPicUrl'] = this.topicPicUrl;
		data['topicId'] = this.topicId;
		data['postType'] = this.postType;
		data['like'] = this.like;
		data['postTopic'] = this.postTopic;
		data['topicName'] = this.topicName;
		data['userId'] = this.userId;
		if (this.pictures != null) {
      data['pictures'] =  this.pictures.map((v) => v.toJson()).toList();
    }
		data['commentCount'] = this.commentCount;
		data['duration'] = this.duration;
		data['shareCount'] = this.shareCount;
		data['createTime'] = this.createTime;
		data['location'] = this.location;
		data['id'] = this.id;
		data['thumbCount'] = this.thumbCount;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
		data['lantitude'] = this.lantitude;
		data['longitude'] = this.longitude;
		return data;
	}
}

class UserPostItemDataPicture {
	dynamic duration;
	String createTime;
	dynamic weight;
	int id;
	int postId;
	String postPictureUrl;
	dynamic height;

	UserPostItemDataPicture({this.duration, this.createTime, this.weight, this.id, this.postId, this.postPictureUrl, this.height});

	UserPostItemDataPicture.fromJson(Map<String, dynamic> json) {
		duration = json['duration'];
		createTime = json['createTime'];
		weight = json['weight'];
		id = json['id'];
		postId = json['postId'];
		postPictureUrl = json['postPictureUrl'];
		height = json['height'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['duration'] = this.duration;
		data['createTime'] = this.createTime;
		data['weight'] = this.weight;
		data['id'] = this.id;
		data['postId'] = this.postId;
		data['postPictureUrl'] = this.postPictureUrl;
		data['height'] = this.height;
		return data;
	}
}

class UserPostItemDataUser {
	String sex;
	String nickname;
	String isOnline;
	String avatar;
	int id;
	String username;

	UserPostItemDataUser({this.sex, this.nickname, this.isOnline, this.avatar, this.id, this.username});

	UserPostItemDataUser.fromJson(Map<String, dynamic> json) {
		sex = json['sex'];
		nickname = json['nickname'];
		isOnline = json['isOnline'];
		avatar = json['avatar'];
		id = json['id'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['sex'] = this.sex;
		data['nickname'] = this.nickname;
		data['isOnline'] = this.isOnline;
		data['avatar'] = this.avatar;
		data['id'] = this.id;
		data['username'] = this.username;
		return data;
	}
}
