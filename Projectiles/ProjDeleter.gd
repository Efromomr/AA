extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#pass


func _on_Area2D_area_entered(area):
	print(area.get_name())
	area.get_parent().queue_free()
