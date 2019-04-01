extends HTTPRequest

var data = {
	auth = {
		user = "loki",
		password = "password"
	}
}

func _ready():
	_make_post_request("http://83.85.30.22:22005/webtest/data.json",data,false)

func _make_post_request(url, data_to_send, use_ssl):
    # Convert data to json string:
    var query = JSON.print(data_to_send)
    # Add 'Content-Type' header:
    var headers = ["Content-Type: application/json"]
    $HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
#    var json = JSON.parse(body.get_string_from_utf8())
    print(result)