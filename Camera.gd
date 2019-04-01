extends Camera2D

const S = .1
const MXZ = 2
const MNZ = .1
var z = 2
var drag

func _ready():
	self.zoom = Vector2(z,z)

func _input(event):
	if event is InputEventMouseButton:
		var btn = event.button_index
		if event.pressed:
			if btn == 5:
				z = min(z+S,MXZ)
			if btn == 4:
				z = max(z-S,MNZ)
			self.zoom = Vector2(z,z)
			resizeBlips()
		if btn == 1:
			drag = event.pressed
			
	if event is InputEventMouseMotion and drag:
		self.offset -= (event.relative*z)
		
	if event is InputEventKey and event.as_text() == "R":
		self.offset = Vector2()
		z = 1
		self.zoom = Vector2(z,z)

func resizeBlips():
	var children = get_parent().get_node("map/PlayerBlips").get_children()
	for child in children:
		child.scale = Vector2(z,z)
	pass