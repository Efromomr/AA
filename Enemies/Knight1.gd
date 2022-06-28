extends KinematicBody2D


export var ACCELERATION = 100
export var MAX_SPEED = 25
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4
export var damage = 1
var health = 10
var attack_timer
var mouse_pos
var velocity = Vector2(0,0)
enum {
	IDLE,
	RUN,
	HURT,
	DEAD,
	ATTACK,
	WANDER
}
var state = RUN
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var stateMachine = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_timer = Timer.new()
	attack_timer.set_one_shot(false)
	attack_timer.set_wait_time(3)
	attack_timer.connect("timeout", self, "shoot")
	add_child(attack_timer)

	attack_timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	velocity = move_and_slide(velocity)
	match state:
		RUN:
			stateMachine.travel("Run")
			accelerate_towards_point(global_position.direction_to(Utils.player.global_position))
			
	mouse_pos= to_local(Utils.player.position)
	if mouse_pos.x > 0:
			scale.x = 1
	elif mouse_pos.x < 0:
			scale.x = -1
	$MovingHand.position.x = cos(mouse_pos.angle()) * 2 - 5
	$MovingHand.position.y = sin(mouse_pos.angle()) * 2 + 5
	$Weapon.position.x = cos(mouse_pos.angle()) * $Weapon.radius + $Weapon.offset_x
	$Weapon.position.y = sin(mouse_pos.angle()) * $Weapon.radius + $Weapon.offset_y
	$Weapon.rotation_degrees = rad2deg(mouse_pos.angle()) + $Weapon.rot_offset

func _on_Hurtbox_area_entered(area):
	pass # Replace with function body.
func shoot():
	$Weapon.shoot(position + $Weapon.position, (Utils.player.global_position - position).normalized())
func accelerate_towards_point(direction):
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
