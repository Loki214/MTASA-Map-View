extends Sprite

const size = Vector2(4608,4611)
var players
var playercount

func getPlayers():
	$HTTPRequest.request("http://217.114.197.177:22005/webtest/call/getPlayersData")

func _on_HTTPRequest_request_completed( _result, _response_code, _headers, body ):
	var json = JSON.parse(body.get_string_from_utf8())
	json = str(json.result)
	if json is String:
		players = parse_json(json)[0][0]
		for plr in players:
			updateBlip(plr)
	getPlayers()
	get_parent().get_node("Cam").init()
	playercount = get_node("PlayerBlips").get_child_count()
	cleanDeadBlips()

func _on_HTTPRequest_ready():
	getPlayers()
	pass

func updateBlip(playerData: Dictionary):
	var blip = $PlayerBlips.get_node(playerData.Name)
	if blip:
		var pos = pos2vec(playerData.Position)
		var forward = pos2vec(playerData.Forward)
		blip.moveTo(pos,forward,playerData.Vehicle)
	else:
		createBlip(playerData)
		pass

func createBlip(playerData: Dictionary):
	var blip = preload("res://Player.tscn").instance()
	blip.set_name(playerData.Name)
	blip.get_node("Label").text = playerData.Name
	get_node("PlayerBlips").add_child(blip)
	var pos = pos2vec(playerData.Position)
	var forward = pos2vec(playerData.Forward)
	blip.position = pos
	blip.moveTo(pos,forward,playerData.Vehicle)

func cleanDeadBlips():
	var children = get_node("PlayerBlips").get_children()
	for child in children:
		var present
		for plr in players:
			if child.name == plr.Name:
				present = true
		if !present:
			child.free()
	pass

func pos2vec(v: Dictionary):
	var x = range_lerp(v.x,0,3000,0,size.x)
	var y = range_lerp(v.y,0,-3000,0,size.y)
	return Vector2(x,y)