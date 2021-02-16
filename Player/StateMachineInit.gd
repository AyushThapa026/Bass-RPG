extends StateMachine

func _ready():
	add_state("idle")
	add_state("run")
	add_state("interacting")
	call_deferred("set_state", states.idle)


func _state_logic(delta):
	parent.move_player()
	parent.interact()

func _get_transition(delta):
	match state:
		states.idle:
			if parent.velocity.x != 0 or parent.velocity.y != 0:
				return states.run
		states.run:
			if (parent.velocity.x == 0) and (parent.velocity.y == 0):
				return states.idle
	return null
	
func _enter_state(new_state, old_state):
	parent.get_node("StateLabel").bbcode_text = "[center][rainbow]" + states.keys()[new_state].capitalize() + "[/rainbow][/center]"
	
	#print(states.keys()[new_state].capitalize())
	pass

func _exit_state(old_state, new_state):
	pass
