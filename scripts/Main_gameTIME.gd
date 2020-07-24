extends Node


onready var player_input = get_node("CenterContainer/VBoxContainer/LineEdit")
onready var question_label = get_node("ReferenceRect/Label")
onready var score_label = get_node("Score")
onready var quiz_generator = preload("res://scripts/quiz_generator.gd").new()
onready var result 
onready var print_string
onready var timer_label = get_node("timer/Label")
onready var t = Timer.new()


onready var lista
onready var time_difficulty
onready var operation_difficulty

onready var temp_score =0 
onready var counter
onready var max_time

onready var hearts_bar=get_node("hearts_bar")
onready var heart_index = 0

onready var hour_glass = get_node("hour_glass")

func _ready():
	var difficulty_pair = quiz_generator.split_level(global.level)
	operation_difficulty = difficulty_pair[0]
	time_difficulty = difficulty_pair[1]
	max_time = quiz_generator.time_difficulty(time_difficulty)
	spawn_timer(max_time)
	
	counter = 0
	if not OS.has_touchscreen_ui_hint():
		player_input.grab_focus()
	
	heart_index = 0
	for child in hearts_bar.get_children():
		if child.ALIVE == false:
			child.born()
	generate_quiz(operation_difficulty)
	
	

func _process(delta):
	timer_label.set_text(str(int(t.get_time_left())))
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://MainMenu2.tscn")
	if Input.is_action_just_pressed("ui_accept"):
		 answer_given()
	if counter == global.max_turns or heart_index>2:
		if temp_score >= 8:
			global.level += 1
			temp_score = 0
			t.queue_free()
			hour_glass.get_node("AnimationPlayer").play("spinning")
			_ready()
			#var splitted_level = quiz_generator.split_level(global.level)
			#quiz_generator.ultimate_generate_quiz(splitted_level[0])
	
		else:
			get_tree().change_scene("res://scenes/End_screenTIME.tscn")
			

func spawn_timer(max_time):
	t.connect("timeout",self,"_on_timer_timeout") 
	add_child(t)
	t.set_autostart(true)
	t.set_one_shot(true)
	t.start(max_time)	
	
	timer_label.set_text(str(int(t.time_left)))
	



func generate_quiz(lvl):
	lista = quiz_generator.ultimate_generate_quiz(lvl)
	result = lista[0]
	print_string = lista[1]
	question_label.set_text(print_string)


func update_score():
	score_label.set_text(str(global.score))

func answer_given():
	if int(player_input.get_text() ) == result:
			global.score += 1
			temp_score += 1
	else:
		hearts_bar.get_child(heart_index%3).die()
		heart_index += 1
		
		
	player_input.clear()
	counter += 1
	generate_quiz(operation_difficulty) 
	update_score()


func num_button(num):
	print_string = player_input.get_text() + str(num)	
	player_input.clear()
	player_input.set_text(print_string)
	if not OS.has_touchscreen_ui_hint():
		player_input.grab_focus()

func _on_timer_timeout():
	get_tree().change_scene("res://scenes/End_screenTIME.tscn")
	
		
	

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
