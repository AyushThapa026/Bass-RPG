extends Control

var dialog = [
	'Hello there, doctor Justin, the patient is waiting.',
	'Thanks, tell them I will be there shortly. Thanks.',
	'Hello Mrs.(Insert Name), how are you?',
	'Good, lets start.'
]

onready var Rich = $DialogBox/RichTextLabel
onready var Tween = $DialogBox/Tween
onready var next = $DialogBox/next
var dialog_index = 0
var finished = true
var reveal_speed = 15
func _ready():
	load_dialog()

func _finished():
	finished = true
	dialog_index += 1

func _process(delta):
	next.visible = finished
	if Input.is_action_just_pressed("enter"):
		load_dialog()
	elif Input.is_action_just_pressed("skip"):
		if finished == false:
			Tween.stop(Rich)
			Rich.percent_visible = 1
			_finished()

func load_dialog():
	finished = false
	if dialog_index < dialog.size(): 
		var time = dialog[dialog_index].length() / reveal_speed
		Rich.bbcode_text = dialog[dialog_index]
		Rich.percent_visible = 0
		Tween.interpolate_property(
			Rich, "percent_visible", 0, 1, time,
			 Tween. TRANS_LINEAR, Tween. EASE_IN_OUT
			)
		Tween.start()
		
	else:
		queue_free()


func _on_Tween_tween_completed(object, key):
	_finished()
