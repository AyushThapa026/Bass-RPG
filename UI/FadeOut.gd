extends Node2D

onready var fade = preload("res://UI/FadeIn.tscn")

func queuefree():
	var fadein = get_node("CanvasLayer/FadeIn")
	fadein.queue_free()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Datastore.save_game()
		get_tree().quit() # default behavior

func _ready():
	Datastore.load_game()
	var fadein = fade.instance()
	fadein.color = Color("fd000000")
	self.get_node("CanvasLayer").add_child(fadein)
	var animationplayer = fadein.get_node("AnimationPlayer")
	animationplayer.play_backwards("fade_in")
	var timer = $Timer
	timer.connect("timeout", self, "queuefree")
	timer.start()
	
