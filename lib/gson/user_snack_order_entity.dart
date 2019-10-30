class UserSnackOrderEntity {
	String msg;
	int code;
	List<UserSnackOrderData> data;

	UserSnackOrderEntity({this.msg, this.code, this.data});

	UserSnackOrderEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<UserSnackOrderData>();(json['data'] as List).forEach((v) { data.add(new UserSnackOrderData.fromJson(v)); });
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

class UserSnackOrderData {
	String postFree;
	String totalMoney;
	String orderNum;
	List<UserSnackOrderDataGood> goods;
	int id;
	int totalCount;
	String createAt;
	String status;
	int addressId;
	String orderTrade;

	UserSnackOrderData({this.postFree, this.totalMoney, this.orderNum, this.goods, this.id, this.totalCount, this.createAt, this.status, this.addressId, this.orderTrade});

	UserSnackOrderData.fromJson(Map<String, dynamic> json) {
		postFree = json['postFree'];
		totalMoney = json['totalMoney'];
		orderNum = json['orderNum'];
		if (json['goods'] != null) {
			goods = new List<UserSnackOrderDataGood>();(json['goods'] as List).forEach((v) { goods.add(new UserSnackOrderDataGood.fromJson(v)); });
		}
		id = json['id'];
		totalCount = json['totalCount'];
		createAt = json['createAt'];
		status = json['status'];
		addressId = json['addressId'];
		orderTrade = json['orderTrade'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['postFree'] = this.postFree;
		data['totalMoney'] = this.totalMoney;
		data['orderNum'] = this.orderNum;
		if (this.goods != null) {
      data['goods'] =  this.goods.map((v) => v.toJson()).toList();
    }
		data['id'] = this.id;
		data['totalCount'] = this.totalCount;
		data['createAt'] = this.createAt;
		data['status'] = this.status;
		data['addressId'] = this.addressId;
		data['orderTrade'] = this.orderTrade;
		return data;
	}
}

class UserSnackOrderDataGood {
	String foodPicture;
	String startCount;
	int tastyId;
	double totalPrice;
	String tastyCount;
	String originPrice;
	String foodsSize;
	String foodsPrice;
	dynamic createAt;
	String isShow;
	int activityId;
	String foodName;
	String ownerSelf;
	String tastyName;
	String tastyPrice;
	int id;
	int kindId;

	UserSnackOrderDataGood({this.foodPicture, this.startCount, this.tastyId, this.totalPrice, this.tastyCount, this.originPrice, this.foodsSize, this.foodsPrice, this.createAt, this.isShow, this.activityId, this.foodName, this.ownerSelf, this.tastyName, this.tastyPrice, this.id, this.kindId});

	UserSnackOrderDataGood.fromJson(Map<String, dynamic> json) {
		foodPicture = json['foodPicture'];
		startCount = json['startCount'];
		tastyId = json['tastyId'];
		totalPrice = json['totalPrice'];
		tastyCount = json['tastyCount'];
		originPrice = json['originPrice'];
		foodsSize = json['foodsSize'];
		foodsPrice = json['foodsPrice'];
		createAt = json['createAt'];
		isShow = json['isShow'];
		activityId = json['activityId'];
		foodName = json['foodName'];
		ownerSelf = json['ownerSelf'];
		tastyName = json['tastyName'];
		tastyPrice = json['tastyPrice'];
		id = json['id'];
		kindId = json['kindId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['foodPicture'] = this.foodPicture;
		data['startCount'] = this.startCount;
		data['tastyId'] = this.tastyId;
		data['totalPrice'] = this.totalPrice;
		data['tastyCount'] = this.tastyCount;
		data['originPrice'] = this.originPrice;
		data['foodsSize'] = this.foodsSize;
		data['foodsPrice'] = this.foodsPrice;
		data['createAt'] = this.createAt;
		data['isShow'] = this.isShow;
		data['activityId'] = this.activityId;
		data['foodName'] = this.foodName;
		data['ownerSelf'] = this.ownerSelf;
		data['tastyName'] = this.tastyName;
		data['tastyPrice'] = this.tastyPrice;
		data['id'] = this.id;
		data['kindId'] = this.kindId;
		return data;
	}
}
