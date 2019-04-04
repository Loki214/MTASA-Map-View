extends HTTPRequest

func remove():
	$Timer.start(3)

func _on_Timer_timeout():
	print("byeee")
	free()
