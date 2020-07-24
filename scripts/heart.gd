extends Node2D

onready var animation = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")
onready var ALIVE = true
func _ready():
	pass # Replace with function body.

func die():
	animation.play("death")
	ALIVE = false

func born():
	animation.play("birth")
	ALIVE = true


	
