extends Sprite

onready var timer: Timer = $RequestTimer
onready var timeout: Timer = $RequestTimeout
const size = Vector2(4608,4611)
const RQ = preload("res://Scenes/HTTPRequest.tscn")
var IP = "127.0.0.1:22005"
var players
var playercount
var sessionToken
var canConnect = true
var currentRequest: HTTPRequest
signal mta_connect_failed
signal mta_connect

func _ready():
	connect("mta_connect",self,"refreshConnection")
	tool.size = size

func loginUser(u: String, p: String, ip):
	canConnect = true
	if ip == "":
		IP = "127.0.0.1:22005"
	else:
		IP = ip
	sessionToken = Marshalls.utf8_to_base64(u+":"+p)
	connectToServer()

func logoutUser():
	canConnect = false
	tool.connected = false
	players = {}
	cleanDeadBlips()

func refreshConnection():
	if !canConnect or !tool.connected:
		timer.stop()
		return
	timer.start(tool.updateRate)
	connectToServer()

func connectToServer():
	if !canConnect:
		return
	var http = RQ.instance()
	add_child(http)
	currentRequest = http
	http.connect("request_completed",self,"_on_HTTPRequest_request_completed",[http])
	http.request("http://" + IP + "/mapview/call/getPlayersData",["Authorization: Basic "+sessionToken])
	timeout.start()

func requestTimedOut():
	if currentRequest:
#		currentRequest.cancel_request()
#		currentRequest.queue_free()
		get_parent().get_node("UI/MenuBar/Status").text = "Connection timed out."
		get_parent().get_node("UI/MenuBar/Status").modulate = Color(1,0,0)
		get_parent().get_node("UI/MenuBar/Status").show()
		get_parent().get_node("UI/MenuBar/Timer").start()
		get_parent().get_node("UI/MenuBar/Button").pressed = false
		get_parent().get_node("UI/MenuBar/Button").disabled = false
	pass

func _on_HTTPRequest_request_completed( _result, rc, _headers, body, req ):
	timeout.stop()
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
			tool.connected = true
			emit_signal("mta_connect")
	else:
		tool.connected = false
		canConnect = false
		emit_signal("mta_connect_failed",rc)
	req.queue_free()

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
