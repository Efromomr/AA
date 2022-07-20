extends Weapon

func _init():
	rot_offset = 45
	offset_x = 0
	projectile_name = "ToothpickPro"
	

func shoot(a, b, c=true):
	visible = false
	.shoot(a, b, false)
	if b.x < 0:
		proj_instance.get_node("Sprite").flip_h = true
		proj_instance.get_node("Sprite").rotation_degrees += 90
	yield(proj_instance, 'tree_exited')
	visible = true
