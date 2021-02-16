extends Control

onready var play = $Play
onready var hoverSound = $Hover
onready var fade = preload("res://UI/FadeIn.tscn")

func _ready():
	get_viewport().audio_listener_enable_2d = true

func hoverSound():
	play.grab_focus()
	hoverSound.play()

func _on_Play_mouse_entered():
	hoverSound()



func _on_Play_pressed():
	var fadein = fade.instance()
	var animationplayer = fadein.get_node("AnimationPlayer")
	self.add_child(fadein)
	animationplayer.play("fade_in")
	var timer = fadein.get_node("Timer")
	timer.connect("timeout", self, "change_scene")
	timer.start()
	

func change_scene():
	print("change scene")
	get_tree().change_scene("res://World/World.tscn")
