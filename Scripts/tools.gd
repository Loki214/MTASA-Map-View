extends Node

var size: Vector2
var connected: bool
var updateRate: float = 1

func pos2vec(v: Dictionary):
	var x = range_lerp(v.x,0,3000,0,size.x)
	var y = range_lerp(v.y,0,-3000,0,size.y)
	return Vector2(x,y)