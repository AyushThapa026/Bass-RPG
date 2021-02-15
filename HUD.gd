extends Control

onready var container = get_node("VBoxContainer")
onready var settings = container.get_node("Settings")
onready var quit = container.get_node("Settings")

func _input(event):
	if event.is_action_pressed("menu"):
		if visible == false:
			visible = true
		else:
			visible = false


func _on_Quit_pressed():
	get_tree().quit()
