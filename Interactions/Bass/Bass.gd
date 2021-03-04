extends KinematicBody2D


onready var state_machine
onready var text = get_tree().get_root().find_node('Dialogue', true, false)


var path = true
var speed = 125
var move_direction = 0
var vel = Vector2.ZERO
var test = Vector2(100, 100)



func _ready():
	Datastore.connect("loaded", self, "_player_changed")

func _player_changed():
	state_machine = Globals.global_variables.player.get_node('StateMachine')
 

func move_to(pos: Vector2):
	var position = get_position()
	 #this is x and y for where it has to go
	var x1 = Vector2(pos.x, position.y)
	var y1 = Vector2(position.x, pos.y)
	#where it is
	var x2 = position.x
	var y2 = position.y
	var distance_x = abs(pos.x-position.x)
	var distance_y = abs(pos.y-position.y)
	var movement_speed = 50
	var time_x = distance_x / movement_speed
	var time_y = distance_y / movement_speed
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position",
	position, x1, time_x,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	print("second tween")
		
	tween.interpolate_property(self, "position",
	get_position(), Vector2(get_position().x , pos.y), time_y,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
#else:
#	yield(text, "text_finished")
#			move_to(pos)



"""

				var move_x = Vector2(50,0)

				var neg_move_x = Vector2(-50,0)

				var move_y = Vector2(0,50)

				var neg_move_y = Vector2(0,-50)

				var stop = Vector2(0, 0)

				if sign(x) == 1:

								if x2 < x1:

												move_and_slide(move_x)

								else:

												move_and_slide(stop)

				elif sign(x) == -1:

								if x2 > x1:

												move_and_slide(neg_move_x)

												if x2 < x1:

																move_and_slide(stop)

				elif sign(y) == 1:

								if y2 < y1:

												if x2 < x1:

																move_and_slide(move_y)

												if y2 < x1:

																move_and_slide(stop)

				elif sign(y) == -1:

								if y2 > y1:

												if x2 < x1:

																move_and_slide(move_y)
if y2 < x1:

move_and_slide(stop)
"""
