class BaseResponseEntity {
	String msg;
	int code;
	List<Null> data;

	BaseResponseEntity({this.msg, this.code, this.data});

	BaseResponseEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<Null>();
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		data['code'] = this.code;
		if (this.data != null) {
      data['data'] =  [];
    }
		return data;
	}
}
