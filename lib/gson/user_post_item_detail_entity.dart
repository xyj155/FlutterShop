import 'user_post_item_entity.dart';

class UserPostItemDetailEntity {
	String msg;
	int code;
	UserPostItemDetailData data;

	UserPostItemDetailEntity({this.msg, this.code, this.data});

	UserPostItemDetailEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		data = json['data'] != null ? new UserPostItemDetailData.fromJson(json['data']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		data['code'] = this.code;
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		return data;
	}
}

class UserPostItemDetailData {
	String postContent;
	int postType;
	int like;
	dynamic postTopic;
	int userId;
	List<UserPostItemDataPicture> pictures;
	String timeDuration;
	dynamic topicType;
	String commentCount;
	dynamic duration;
	String shareCount;
	String createTime;
	int isObserve;
	int id;
	String thumbCount;
	UserPostItemDetailDataUser user;

	UserPostItemDetailData({this.postContent, this.postType, this.like, this.postTopic, this.userId, this.pictures, this.timeDuration, this.topicType, this.commentCount, this.duration, this.shareCount, this.createTime, this.isObserve, this.id, this.thumbCount, this.user});

	UserPostItemDetailData.fromJson(Map<String, dynamic> json) {
		postContent = json['postContent'];
		postType = json['postType'];
		like = json['like'];
		postTopic = json['postTopic'];
		userId = json['userId'];
		if (json['pictures'] != null) {
			pictures = new List<UserPostItemDataPicture>();(json['pictures'] as List).forEach((v) { pictures.add(new UserPostItemDataPicture.fromJson(v)); });
		}
		timeDuration = json['timeDuration'];
		topicType = json['topicType'];
		commentCount = json['commentCount'];
		duration = json['duration'];
		shareCount = json['shareCount'];
		createTime = json['createTime'];
		isObserve = json['isObserve'];
		id = json['id'];
		thumbCount = json['thumbCount'];
		user = json['user'] != null ? new UserPostItemDetailDataUser.fromJson(json['user']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['postContent'] = this.postContent;
		data['postType'] = this.postType;
		data['like'] = this.like;
		data['postTopic'] = this.postTopic;
		data['userId'] = this.userId;
		if (this.pictures != null) {
			data['pictures'] =  this.pictures.map((v) => v.toJson()).toList();
		}
		data['timeDuration'] = this.timeDuration;
		data['topicType'] = this.topicType;
		data['commentCount'] = this.commentCount;
		data['duration'] = this.duration;
		data['shareCount'] = this.shareCount;
		data['createTime'] = this.createTime;
		data['isObserve'] = this.isObserve;
		data['id'] = this.id;
		data['thumbCount'] = this.thumbCount;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
		return data;
	}
}

class UserPostItemDetailDataUser {
	String sex;
	String nickname;
	String isOnline;
	String avatar;
	int id;

	UserPostItemDetailDataUser({this.sex, this.nickname, this.isOnline, this.avatar, this.id});

	UserPostItemDetailDataUser.fromJson(Map<String, dynamic> json) {
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
