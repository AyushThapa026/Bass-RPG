extends Node2D

onready var fade = preload("res://FadeIn.tscn")

func _ready():
	var fadein = fade.instance()
	var animationplayer = fadein.get_node("AnimationPlayer")
	self.add_child(fadein)
	animationplayer.play_backwards("fade_in")
	fadein.queue_free()
