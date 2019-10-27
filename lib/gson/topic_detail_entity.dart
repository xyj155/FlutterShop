class TopicDetailEntity {
	String msg;
	int code;
	TopicDetailData data;

	TopicDetailEntity({this.msg, this.code, this.data});

	TopicDetailEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		data = json['data'] != null ? new TopicDetailData.fromJson(json['data']) : null;
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

class TopicDetailData {
	List<TopicDetailDataUserlist> userList;
	int joinCount;
	bool isObserve;
	TopicDetailDataTopic topic;

	TopicDetailData({this.userList, this.joinCount, this.isObserve, this.topic});

	TopicDetailData.fromJson(Map<String, dynamic> json) {
		if (json['userList'] != null) {
			userList = new List<TopicDetailDataUserlist>();(json['userList'] as List).forEach((v) { userList.add(new TopicDetailDataUserlist.fromJson(v)); });
		}
		joinCount = json['joinCount'];
		isObserve = json['isObserve'];
		topic = json['topic'] != null ? new TopicDetailDataTopic.fromJson(json['topic']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.userList != null) {
      data['userList'] =  this.userList.map((v) => v.toJson()).toList();
    }
		data['joinCount'] = this.joinCount;
		data['isObserve'] = this.isObserve;
		if (this.topic != null) {
      data['topic'] = this.topic.toJson();
    }
		return data;
	}
}

class TopicDetailDataUserlist {
	String topicId;
	int id;
	String avatar;
	String userId;
	String createAt;

	TopicDetailDataUserlist({this.topicId, this.id, this.avatar, this.userId, this.createAt});

	TopicDetailDataUserlist.fromJson(Map<String, dynamic> json) {
		topicId = json['topicId'];
		id = json['id'];
		avatar = json['avatar'];
		userId = json['userId'];
		createAt = json['createAt'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['topicId'] = this.topicId;
		data['id'] = this.id;
		data['avatar'] = this.avatar;
		data['userId'] = this.userId;
		data['createAt'] = this.createAt;
		return data;
	}
}

class TopicDetailDataTopic {
	String topicPicUrl;
	String topicName;
	String postCount;
	String topicDesc;
	int id;
	int topicPid;
	int userId;

	TopicDetailDataTopic({this.topicDesc, this.topicPicUrl, this.topicName, this.postCount, this.id, this.topicPid, this.userId});

	TopicDetailDataTopic.fromJson(Map<String, dynamic> json) {
		topicDesc = json['topicDesc'];
		topicPicUrl = json['topicPicUrl'];
		topicName = json['topicName'];
		postCount = json['postCount'];
		id = json['id'];
		topicPid = json['topicPid'];
		userId = json['userId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['topicPicUrl'] = this.topicPicUrl;
		data['topicDesc'] = this.topicDesc;
		data['topicName'] = this.topicName;
		data['postCount'] = this.postCount;
		data['id'] = this.id;
		data['topicPid'] = this.topicPid;
		data['userId'] = this.userId;
		return data;
	}
}
