extends Node2D

onready var play = $MarginContainer/TextureButton
 
func _ready():
	play.grab_focus()

func _physics_process(delta):
	if play.is_hovered() == true:
		play.grab_focus()

func _on_TextureButton_pressed():
	get_tree().change_scene("res://World.tscn")
