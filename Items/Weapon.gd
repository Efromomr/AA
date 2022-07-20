extends Node2D
class_name Weapon

var radius = 6
var offset_x = -5
var offset_y = 5
var rot_offset = 0
var damage = 1
var shoot_speed = 200
var projectile_name = "DaggerPro"
var projectile
var hand
var mouse_pos
var proj_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	projectile = load("res://Projectiles/"+projectile_name+".tscn")
	hand = get_parent().get_node("Hand")
	


func shoot(pos, dir, friendly=true): 
	proj_instance = projectile.instance()
	proj_instance.position = pos + 6 * dir
	proj_instance.damage = damage
	proj_instance.friendly = friendly
	proj_instance.rotation = dir.angle()
	proj_instance.rotation_degrees += 270
	proj_instance.linear_velocity = dir * shoot_speed
	get_tree().get_root().add_child(proj_instance)

func _physics_process(delta):
	move_weapon()
func move_weapon():
	mouse_pos= get_parent().mouse_pos
	hand.position.x = cos(mouse_pos.angle()) * 2 - 5
	hand.position.y = sin(mouse_pos.angle()) * 2 + 5
	position.x = cos(mouse_pos.angle()) * radius + offset_x
	position.y = sin(mouse_pos.angle()) * radius + offset_y
	rotation_degrees = rad2deg(mouse_pos.angle()) + rot_offset
