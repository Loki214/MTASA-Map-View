extends Sprite

const size = Vector2(4608,4611)
var IP = "217.114.197.177:22005"
var players
var playercount
var sessionToken
var canConnect = true
signal mta_connect_failed
signal mta_connect

func _ready():
	tool.size = size
#	print(Marshalls.utf8_to_base64("Nanachi:emman"))

func loginUser(u: String, p: String):
	canConnect = true
	sessionToken = Marshalls.utf8_to_base64(u+":"+p)
	connectToServer()

func logoutUser():
	canConnect = false
	tool.connected = false
	players = {}
	cleanDeadBlips()

func connectToServer():
	if !canConnect:
		return
	$HTTPRequest.request("http://" + IP + "/webtest/call/getPlayersData",["Authorization: Basic "+sessionToken])


func _on_HTTPRequest_request_completed( _result, rc, _headers, body ):
	var parse = JSON.parse(body.get_string_from_utf8())
	var json = str(parse.result)
	if json != "Null":
		if json is String:
			players = parse_json(json)[0][0]
			for plr in players:
				updateBlip(plr)
		playercount = get_node("PlayerBlips").get_child_count()
		cleanDeadBlips()
		if !tool.connected and canConnect:
			emit_signal("mta_connect")
			tool.connected = true
	else:
		tool.connected = false
		canConnect = false
		emit_signal("mta_connect_failed",rc)
	connectToServer()

func updateBlip(playerData: Dictionary):
	if !canConnect:
		return
	var blip = $PlayerBlips.has_node(playerData.FriendlyName)
	if blip:
		$PlayerBlips.get_node(playerData.FriendlyName).updateBlip(playerData)
	else:
		createBlip(playerData)
		pass

func createBlip(playerData: Dictionary):
	var blip = preload("res://Scenes/Player.tscn").instance()
	blip.set_name(playerData.FriendlyName)
	get_node("PlayerBlips").add_child(blip)
	var pos = tool.pos2vec(playerData.Position)
	blip.position = pos
	blip.updateBlip(playerData)

func cleanDeadBlips():
	var children = get_node("PlayerBlips").get_children()
	for child in children:
		var present
		for plr in players:
			if child.name == plr.FriendlyName:
				present = true
		if !present:
			child.free()
	pass
