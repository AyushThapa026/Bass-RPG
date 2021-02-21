extends Node

var global_variables = {
	material_wealth = 0, 
	player = null,
	knows_bass = false,
}

var loaded = false

func delay(time):
	var timer = Timer.new()
	timer.one_shot = true
	timer.set_wait_time(time)
	return timer

