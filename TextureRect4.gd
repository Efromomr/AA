extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _input(event):
	if Input.is_action_just_pressed('book'):
		visible = not visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
