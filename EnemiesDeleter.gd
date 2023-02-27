extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()




func _on_Area2D_area_entered(area):
	get_parent().enemies.append([area.get_parent().name_, Vector2(150,150)])
	area.get_parent().queue_free()
