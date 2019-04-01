extends Node

var pos = self.position
var rot = self.rotation

func moveTo(newPos: Vector2, newRot: Vector2):
	pos = newPos
	rot = newRot

func _process(delta):
	var dir = pos - self.position
	self.position += dir*.01
	$icon.rotation = pos.angle_to(rot)
