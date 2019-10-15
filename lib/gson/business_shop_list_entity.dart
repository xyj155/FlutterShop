class BusinessShopListEntity {
	String msg;
	int code;
	List<BusinessShopListData> data;

	BusinessShopListEntity({this.msg, this.code, this.data});

	BusinessShopListEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<BusinessShopListData>();(json['data'] as List).forEach((v) { data.add(new BusinessShopListData.fromJson(v)); });
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

class BusinessShopListData {
	String latitude;
	String businessName;
	String createDay;
	String remark;
	String businessDesc;
	List<BusinessShopListDataSpecial> special;
	String shopDetail;
	String purseTag;
	String chargeMan;
	String shopTag;
	String averagePrice;
	String specialTagContent;
	int isBook;
	String specialTagList;
	int rankScore;
	String chargeTel;
	int shopId;
	String shopType;
	String businessAddress;
	String businessTel;
	String isPurse;
	String businessPicture;
	String purseActiveId;
	String longitude;
	String createDate;

	BusinessShopListData({this.isBook,this.averagePrice,this.rankScore,this.shopTag,this.latitude, this.businessName, this.createDay, this.remark, this.businessDesc, this.special, this.shopDetail, this.purseTag, this.chargeMan, this.specialTagContent, this.specialTagList, this.chargeTel, this.shopId, this.shopType, this.businessAddress, this.businessTel, this.isPurse, this.businessPicture, this.purseActiveId, this.longitude, this.createDate});

	BusinessShopListData.fromJson(Map<String, dynamic> json) {
		latitude = json['latitude'];
		averagePrice = json['averagePrice'];
		isBook = json['isBook'];
		rankScore = json['rankScore'];
		shopTag = json['shopTag'];
		businessName = json['businessName'];
		createDay = json['createDay'];
		remark = json['remark'];
		businessDesc = json['businessDesc'];
		if (json['special'] != null) {
			special = new List<BusinessShopListDataSpecial>();(json['special'] as List).forEach((v) { special.add(new BusinessShopListDataSpecial.fromJson(v)); });
		}
		shopDetail = json['shopDetail'];
		purseTag = json['purseTag'];
		chargeMan = json['chargeMan'];
		specialTagContent = json['specialTagContent'];
		specialTagList = json['specialTagList'];
		chargeTel = json['chargeTel'];
		shopId = json['shopId'];
		shopType = json['shopType'];
		businessAddress = json['businessAddress'];
		businessTel = json['businessTel'];
		isPurse = json['isPurse'];
		businessPicture = json['businessPicture'];
		purseActiveId = json['purseActiveId'];
		longitude = json['longitude'];
		createDate = json['createDate'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['latitude'] = this.latitude;
		data['rankScore'] = this.rankScore;
		data['isBook'] = this.isBook;
		data['businessName'] = this.businessName;
		data['createDay'] = this.createDay;
		data['averagePrice'] = this.averagePrice;
		data['remark'] = this.remark;
		data['businessDesc'] = this.businessDesc;
		if (this.special != null) {
      data['special'] =  this.special.map((v) => v.toJson()).toList();
    }
		data['shopDetail'] = this.shopDetail;
		data['purseTag'] = this.purseTag;
		data['chargeMan'] = this.chargeMan;
		data['shopTag'] = this.shopTag;
		data['specialTagContent'] = this.specialTagContent;
		data['specialTagList'] = this.specialTagList;
		data['chargeTel'] = this.chargeTel;
		data['shopId'] = this.shopId;
		data['shopType'] = this.shopType;
		data['businessAddress'] = this.businessAddress;
		data['businessTel'] = this.businessTel;
		data['isPurse'] = this.isPurse;
		data['businessPicture'] = this.businessPicture;
		data['purseActiveId'] = this.purseActiveId;
		data['longitude'] = this.longitude;
		data['createDate'] = this.createDate;
		return data;
	}
}

class BusinessShopListDataSpecial {
	String bgColor;
	int id;
	String tagName;
	String tagShortName;
	String fontColor;
	String content;

	BusinessShopListDataSpecial({this.bgColor, this.id, this.tagName, this.tagShortName, this.fontColor, this.content});

	BusinessShopListDataSpecial.fromJson(Map<String, dynamic> json) {
		bgColor = json['bgColor'];
		id = json['id'];
		tagName = json['tagName'];
		tagShortName = json['tagShortName'];
		fontColor = json['fontColor'];
		content = json['content'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['bgColor'] = this.bgColor;
		data['id'] = this.id;
		data['tagName'] = this.tagName;
		data['tagShortName'] = this.tagShortName;
		data['fontColor'] = this.fontColor;
		data['content'] = this.content;
		return data;
	}
}
