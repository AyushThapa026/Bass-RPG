extends Node

var global_variables = {
	material_wealth = 0, 
	player = null,
	knows_bass = false,
}

var loaded = false

func tweenPos(obj, parent, startpos, endpos):
	var tween = Tween.new()
	parent.add_child(tween)
	tween.interpolate_property(obj, "position", startpos, endpos, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	return tween
