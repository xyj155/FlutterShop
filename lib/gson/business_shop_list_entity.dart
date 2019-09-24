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
	String purseTag;
	String remark;
	String shopDetail;
	String businessDesc;
	String chargeMan;
	String chargeTel;
	int shopId;
	String businessAddress;
	String businessTel;
	String isPurse;
	String businessPicture;
	String longitude;
	String createDate;

	BusinessShopListData({this.purseTag,this.businessDesc,this.latitude, this.businessName, this.createDay, this.remark, this.shopDetail, this.chargeMan, this.chargeTel, this.shopId, this.businessAddress, this.businessTel, this.isPurse, this.businessPicture, this.longitude, this.createDate});

	BusinessShopListData.fromJson(Map<String, dynamic> json) {
		latitude = json['latitude'];
		purseTag = json['purseTag'];
		businessDesc = json['businessDesc'];
		businessName = json['businessName'];
		createDay = json['createDay'];
		remark = json['remark'];
		shopDetail = json['shopDetail'];
		chargeMan = json['chargeMan'];
		chargeTel = json['chargeTel'];
		shopId = json['shopId'];
		businessAddress = json['businessAddress'];
		businessTel = json['businessTel'];
		isPurse = json['isPurse'];
		businessPicture = json['businessPicture'];
		longitude = json['longitude'];
		createDate = json['createDate'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['latitude'] = this.latitude;
		data['purseTag'] = this.purseTag;
		data['businessName'] = this.businessName;
		data['createDay'] = this.createDay;
		data['remark'] = this.remark;
		data['businessDesc'] = this.businessDesc;
		data['shopDetail'] = this.shopDetail;
		data['chargeMan'] = this.chargeMan;
		data['chargeTel'] = this.chargeTel;
		data['shopId'] = this.shopId;
		data['businessAddress'] = this.businessAddress;
		data['businessTel'] = this.businessTel;
		data['isPurse'] = this.isPurse;
		data['businessPicture'] = this.businessPicture;
		data['longitude'] = this.longitude;
		data['createDate'] = this.createDate;
		return data;
	}
}
