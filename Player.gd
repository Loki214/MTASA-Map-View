extends Node

var pos = self.position
var rot = self.rotation

func moveTo(newPos: Vector2, newRot, v):
	pos = newPos
	rot = deg2rad(-newRot-90)
	if v == "None":
		$vehicle.hide()
		$plr.show()
	else:
		$vehicle.show()
		$plr.hide()

func _process(delta):
	var dir = pos - self.position
	self.position += dir*.01
	$vehicle.rotation = rot
