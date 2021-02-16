extends KinematicBody2D

var MAX_SPEED = 50
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var Ray = $RayCast2D

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = (Input.get_action_strength("right") - Input.get_action_strength("left"))
	input_vector.y = (Input.get_action_strength("down") - Input.get_action_strength("up"))
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = input_vector
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO
	
	velocity = velocity * MAX_SPEED
	move_and_slide(velocity)

