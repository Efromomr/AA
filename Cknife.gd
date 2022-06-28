extends Node2D


var radius = 7
var offset_x = -5
var offset_y = 5
var rot_offset = 270
var damage = 10
var shoot_speed = 500
var projectile = load("res://Projectiles/DaggerPro.tscn")
func shoot(pos, dir): 
	var proj_instance = projectile.instance()
	proj_instance.position = pos
	proj_instance.damage = damage
	proj_instance.rotation = dir.angle()
	proj_instance.rotation_degrees += 270
	proj_instance.linear_velocity = dir * shoot_speed
	get_tree().get_root().add_child(proj_instance)
	
