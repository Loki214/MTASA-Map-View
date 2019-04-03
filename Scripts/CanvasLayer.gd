extends CanvasLayer

var args = { auth= {"user": "webget", "password": "9895"}}

func _on_Button_pressed():
	var data = JSON.print(args)
	$HTTPRequest.request("http://217.114.197.177:22005/webtest/call/getPlayersData",[],false,HTTPClient.METHOD_POST,data)
#$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result, response_code)