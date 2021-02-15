extends Control

var dialog = [
	'Hello there, doctor Justin, the patient is waiting.',
	'Thanks, tell them I will be there shortly. Thanks.',
	'Hello Mrs.(Insert Name), how are you?'
]

onready var Rich = $DialogBox/RichTextLabel
onready var Tween = $DialogBox/Tween
onready var next = $DialogBox/next
var dialog_index = 0
var finished = false


func _ready():
	load_dialog()

func _process(delta):
	next.visible = finished
	if Input.is_action_just_pressed("enter"):
		load_dialog()

func load_dialog():
	finished = false
	if dialog_index < dialog.size(): 
		Rich.bbcode_text = dialog[dialog_index]
		Rich.percent_visible = 0
		Tween.interpolate_property(
			Rich, "percent_visible", 0, 1, 1,
			 Tween. TRANS_LINEAR, Tween. EASE_IN_OUT
			)
		Tween.start()
	else:
		queue_free()
	dialog_index += 1


func _on_Tween_tween_completed(object, key):
	finished = true
