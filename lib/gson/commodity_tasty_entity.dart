class CommodityTastyEntity {
	String msg;
	int code;
	List<CommodityTastyData> data;

	CommodityTastyEntity({this.msg, this.code, this.data});

	CommodityTastyEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<CommodityTastyData>();(json['data'] as List).forEach((v) { data.add(new CommodityTastyData.fromJson(v)); });
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

class CommodityTastyData {
	int foodsId;
	String tastePrice;
	String storeCount;
	String foodsTaste;
	int id;

	CommodityTastyData({this.foodsId, this.tastePrice, this.storeCount, this.foodsTaste, this.id});

	CommodityTastyData.fromJson(Map<String, dynamic> json) {
		foodsId = json['foodsId'];
		tastePrice = json['tastePrice'];
		storeCount = json['storeCount'];
		foodsTaste = json['foodsTaste'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['foodsId'] = this.foodsId;
		data['tastePrice'] = this.tastePrice;
		data['storeCount'] = this.storeCount;
		data['foodsTaste'] = this.foodsTaste;
		data['id'] = this.id;
		return data;
	}
}
