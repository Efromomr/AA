extends Node2D


var tile
	


func _on_Area2D_body_exited(body):
	body.set_collision_mask_bit(6,64)
