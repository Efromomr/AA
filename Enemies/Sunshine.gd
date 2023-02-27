extends Enemy
const bullet_scene = preload("res://Projectiles/SunshineBowArrow.tscn")
var sun = preload("res://Projectiles/SunPro.tscn")
onready var shoot_timer = $ShootTimer
onready var rotater = $Rotater

const rotate_speed = 100
const shoot_timer_wait_time = 0.2
const spawn_point_count = 8
const radius = 50

var eclipse_tex
var rotating_ai = false
var spawn_sun_ai = false
var wait_timer
var attack_timer


func _init():
	health = 100

func _ready():	
	rotating_ai = true
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shoot_timer_wait_time
	shoot_timer.start()
	
	attack_timer = Timer.new()
	attack_timer.set_one_shot(true)
	attack_timer.set_wait_time(5.5)
	attack_timer.connect("timeout", self, "rotating_ai_end")
	add_child(attack_timer)
	attack_timer.start()
	yield(get_tree().create_timer(1.0), "timeout")
	move_eclipse()
	
	wait_timer = Timer.new()
	wait_timer.set_one_shot(true)
	wait_timer.set_wait_time(5.5)
	wait_timer.connect("timeout", self, "spawning_sun_ai_end")
	add_child(wait_timer)
	

	
func _on_Hurtbox_area_entered(area):
	self.health-=area.get_parent().damage
	get_node("../../CanvasLayer/UI/TextureProgress").value = health 
	
	
func move_eclipse():
	eclipse_tex = get_tree().get_root().get_node('Node2D/Sprite4')
	get_tree().get_root().get_node('Node2D/Tween').interpolate_property(eclipse_tex, "position",
			Vector2(0, 250), Vector2(235, 250), 5, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
	get_tree().get_root().get_node('Node2D/Tween').start()


func _process(delta):
	if rotating_ai:
		var new_rotation = rotater.rotation_degrees + rotate_speed * delta
		rotater.rotation_degrees = fmod(new_rotation, 360)
	elif spawn_sun_ai:
		spawn_sun()
		spawn_sun_ai = false
	
func modulate():
	$Sprite.material.set("shader_param/active", false)
	
func spawn_sun():
	var instance = sun.instance()
	instance.position = position + Vector2(0, 100)
	get_tree().get_root().add_child(instance)
	

func _on_ShootTimer_timeout() -> void:
	
	if rotating_ai:
		for s in rotater.get_children():
			var bullet = bullet_scene.instance()
			#get_tree().root.add_child(bullet)
			get_parent().add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation
		
func rotating_ai_end():
	rotating_ai = false
	spawn_sun_ai = true
	eclipse_tex = get_tree().get_root().get_node('Node2D/Sprite4')
	eclipse_tex.position = Vector2(0,250)
	wait_timer.start()
	
	
func spawning_sun_ai_end():
	rotating_ai = true
	move_eclipse()
	attack_timer.start()
	
