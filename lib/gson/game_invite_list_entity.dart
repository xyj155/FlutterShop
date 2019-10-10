class GameInviteListEntity {
	String msg;
	int code;
	List<GameInviteListData> data;

	GameInviteListEntity({this.msg, this.code, this.data});

	GameInviteListEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<GameInviteListData>();(json['data'] as List).forEach((v) { data.add(new GameInviteListData.fromJson(v)); });
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

class GameInviteListData {
	String gameType;
	String creatAt;
	String gameName;
	String remark;
	int id;
	int userId;
	GameInviteListDataUser user;

	GameInviteListData({this.gameType, this.creatAt, this.gameName, this.remark, this.id, this.userId, this.user});

	GameInviteListData.fromJson(Map<String, dynamic> json) {
		gameType = json['gameType'];
		creatAt = json['creatAt'];
		gameName = json['gameName'];
		remark = json['remark'];
		id = json['id'];
		userId = json['userId'];
		user = json['user'] != null ? new GameInviteListDataUser.fromJson(json['user']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['gameType'] = this.gameType;
		data['creatAt'] = this.creatAt;
		data['gameName'] = this.gameName;
		data['remark'] = this.remark;
		data['id'] = this.id;
		data['userId'] = this.userId;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
		return data;
	}
}

class GameInviteListDataUser {
	String nickname;
	String avatar;
	String sex;
	String username;
	String city;
	String isOnline;
	String school;

	GameInviteListDataUser({this.isOnline,this.city,this.school,this.nickname, this.avatar, this.username});

	GameInviteListDataUser.fromJson(Map<String, dynamic> json) {
		sex = json['sex'];
		nickname = json['nickname'];
		isOnline = json['isOnline'];
		city = json['city'];
		school = json['school'];
		avatar = json['avatar'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['nickname'] = this.nickname;
		data['avatar'] = this.avatar;
		data['isOnline'] = this.isOnline;
		data['sex'] = this.sex;
		data['school'] = this.school;
		data['city'] = this.city;
		data['username'] = this.username;
		return data;
	}
}
