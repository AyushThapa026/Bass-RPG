extends Control

onready var Rich = $DialogueText
onready var Tween = $Tween
onready var next = $next
onready var Arrow = $Arrow
onready var option_container = $OptionContainer
onready var player = get_tree().get_root().find_node('Player', true, false)
onready var Bass = get_node("res://scripts/Bass")
var dialogue_index = "000"
var finished = false
var reveal_speed = 15
var dialogue
var current_dialogue
var response = false
var selected_option = 1
var selecting = false
signal text_finished

func _ready():
	Arrow.visible = false
	Datastore.connect("loaded", self, "_player_connect")
	player.connect("interact", self, "get_dialogue_from_JSON")
	
func _player_connect():
	player = Globals.global_variables.player
	player.connect("interact", self, "get_dialogue_from_JSON")
	
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
	elif response == true:
		Arrow.visible = true
		option_container.visible = true
		selecting = true
		
		selected_option = 1
		var pos1 = get_node("pos1")
		Arrow.position = pos1.position
		
		
		var total_options = current_dialogue.responses.size()

		for option in total_options:
			var option_node = option_container.get_node("Option" + str(option+1))
			option_node.visible = true # only turn the available options visible.
			option_node.text = current_dialogue.responses.keys()[option]
		
	finished = true


func _input(event):
	if dialogue != null:
		if selecting == false:
			if Input.is_action_just_pressed("enter"):
				if finished == true:
					if current_dialogue.next == 'none':
						if current_dialogue.has("commands"):
							for i in current_dialogue.commands:
								execute(i)
						visible = false
						emit_signal("text_finished")
						dialogue = null
						dialogue_index = "000"
						current_dialogue = null
						player.interactions.interacting = false
						print('done interacting')
					load_dialogue()
				else:
					Tween.stop(Rich)
					Rich.percent_visible = 1
					_finished()
		else:
			if Input.is_action_just_pressed("option_up"):
				if selected_option > 1:
					selected_option -= 1
					Arrow.position = get_node("pos" + str(selected_option)).position
			elif Input.is_action_just_pressed("option_down"):
				if selected_option < current_dialogue.responses.size():
					selected_option += 1
					Arrow.position = get_node("pos" + str(selected_option)).position
			if Input.is_action_just_pressed("enter"):
				print('pressed enter')
				dialogue_index = current_dialogue.responses[str(current_dialogue.responses.keys()[selected_option-1])].next
				response = false
				selecting = false
				for option in option_container.get_children():
					option.visible = false
				Arrow.visible = false
				load_dialogue()

func execute(command_line : String):
	var args = command_line.split(" ")
	if args.size() > 0:
		var command = args[0]
		args.remove(0)
		match command:
			"add": # add values to global values
				Globals.global_variables[args[0]] += int(args[1])
				print('added ' + args[1] + " " + str(args[0]))
			"set": # set global values
				Globals.global_variables[args[0]] = args[1]
				print('set ' + str(args[0]) + " to " + args[1])
			"subtract":
				Globals.global_variables[args[0]] -= int(args[1])
				print('subtracted ' + args[1] + " " + str(args[0]))
			"move":
				var node = get_tree().get_root().find_node(args[0], true, false)
				print ("getting node")
				node.move_to(Vector2(args[1], args[2]))
				print ("moving node")

func load_dialogue():# This dialogue is the same as the one above (line 18)
	if dialogue != null:
		if dialogue.has(dialogue_index):
			current_dialogue = dialogue[dialogue_index]
			if current_dialogue.has("type"):
				next.visible = false
				visible = true
				finished = false
				if (current_dialogue.speaker_id == "none") or (Globals.global_variables['knows_' + current_dialogue.speaker_id] == false):
					get_node("speaker_id").bbcode_text = "[center]???[/center]"
				else:
					get_node("speaker_id").bbcode_text = "[center]" + str(current_dialogue.speaker_id).capitalize() + "[/center]"

				match current_dialogue.type:
					"dialogue":
						var time : float = clamp(current_dialogue.text.length() / reveal_speed, 0.5, 10)
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
