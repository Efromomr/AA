extends KinematicBody2D


export var ACCELERATION = 2000
export var MAX_SPEED = 200
export var FRICTION = 2000

var old_pos
var velocity = Vector2.ZERO
var mouse_pos = Vector2(0,0)
var dash_pressed = Vector2(0,0)
var dash_cooldown = false

var invincibilityTimer
var blinkTimer
var dashTimer
onready var weapon = $Weapon
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
var input_vector = Vector2.ZERO
var vec

var direction 

enum state {idle, run, jump, dead}
export var current_state = state.idle

func _ready():
	Utils.player = self
	animationTree.active = true
	
	invincibilityTimer = Timer.new()
	invincibilityTimer.set_one_shot(true)
	invincibilityTimer.set_wait_time(2)
	invincibilityTimer.connect("timeout", self, "invincibility_ends")
	add_child(invincibilityTimer)
	
	blinkTimer = Timer.new()
	blinkTimer.set_one_shot(true)
	blinkTimer.set_wait_time(0.1)
	blinkTimer.connect("timeout", self, "blink_ends")
	add_child(blinkTimer)
	
	dashTimer = Timer.new()
	dashTimer.set_one_shot(true)
	dashTimer.set_wait_time(0.2)
	dashTimer.connect("timeout", self, "dash_timer_ends")
	add_child(dashTimer)
	
	#var rod_instance = rod.instance()
	#add_child(rod_instance)

func _physics_process(delta):
	mouse_pos= get_local_mouse_position()
	move_state(delta)
	$Hand.position.x = cos(mouse_pos.angle()) * 2 - 5
	$Hand.position.y = sin(mouse_pos.angle()) * 2 + 5
	$Weapon.position.x = cos(mouse_pos.angle()) * $Weapon.radius + $Weapon.offset_x
	$Weapon.position.y = sin(mouse_pos.angle()) * $Weapon.radius + $Weapon.offset_y
	$Weapon.rotation_degrees = rad2deg(get_local_mouse_position().angle()) + $Weapon.rot_offset
	
func move_state(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if mouse_pos.x > 0:
			scale.x = 1
	elif mouse_pos.x < 0:
			scale.x = -1

	if input_vector != Vector2.ZERO:
		if current_state == state.idle:
			current_state = state.run
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		if current_state == state.run:
			current_state = state.idle
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	match current_state:
		state.idle:
			animationState.travel("Idle ")
		state.run:
			animationState.travel("Run")
		state.jump:
			animationState.travel("Jump")
		state.dead:
			animationState.travel("Death")
	move()

func move():
	velocity = move_and_slide(velocity)
	
func _input(_event):
	if Input.is_action_just_pressed("attack"):
		weapon.shoot(Vector2(Utils.player.global_position.x + weapon.position.x, Utils.player.global_position.y + weapon.position.y), (get_global_mouse_position() - Utils.player.global_position).normalized())

	#if Input.is_action_just_pressed("jump"):
		#current_state = state.jump
		#get_tree().get_root().get_node("Maze/Player/Camera2D").shake(25, 1.5)
	if Input.is_action_just_released("ui_right"):
		dash(Vector2(500,0))
	if Input.is_action_just_released("ui_left"):
		dash(Vector2(-500,0))
	if Input.is_action_just_released("ui_up"):
		dash(Vector2(0,-500))
	if Input.is_action_just_released("ui_down"):
		dash(Vector2(0,500))
			
func dash_timer_ends():
	dash_cooldown = false
func dash(dir):
	if dash_pressed == dir and dash_cooldown:
			velocity = dir
			move()
			dash_pressed = Vector2(0,0)
			dash_cooldown = false
	else:
		dash_pressed = dir
		dash_cooldown = true
		dashTimer.start()
		

