extends Camera2D

const MXZ = 20
const MNZ = .3
var z = 20
var S = 5
var drag
onready var p = get_parent().get_node("UI/MenuBar")

func _ready():
	self.zoom = Vector2(z,z)
	pass

func initial():
	z = 20
	S = 5
	self.zoom = Vector2(z,z)
	self.position = Vector2()
	resizeBlips()


func _input(event):
	if !tool.connected or p.inSettings or p.inSettings:
		return
	if event is InputEventMouseButton:
		var btn = event.button_index
		if event.pressed:
			if btn == 5:
				z = min(z+S,MXZ)
				zoomToMouse(false)
			if btn == 4:
				z = max(z-S,MNZ)
				zoomToMouse(true)
		if btn == 1:
			drag = event.pressed
			
	if event is InputEventMouseMotion and drag:
		self.position -= (event.relative*z)
		
	if event is InputEventKey and event.as_text() == "R":
		self.position = Vector2()
		z = MXZ
		self.zoom = Vector2(z,z)
		resizeBlips()

var zp = .25

func zoomToMouse(down):
	if z == MXZ or z == MNZ:
		return
	var mp = self.get_local_mouse_position()
	if down:
		self.position += (mp*zp)
	else:
		self.position -= (mp*zp)
	S = max(min(range_lerp(z,MNZ,MXZ,.001,5),MXZ),MNZ)
	resizeBlips()
	self.zoom = Vector2(z,z)

func resizeBlips():
	var children = get_parent().get_node("map/PlayerBlips").get_children()
	for child in children:
		child.scale = Vector2(z,z)*.7