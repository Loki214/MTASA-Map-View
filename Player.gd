extends Node

var pos = self.position
var rot

func updateBlip(data: Dictionary):
	pos = tool.pos2vec(data.Position)
	rot = tool.pos2vec(data.Forward)
	if data.Vehicle.name == "None":
		$vehicle.hide()
		$plr.show()
		$Label.text = data.Name
		$Label.rect_position.y = 0
	else:
		$vehicle.show()
		$plr.hide()
		var seat = data.Vehicle.seat
		var so = int(seat)+1
		$Label.text = str(so) + ". " + data.Name
		$Label.rect_position.y = 38 * int(seat)
	$Label.rect_size.x = 2

func _process(_delta):
	var dir = pos - self.position
	var dist = dir.length()
	if dist > 300:
		self.position = pos
	else:
		self.position += dir*.01
	$vehicle.rotation = rot.angle()

