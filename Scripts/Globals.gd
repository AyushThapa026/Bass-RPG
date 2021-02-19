extends Node

var global_variables = {material_wealth=0}


func delay(time):
	var timer = Timer.new()
	timer.one_shot = true
	timer.set_wait_time(time)
	return timer
	
