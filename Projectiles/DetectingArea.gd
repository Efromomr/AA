extends Node2D

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()

func _on_Area2D_area_entered(area):
	get_parent().list_of_enemies.append(area)
	


