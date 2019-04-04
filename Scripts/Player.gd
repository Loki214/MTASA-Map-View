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
		$Label.rect_position.y = -60
	else:
		$vehicle.show()
		$plr.hide()
		var seat = data.Vehicle.seat
		var so = int(seat)+1
		$Label.text = str(so) + ". " + data.Name
		$Label.rect_position.y = -60 + (38 * int(seat))
	$Label.rect_size.x = 2
	$dummy.look_at(pos+rot)
	$TweenPos.interpolate_property(self, 'position', self.position, pos, tool.updateRate*2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	$TweenRot.interpolate_property($vehicle, 'rotation', $vehicle.rotation, $dummy.rotation, tool.updateRate, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$TweenPos.start()
	$TweenRot.start()

