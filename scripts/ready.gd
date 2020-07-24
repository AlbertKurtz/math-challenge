extends Button

const START_LEVEL = "start_level"
signal start_level

func _ready():
	pass # Replace with function body.


func _on_ready_pressed():
	self.hide()
	emit_signal(START_LEVEL)
	
