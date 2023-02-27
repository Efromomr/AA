extends Projectile


func _physics_process(delta):
	linear_velocity = linear_velocity.move_toward(Vector2.ZERO, 1000 * delta)
	if linear_velocity == Vector2.ZERO:
		queue_free()


