extends Weapon

var nearest_enemy
func _init():
	projectile_name = "SunshineBowArrow"
	damage = 20
	offset_y = 4
	offset_x = -3


func shoot(pos, dir, friendly=true):
	hand.visible = false
	$AnimatedSprite.play("default")
	yield(get_node("AnimatedSprite"), "animation_finished")
	.shoot(Vector2(global_position.x, global_position.y), (mouse_pos - Utils.player.global_position).normalized())
	
func move_weapon():
	var enemies = get_tree().get_nodes_in_group('enemies')
	var distance = 1000
	if enemies.size() > 0:
		for enemy in enemies:
			if Utils.player.global_position.distance_to(enemy.global_position) < distance and enemy.state != 3:
				distance = Utils.player.global_position.distance_to(enemy.global_position)
				nearest_enemy = enemy
				mouse_pos = enemy.global_position
	else:
		mouse_pos= get_parent().get_global_mouse_position()
	hand.position.x = cos(get_parent().to_local(mouse_pos).angle()) * 2 - 5
	hand.position.y = sin(get_parent().to_local(mouse_pos).angle()) * 2 + 5
	position.x = cos(get_parent().to_local(mouse_pos).angle()) * radius + offset_x
	position.y = sin(get_parent().to_local(mouse_pos).angle()) * radius + offset_y
	rotation_degrees = rad2deg(get_parent().to_local(mouse_pos).angle()) + rot_offset	



func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.playing = false
	$AnimatedSprite.frame = 0
	hand.visible = true # Replace with function body.
