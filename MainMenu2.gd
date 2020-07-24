extends Node

#colors at https://www.color-hex.com/color-palette/827

onready var dropdown_menu = get_node("VBoxContainer/HBoxContainer/level_choice")


func _ready():
	global.level = 1

	


func _on_StartButton_pressed():
	self.get_node("level_choice_window").show()
	

func _on_ExitButton_pressed():
	get_tree().quit()


func _on_Time_Challenge_pressed():
	get_tree().change_scene("res://scenes/Main_gameTIME.tscn")


func _on_level_choice_changed():
	global.level = dropdown_menu.get_value()


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Main_game2.tscn")
