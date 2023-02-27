extends KinematicBody2D

class_name Enemy
var ACCELERATION = 100
var MAX_SPEED = 25
var FRICTION = 200
var damage = 1
var health = 10 setget set_health

var velocity = Vector2.ZERO

var blink_timer
var death_timer
var weapon
var enemy_name = 'Bull'

enum {
	IDLE,
	RUN,
	HURT,
	DEAD,
	ATTACK,
	WANDER
}
var state = RUN
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('enemies')
	blink_timer = Timer.new()
	blink_timer.set_one_shot(false)
	blink_timer.set_wait_time(0.1)
	blink_timer.connect("timeout", self, "modulate")
	add_child(blink_timer)
	
	death_timer = Timer.new()
	death_timer.set_one_shot(false)
	death_timer.set_wait_time(2)
	death_timer.connect("timeout", self, "queue_free")
	add_child(death_timer)


func get_class():
	return "Enemy"

func is_class(value):
	return value == "Enemy"


func set_health(value):
	health = value
	if health <= 0:
		die()
	else:
		$Sprite.material.set("shader_param/active", true)
		state = HURT
		blink_timer.start()
		
func die():
	state = DEAD
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	death_timer.start()
	
func accelerate_towards_point(direction):
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
