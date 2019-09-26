class SinglePartTimeJobDetailEntity {
	String msg;
	int code;
	List<SinglePartTimeJobDetailData> data;

	SinglePartTimeJobDetailEntity({this.msg, this.code, this.data});

	SinglePartTimeJobDetailEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<SinglePartTimeJobDetailData>();(json['data'] as List).forEach((v) { data.add(new SinglePartTimeJobDetailData.fromJson(v)); });
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

class SinglePartTimeJobDetailData {
	String jobName;
	String jobPay;
	String wx;
	String avatar;
	String jobNeedPeople;
	String endAt;
	String signUpCount;
	String createAt;
	String jobAddress;
	String telPhone;
	String jobProvider;
	String province;
	String jobKind;
	int providerId;
	List<SinglePartTimeJobDetailDataPursejob> purseJob;
	String jobDays;
	String workCity;
	String jobShop;
	String jobDescription;
	int id;
	String isPass;
	String payUnit;
	String startAt;
	String providerName;
	String isVerify;
	String provideCount;

	SinglePartTimeJobDetailData({this.isVerify,this.provideCount,this.avatar,this.jobName, this.jobPay, this.wx, this.jobNeedPeople, this.endAt, this.signUpCount, this.createAt, this.jobAddress, this.telPhone, this.jobProvider, this.province, this.jobKind, this.providerId, this.purseJob, this.jobDays, this.workCity, this.jobShop, this.jobDescription, this.id, this.isPass, this.payUnit, this.startAt, this.providerName});

	SinglePartTimeJobDetailData.fromJson(Map<String, dynamic> json) {
		avatar = json['avatar'];
		isVerify = json['isVerify'];
		provideCount = json['provideCount'];
		jobName = json['jobName'];
		jobPay = json['jobPay'];
		wx = json['wx'];
		jobNeedPeople = json['jobNeedPeople'];
		endAt = json['endAt'];
		signUpCount = json['signUpCount'];
		createAt = json['createAt'];
		jobAddress = json['jobAddress'];
		telPhone = json['telPhone'];
		jobProvider = json['jobProvider'];
		province = json['province'];
		jobKind = json['jobKind'];
		providerId = json['providerId'];
		if (json['purseJob'] != null) {
			purseJob = new List<SinglePartTimeJobDetailDataPursejob>();(json['purseJob'] as List).forEach((v) { purseJob.add(new SinglePartTimeJobDetailDataPursejob.fromJson(v)); });
		}
		jobDays = json['jobDays'];
		workCity = json['workCity'];
		jobShop = json['jobShop'];
		jobDescription = json['jobDescription'];
		id = json['id'];
		isPass = json['isPass'];
		payUnit = json['payUnit'];
		startAt = json['startAt'];
		providerName = json['providerName'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['jobName'] = this.jobName;
		data['avatar'] = this.avatar;
		data['jobPay'] = this.jobPay;
		data['isVerify'] = this.isVerify;
		data['provideCount'] = this.provideCount;
		data['wx'] = this.wx;
		data['jobNeedPeople'] = this.jobNeedPeople;
		data['endAt'] = this.endAt;
		data['signUpCount'] = this.signUpCount;
		data['createAt'] = this.createAt;
		data['jobAddress'] = this.jobAddress;
		data['telPhone'] = this.telPhone;
		data['jobProvider'] = this.jobProvider;
		data['province'] = this.province;
		data['jobKind'] = this.jobKind;
		data['providerId'] = this.providerId;
		if (this.purseJob != null) {
      data['purseJob'] =  this.purseJob.map((v) => v.toJson()).toList();
    }
		data['jobDays'] = this.jobDays;
		data['workCity'] = this.workCity;
		data['jobShop'] = this.jobShop;
		data['jobDescription'] = this.jobDescription;
		data['id'] = this.id;
		data['isPass'] = this.isPass;
		data['payUnit'] = this.payUnit;
		data['startAt'] = this.startAt;
		data['providerName'] = this.providerName;
		return data;
	}
}

class SinglePartTimeJobDetailDataPursejob {
	String jobName;
	String jobPay;
	String jobNeedPeople;
	String endAt;
	String signUpCount;
	String createAt;
	String jobAddress;
	String jobProvider;
	String jobKind;
	String jobDays;
	String workCity;
	String jobShop;
	String jobDescription;
	String location;
	int id;
	String isPass;
	String payUnit;
	String startAt;

	SinglePartTimeJobDetailDataPursejob({this.jobName, this.jobPay, this.jobNeedPeople, this.endAt, this.signUpCount, this.createAt, this.jobAddress, this.jobProvider, this.jobKind, this.jobDays, this.workCity, this.jobShop, this.jobDescription, this.location, this.id, this.isPass, this.payUnit, this.startAt});

	SinglePartTimeJobDetailDataPursejob.fromJson(Map<String, dynamic> json) {
		jobName = json['jobName'];
		jobPay = json['jobPay'];
		jobNeedPeople = json['jobNeedPeople'];
		endAt = json['endAt'];
		signUpCount = json['signUpCount'];
		createAt = json['createAt'];
		jobAddress = json['jobAddress'];
		jobProvider = json['jobProvider'];
		jobKind = json['jobKind'];
		jobDays = json['jobDays'];
		workCity = json['workCity'];
		jobShop = json['jobShop'];
		jobDescription = json['jobDescription'];
		location = json['location'];
		id = json['id'];
		isPass = json['isPass'];
		payUnit = json['payUnit'];
		startAt = json['startAt'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['jobName'] = this.jobName;
		data['jobPay'] = this.jobPay;
		data['jobNeedPeople'] = this.jobNeedPeople;
		data['endAt'] = this.endAt;
		data['signUpCount'] = this.signUpCount;
		data['createAt'] = this.createAt;
		data['jobAddress'] = this.jobAddress;
		data['jobProvider'] = this.jobProvider;
		data['jobKind'] = this.jobKind;
		data['jobDays'] = this.jobDays;
		data['workCity'] = this.workCity;
		data['jobShop'] = this.jobShop;
		data['jobDescription'] = this.jobDescription;
		data['location'] = this.location;
		data['id'] = this.id;
		data['isPass'] = this.isPass;
		data['payUnit'] = this.payUnit;
		data['startAt'] = this.startAt;
		return data;
	}
}
