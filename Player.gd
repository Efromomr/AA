extends KinematicBody2D


export var ACCELERATION = 2000
export var MAX_SPEED = 150
export var FRICTION = 2000

var old_pos
var velocity = Vector2.ZERO
var mouse_pos = Vector2(0,0)
var dash_pressed = Vector2(0,0)
var dash_cooldown = false

var invincibilityTimer
var blinkTimer
var dashTimer
onready var weapon = null
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
var input_vector = Vector2.ZERO
var vec

var direction 

enum state {idle, run, jump, dead}
export var current_state = state.idle

var max_health = 30
var health = 30 setget set_health
signal health_changed

var can_attack = true setget set_can_attack

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
	
	Inventory.connect("weapon_changed", self, "set_weapon")
	set_weapon()
	
	#var rod_instance = rod.instance()
	#add_child(rod_instance)

func _physics_process(delta):
	move_state(delta)
	
func move_state(delta):
	mouse_pos = get_local_mouse_position()
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
			animationState.travel("Death1")
			can_attack = false
	if current_state != state.dead:
		move()
	else: 
		set_physics_process(false)

func move():
	velocity = move_and_slide(velocity)
	
func _input(_event):
	if Input.is_action_just_pressed("attack") and can_attack:
		weapon.shoot(Vector2(weapon.global_position.x, weapon.global_position.y), (get_global_mouse_position() - Utils.player.global_position).normalized())

	if Input.is_action_just_pressed("jump"):
		set_collision_mask_bit(6,0)
		current_state = state.jump
		position.y -= 10
		#get_tree().get_root().get_node("Maze/Player/Camera2D").shake(25, 1.5)
	if Input.is_action_just_released("ui_right"):
		dash(Vector2(500,0))
	if Input.is_action_just_released("ui_left"):
		dash(Vector2(-500,0))
	if Input.is_action_just_released("ui_up"):
		dash(Vector2(0,-500))
	if Input.is_action_just_released("ui_down"):
		dash(Vector2(0,500))
		
func set_weapon():
	if weapon != null:
		weapon.queue_free()
	var current_weapon_node = load("res://Items/" + Inventory.current_weapon + ".tscn")
	var current_weapon_instance = current_weapon_node.instance()
	add_child_below_node($Sprite, current_weapon_instance)
	weapon = current_weapon_instance
	
			
func dash_timer_ends():
	dash_cooldown = false
func dash(dir):
	if dash_pressed == dir and dash_cooldown:
			$Particles2D.emitting = true
			velocity = dir
			$Hurtbox/CollisionShape2D.disabled = true
			move()
			
			dash_pressed = Vector2(0,0)
			dash_cooldown = false
			yield(get_tree().create_timer(0.2), "timeout")
			$Hurtbox/CollisionShape2D.disabled = false
			$Particles2D.emitting = false
	else:
		dash_pressed = dir
		dash_cooldown = true
		dashTimer.start()
		



func _on_Hurtbox_area_entered(area):
	self.health -= area.get_parent().damage
	if health <= 0:
		current_state = state.dead
		weapon.visible = false
		$Hand.visible = false
	else:
		$Sprite.material.set("shader_param/active", true)
		blinkTimer.start()
	#velocity += area.get_parent().knockback_vector
func blink_ends():
	$Sprite.material.set("shader_param/active", false)
	
func set_can_attack(value):
	can_attack = value
	if can_attack:
		weapon.visible = true
		$HandSprite.visible = false
		$Hand.visible = true
	else:
		weapon.visible = false
		$HandSprite.visible = true
		$Hand.visible = false
	
func set_health(value):
	health = value
	emit_signal("health_changed", value)
