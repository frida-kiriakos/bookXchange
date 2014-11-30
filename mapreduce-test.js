function () {
	var key =  this.nginx.http_cookie.remember_token;
	var value = {ip_address: this.nginx.user_ip, count:1 };
	emit(key,value); 
};

function(key, values) {
	reducedVal = {value: "", total_count: 0};
	for (var i = 0; i < values.length; i++) {
		reducedVal.value = values[i].ip_address.value;
		reducedVal.total_count += values[i].ip_address.count;
	}
	return reducedVal;
};

function(key, values) {
	var reducedVal = {count: 0};
	values.forEach( function(value) {	
		reducedVal.count += value.count;
	});
	return reducedVal;
};