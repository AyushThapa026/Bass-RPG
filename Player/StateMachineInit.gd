extends StateMachine

func _ready():
	add_state("idle")
	add_state("run")
	add_state("interacting")
	call_deferred("set_state", states.idle)


func _state_logic(delta):
	if state != states.interacting:
		parent.move_player()
	parent.interact()
	
	if state == states.run:
		parent.animationState.travel("Run")
	elif state == states.idle:
		parent.animationState.travel("Idle")
	else:
		parent.animationState.travel("Idle")

func _get_transition(delta):
	match state:
		states.idle:
			if (parent.velocity.x != 0 or parent.velocity.y != 0) and parent.interactions.interacting == false:
				return states.run
			elif parent.interactions.interacting == true:
				return states.interacting
		states.run:
			if (parent.velocity.x == 0) and (parent.velocity.y == 0):
				return states.idle
			elif parent.interactions.interacting == true:
				return states.interacting
		states.interacting:
			if parent.interactions.interacting == false:
				if parent.velocity.x != 0 or parent.velocity.y != 0:
					return states.run
				elif (parent.velocity.x == 0) and (parent.velocity.y == 0):
					return states.idle
	return null
	
func _enter_state(new_state, old_state):
	print(states.keys()[new_state].capitalize())
	parent.get_node("StateLabel").bbcode_text = "[center][rainbow]" + states.keys()[new_state].capitalize() + "[/rainbow][/center]"
	
	#print(states.keys()[new_state].capitalize())
	pass

func _exit_state(old_state, new_state):
	pass
