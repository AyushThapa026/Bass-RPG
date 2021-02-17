extends KinematicBody2D

var MAX_SPEED = 50
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var Ray = $RayCast2D
onready var area = get_node("Area")
onready var option = $Option
var database = null;
var input_vector

var interactions = {
	"interacting" : false,
	"ready_to_interact" : false,
	"object_to_interact" : null
}

signal interact

func _ready():
	database = JsonLoader.load_json_file("res://Interactions/interaction_database.json")
	print(database)
	


func move_player():
	input_vector = Vector2.ZERO
	input_vector.x = (Input.get_action_strength("right") - Input.get_action_strength("left"))
	input_vector.y = (Input.get_action_strength("down") - Input.get_action_strength("up"))
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		
		velocity = input_vector
	else:
		velocity = Vector2.ZERO
	
	velocity = velocity * MAX_SPEED
	move_and_slide(velocity)

func interact():
	if Input.is_action_pressed("interact"):
		if interactions.ready_to_interact == true and interactions.interacting == false:
			interactions.interacting = true
			print('interacted')
			emit_signal("interact", interactions)
			velocity = Vector2.ZERO
			


func _on_Area_area_entered(area):
	# Get the topmost node
	var object = area.get_owner()
	# If the object has been registered in the database
	if database.has(object.name) == true:
		print("in range to use object: " + area.get_owner().name)
		# Visual effect - for note it would show "Read Note". The action and name would be specified in the JSON file.
		option.bbcode_text = "[center][color=#fff500]" + str(database[object.name].Action)  + " " + str(database[object.name].Name) + "[/color][/center]"
		
		# Set some variables so that everyone who needs to know knows.
		interactions.ready_to_interact = true
		interactions.object_to_interact =  {
		"node" : object,
		"database_index" : database[object.name],
		}	


func _on_Area_area_exited(area):
	print("not in range to use object: " + area.get_owner().name)
	# Get rid of it it we aren't in range.
	option.bbcode_text = ""
	interactions.ready_to_interact = false
	interactions.object_to_interact = null
