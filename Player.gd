extends KinematicBody2D

var MAX_SPEED = 75
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer



func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	input_vector.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x >  0:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
		velocity = input_vector
	else:
		animationPlayer.play("IdleRight")
		velocity = Vector2.ZERO
	
	velocity = velocity * MAX_SPEED
	move_and_slide(velocity)
