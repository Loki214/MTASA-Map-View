extends Camera2D

var init
const MXZ = 20
const MNZ = .3
var z = 19
var S = 0
var drag

func _ready():
	self.zoom = Vector2(z,z)

func initial():
	if init:
		return
	resizeBlips()
	init = true

func _input(event):
	if !tool.connected:
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
	pass