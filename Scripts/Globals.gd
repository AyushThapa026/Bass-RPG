extends Node

func delay(time):
	var timer = Timer.new()
	timer.one_shot = true
	timer.set_wait_time(time)
	return timer
	
