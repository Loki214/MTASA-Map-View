extends Sprite

var players
var playercount

func getPlayers():
	$HTTPRequest.request("http://217.114.197.177:22005/webtest/call/getPlayersData")

func _on_HTTPRequest_request_completed( _result, _response_code, _headers, body ):
	var json = JSON.parse(body.get_string_from_utf8())
	json = str(json.result)
	if json is String:
		players = parse_json(json)[0][0]
		playercount = 0
		for plr in players:
			playercount += 1
			updateBlip(plr)
	getPlayers()

func _on_HTTPRequest_ready():
	getPlayers()
	pass

func updateBlip(playerData: Dictionary):
	var blip = $PlayerBlips.get_node(playerData.Name)
	if blip:
		var pos = pos2vec(playerData.Position,768)
		var forward = pos2vec(playerData.Forward,768)
		blip.moveTo(pos,forward)
	else:
		createBlip(playerData)
		pass

func createBlip(playerData: Dictionary):
	var blip = preload("res://Player.tscn").instance()
	blip.set_name(playerData.Name)
	blip.get_node("Label").text = playerData.Name
	get_node("PlayerBlips").add_child(blip)
	var pos = pos2vec(playerData.Position,768)
	var forward = pos2vec(playerData.Forward,768)
	blip.position = pos
	blip.moveTo(pos,forward)

func pos2vec(v: Dictionary, size: float):
	var x = range_lerp(v.x,0,3000,0,size)
	var y = range_lerp(v.y,0,-3000,0,size)
	return Vector2(x,y)