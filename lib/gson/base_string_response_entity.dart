class BaseStringResponseEntity {
	String msg;
	int code;
	String data;

	BaseStringResponseEntity({this.msg, this.code, this.data});

	BaseStringResponseEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		data = json['data'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		data['data'] = this.data;
		data['code'] = this.code;

		return data;
	}
}
