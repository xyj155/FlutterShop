class UserViewDetailEntity {
	String msg;
	int code;
	UserViewDetailData data;

	UserViewDetailEntity({this.msg, this.code, this.data});

	UserViewDetailEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		data = json['data'] != null ? new UserViewDetailData.fromJson(json['data']) : null;
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

class UserViewDetailData {
	String city;
	String signature;
	String createTime;
	UserViewDetailDataPostlist postList;
	String sex;
	String birth;
	String isOnline;
	String currentCity;
	String avatar;
	String observe;
	String fans;
	List<String> pictureWal;
	String major;
	String school;
	int isObserve;
	String nickname;
	int postCount;
	int age;
	String username;

	UserViewDetailData({this.createTime, this.city, this.signature, this.postList, this.sex, this.birth, this.isOnline, this.currentCity, this.avatar, this.observe, this.fans, this.pictureWal, this.major, this.school, this.isObserve, this.nickname, this.postCount, this.age, this.username});

	UserViewDetailData.fromJson(Map<String, dynamic> json) {
		city = json['city'];
		createTime = json['createTime'];
		signature = json['signature'];
		postList = json['postList'] != null ? new UserViewDetailDataPostlist.fromJson(json['postList']) : null;
		sex = json['sex'];
		birth = json['birth'];
		isOnline = json['isOnline'];
		currentCity = json['currentCity'];
		avatar = json['avatar'];
		observe = json['observe'];
		fans = json['fans'];
		pictureWal = json['pictureWal']?.cast<String>();
		major = json['major'];
		school = json['school'];
		isObserve = json['isObserve'];
		nickname = json['nickname'];
		postCount = json['postCount'];
		age = json['age'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['city'] = this.city;
		data['signature'] = this.signature;
		if (this.postList != null) {
      data['postList'] = this.postList.toJson();
    }
		data['sex'] = this.sex;
		data['createTime'] = this.createTime;
		data['birth'] = this.birth;
		data['isOnline'] = this.isOnline;
		data['currentCity'] = this.currentCity;
		data['avatar'] = this.avatar;
		data['observe'] = this.observe;
		data['fans'] = this.fans;
		data['pictureWal'] = this.pictureWal;
		data['major'] = this.major;
		data['school'] = this.school;
		data['isObserve'] = this.isObserve;
		data['nickname'] = this.nickname;
		data['postCount'] = this.postCount;
		data['age'] = this.age;
		data['username'] = this.username;
		return data;
	}
}

class UserViewDetailDataPostlist {
	String postContent;
	String picture;
	int postType;
	dynamic postTopic;
	int userId;
	dynamic topicType;
	String commentCount;
	dynamic duration;
	String shareCount;
	String createTime;
	dynamic location;
	int id;
	String thumbCount;
	dynamic lantitude;
	dynamic longitude;

	UserViewDetailDataPostlist({this.picture,this.postContent, this.postType, this.postTopic, this.userId, this.topicType, this.commentCount, this.duration, this.shareCount, this.createTime, this.location, this.id, this.thumbCount, this.lantitude, this.longitude});

	UserViewDetailDataPostlist.fromJson(Map<String, dynamic> json) {
		postContent = json['postContent'];
		picture = json['picture'];
		postType = json['postType'];
		postTopic = json['postTopic'];
		userId = json['userId'];
		topicType = json['topicType'];
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
		data['postContent'] = this.postContent;
		data['picture'] = this.picture;
		data['postType'] = this.postType;
		data['postTopic'] = this.postTopic;
		data['userId'] = this.userId;
		data['topicType'] = this.topicType;
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
