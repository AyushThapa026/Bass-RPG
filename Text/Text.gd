extends Control

onready var Rich = $DialogBox/RichTextLabel
onready var Tween = $DialogBox/Tween
onready var next = $DialogBox/next
onready var Arrow = $DialogBox/Arrow
onready var Opt = $DialogBox/VBoxContainer
onready var player = get_tree().get_root().find_node('Player', true, false)
var dialogue_index = "000"
var finished = false
var reveal_speed = 15
var dialogue
var current_dialogue
var response = false
var selected_opt = 1

func _ready():
	player.connect("interact", self, "get_dialogue_from_JSON")
	Arrow.visible = false

func get_dialogue_from_JSON(interactions):
	# Loads the JSON file from the path. The path being "res://DialogueJSONFiles(folder)/InteractableType/ObjectJSONFile

	var database_index = interactions.object_to_interact.database_index
	dialogue = JsonLoader.load_json_file("res://DialogueJSONFiles/" + str(database_index.Type) + "/" + str(database_index.JSON_FILE) + ".json")
	

	load_dialogue() # This dialogue is the same as the one below (line 24)

func _finished():
	if response == false:
		if current_dialogue.next != 'none':
			dialogue_index = current_dialogue.next
			next.visible = true
	else:
		Arrow.visible = true
		selected_opt = 1
		Arrow.position.x = 15
		Arrow.position.y = 17
		
	finished = true
	

func _input(event):
	if dialogue != null:
		if Input.is_action_just_pressed("enter"):
			if finished == true:
				if current_dialogue.next == 'none':
					visible = false
					dialogue = null
					dialogue_index = "000"
					current_dialogue = null
					player.interactions.interacting = false
					print('done interacting')
				# get good at video games
				load_dialogue()
			else:
				Tween.stop(Rich)
				Rich.percent_visible = 1
				_finished()

func load_dialogue():# This dialogue is the same as the one above (line 18)
	if dialogue != null:
		if dialogue.has(dialogue_index):
			current_dialogue = dialogue[dialogue_index]
			if current_dialogue.has("type"):
				next.visible = false
				visible = true
				finished = false
				match current_dialogue.type:
					"dialogue":
						var time = current_dialogue.text.length() / reveal_speed
						Rich.bbcode_text = current_dialogue.text
						Rich.percent_visible = 0
						Tween.interpolate_property(
							Rich, "percent_visible", 0, 1, time,
							 Tween. TRANS_LINEAR, Tween. EASE_IN_OUT
							)
						Tween.start()
					"response":
						response = true
						var time = current_dialogue.text.length() / reveal_speed
						Rich.bbcode_text = current_dialogue.text
						Rich.percent_visible = 0
						Tween.interpolate_property(
							Rich, "percent_visible", 0, 1, time,
							 Tween. TRANS_LINEAR, Tween. EASE_IN_OUT
							)
						Tween.start()
							


func _on_Tween_tween_completed(object, key):
	_finished()
