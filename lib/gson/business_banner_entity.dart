class BusinessBannerEntity {
	String msg;
	int code;
	List<BusinessBannerData> data;

	BusinessBannerEntity({this.msg, this.code, this.data});

	BusinessBannerEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<BusinessBannerData>();(json['data'] as List).forEach((v) { data.add(new BusinessBannerData.fromJson(v)); });
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

class BusinessBannerData {
	String bannerShop;
	String bannerUrl;
	String bannerPicture;
	int id;
	String createAt;

	BusinessBannerData({this.bannerShop, this.bannerUrl, this.bannerPicture, this.id, this.createAt});

	BusinessBannerData.fromJson(Map<String, dynamic> json) {
		bannerShop = json['bannerShop'];
		bannerUrl = json['bannerUrl'];
		bannerPicture = json['bannerPicture'];
		id = json['id'];
		createAt = json['createAt'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['bannerShop'] = this.bannerShop;
		data['bannerUrl'] = this.bannerUrl;
		data['bannerPicture'] = this.bannerPicture;
		data['id'] = this.id;
		data['createAt'] = this.createAt;
		return data;
	}
}
