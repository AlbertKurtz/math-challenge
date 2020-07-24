extends Node


onready var player_input = $CenterContainer/VBoxContainer/LineEdit
onready var question_label = $ReferenceRect/Label
onready var score_label = $Score
onready var quiz_generator = preload("res://scripts/quiz_generator.gd").new()
onready var result 
onready var print_string
var lista

var counter



func generate_quiz(lvl):
	if lvl>4:
		lvl = 1
	match lvl:
		1: lista = quiz_generator.generate_quiz_level1()
		2: lista = quiz_generator.generate_quiz_level2()
		3: lista = quiz_generator.generate_quiz_level3()
		4: lista = quiz_generator.generate_quiz_level1()
	
	result = lista[0]
	print_string = lista[1]
	question_label.set_text(print_string)


func update_score():
	score_label.set_text(str(global.score) + "/" + str(counter))

func answer_given():
	if int(player_input.get_text() )== result:
			global.score += 1
	player_input.clear()
	counter += 1
	generate_quiz(global.level) 
	update_score()
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():

	counter = 0
	if not OS.has_touchscreen_ui_hint():
		player_input.grab_focus()
	# Called when the node is added to the scene for the first time.
	# Initialization here
	generate_quiz(global.level)
	
	

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://MainMenu2.tscn")
	if Input.is_action_just_pressed("ui_accept"):
		 answer_given()
	if counter == global.max_turns:
		get_tree().change_scene("res://scenes/End_screen.tscn")
	
	
	
	#print(randi())
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func num_button(num):
	print_string = player_input.get_text() + str(num)	
	player_input.clear()
	player_input.set_text(print_string)
	if not OS.has_touchscreen_ui_hint():
		player_input.grab_focus()
	
	

func _on_Button_pressed():
	answer_given() # replace with function body


func _on_Button7_pressed():
	num_button(7)

func _on_Button8_pressed():
	num_button(8)

func _on_Button9_pressed():
	num_button(9)

func _on_Button4_pressed():
	num_button(4)

func _on_Button5_pressed():
	num_button(5)

func _on_Button6_pressed():
	num_button(6)

func _on_Button1_pressed():
	num_button(1)

func _on_Button2_pressed():
	num_button(2)

func _on_Button3_pressed():
	num_button(3)

func _on_Button0_pressed():
	num_button(0)

func _on_clear_button_pressed():
	player_input.clear()
