class UserShopCarEntity {
	String msg;
	int code;
	UserShopCarData data;

	UserShopCarEntity({this.msg, this.code, this.data});

	UserShopCarEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		data = json['data'] != null ? new UserShopCarData.fromJson(json['data']) : null;
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

class UserShopCarData {
	String price;
	int shopCarCount;
	List<UserShopCarDataGood> goods;

	UserShopCarData({this.price, this.shopCarCount, this.goods});

	UserShopCarData.fromJson(Map<String, dynamic> json) {
		price = json['price'];
		shopCarCount = json['shopCarCount'];
		if (json['goods'] != null) {
			goods = new List<UserShopCarDataGood>();(json['goods'] as List).forEach((v) { goods.add(new UserShopCarDataGood.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['price'] = this.price;
		data['shopCarCount'] = this.shopCarCount;
		if (this.goods != null) {
      data['goods'] =  this.goods.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class UserShopCarDataGood {
	String foodPicture;
	int activityId;
	String foodName;
	String startCount;
	String ownerSelf;
	int id;
	String originPrice;
	UserShopCarDataGoodsTasty tasty;
	String foodsSize;
	String foodsPrice;
	int kindId;
	String isShow;

	UserShopCarDataGood({this.foodPicture, this.activityId, this.foodName, this.startCount, this.ownerSelf, this.id, this.originPrice, this.tasty, this.foodsSize, this.foodsPrice, this.kindId, this.isShow});

	UserShopCarDataGood.fromJson(Map<String, dynamic> json) {
		foodPicture = json['foodPicture'];
		activityId = json['activityId'];
		foodName = json['foodName'];
		startCount = json['startCount'];
		ownerSelf = json['ownerSelf'];
		id = json['id'];
		originPrice = json['originPrice'];
		tasty = json['tasty'] != null ? new UserShopCarDataGoodsTasty.fromJson(json['tasty']) : null;
		foodsSize = json['foodsSize'];
		foodsPrice = json['foodsPrice'];
		kindId = json['kindId'];
		isShow = json['isShow'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['foodPicture'] = this.foodPicture;
		data['activityId'] = this.activityId;
		data['foodName'] = this.foodName;
		data['startCount'] = this.startCount;
		data['ownerSelf'] = this.ownerSelf;
		data['id'] = this.id;
		data['originPrice'] = this.originPrice;
		if (this.tasty != null) {
      data['tasty'] = this.tasty.toJson();
    }
		data['foodsSize'] = this.foodsSize;
		data['foodsPrice'] = this.foodsPrice;
		data['kindId'] = this.kindId;
		data['isShow'] = this.isShow;
		return data;
	}
}

class UserShopCarDataGoodsTasty {
	int foodsId;
	String tastePrice;
	String storeCount;
	String count;
	String foodsTaste;
	int id;

	UserShopCarDataGoodsTasty({this.foodsId, this.tastePrice, this.storeCount, this.count, this.foodsTaste, this.id});

	UserShopCarDataGoodsTasty.fromJson(Map<String, dynamic> json) {
		foodsId = json['foodsId'];
		tastePrice = json['tastePrice'];
		storeCount = json['storeCount'];
		count = json['count'];
		foodsTaste = json['foodsTaste'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['foodsId'] = this.foodsId;
		data['tastePrice'] = this.tastePrice;
		data['storeCount'] = this.storeCount;
		data['count'] = this.count;
		data['foodsTaste'] = this.foodsTaste;
		data['id'] = this.id;
		return data;
	}
}
