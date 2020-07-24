extends Node

onready var score_label = $Score_label



func _ready():
	score_label.set_text("your score:\n\t" + str(global.score)+"/"+ str(global.max_turns) )
	global.score = 0

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://MainMenu2.tscn")
	#if Input.is_action_pressed("ui_accept"):
		#get_tree().change_scene("res://MainMenu2.tscn")



func _on_Button_pressed():
	get_tree().change_scene("res://MainMenu2.tscn")
