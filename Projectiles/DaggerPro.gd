extends RigidBody2D

var damage 
var stuck = preload("res://Projectiles/DaggerStuck.tscn")
var dust = preload("res://WallDust.tscn")
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RigidBody2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var instance = stuck.instance()
	var dust_instance = dust.instance()
	get_tree().get_root().call_deferred("add_child", instance)
	get_tree().get_root().call_deferred("add_child", dust_instance)
	dust_instance.position = position
	instance.position = position
	instance.rotation = rotation
	queue_free()
	

