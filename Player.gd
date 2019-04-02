extends Node

var pos = self.position
var rot

func moveTo(newPos: Vector2, newRot, v):
	pos = newPos
	rot = newRot
	if v == "None":
		$vehicle.hide()
		$plr.show()
	else:
		$vehicle.show()
		$plr.hide()

func _process(delta):
	var dir = pos - self.position
	var dist = dir.length()
	var mul = range_lerp(dist,0,200,.1,1)
	self.position += dir*.01
	$vehicle.rotation = rot.angle()
