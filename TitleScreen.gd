extends Control

onready var play = $Play
onready var hoverSound = $Hover
onready var fade = preload("res://FadeIn.tscn")

func _ready():
	get_viewport().audio_listener_enable_2d = true

func hoverSound():
	print("hovered")
	play.grab_focus()
	hoverSound.play()

func _on_Play_mouse_entered():
	print("asdfasdfuiags")
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
	print("change scnee")
	get_tree().change_scene("World.tscn")
