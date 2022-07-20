extends Projectile


func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()
	
func _process(delta):
	$Area2D.set_collision_layer_bit(5,0)
	set_physics_process(false)
