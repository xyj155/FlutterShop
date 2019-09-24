class PartTimeJobListEntity {
	String msg;
	int code;
	List<PartTimeJobListData> data;

	PartTimeJobListEntity({this.msg, this.code, this.data});

	PartTimeJobListEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<PartTimeJobListData>();(json['data'] as List).forEach((v) { data.add(new PartTimeJobListData.fromJson(v)); });
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

class PartTimeJobListData {
	String jobName;
	String jobPay;
	String jobNeedPeople;
	String endAt;
	String signUpCount;
	String createAt;
	String jobProvider;
	String jobKind;
	String jobDays;
	String workCity;
	String jobDescription;
	String location;
	int id;
	String isPass;
	String startAt;
	String payUnit;
	String jobShop;
	String jobAddress;

	PartTimeJobListData({this.jobShop,this.jobAddress,this.jobName, this.jobPay, this.jobNeedPeople, this.endAt, this.signUpCount, this.createAt, this.jobProvider, this.jobKind, this.jobDays, this.workCity, this.jobDescription, this.location, this.id, this.isPass, this.startAt});

	PartTimeJobListData.fromJson(Map<String, dynamic> json) {
		jobShop = json['jobShop'];
		jobAddress = json['jobAddress'];
		jobName = json['jobName'];
		jobPay = json['jobPay'];
		payUnit = json['payUnit'];
		jobNeedPeople = json['jobNeedPeople'];
		endAt = json['endAt'];
		signUpCount = json['signUpCount'];
		createAt = json['createAt'];
		jobProvider = json['jobProvider'];
		jobKind = json['jobKind'];
		jobDays = json['jobDays'];
		workCity = json['workCity'];
		jobDescription = json['jobDescription'];
		location = json['location'];
		id = json['id'];
		isPass = json['isPass'];
		startAt = json['startAt'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['jobShop'] = this.jobShop;
		data['jobName'] = this.jobName;
		data['jobAddress'] = this.jobAddress;
		data['payUnit'] = this.payUnit;
		data['jobPay'] = this.jobPay;
		data['jobNeedPeople'] = this.jobNeedPeople;
		data['endAt'] = this.endAt;
		data['signUpCount'] = this.signUpCount;
		data['createAt'] = this.createAt;
		data['jobProvider'] = this.jobProvider;
		data['jobKind'] = this.jobKind;
		data['jobDays'] = this.jobDays;
		data['workCity'] = this.workCity;
		data['jobDescription'] = this.jobDescription;
		data['location'] = this.location;
		data['id'] = this.id;
		data['isPass'] = this.isPass;
		data['startAt'] = this.startAt;
		return data;
	}
}
