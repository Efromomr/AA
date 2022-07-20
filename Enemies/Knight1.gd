extends Enemy

var weapon_scene = load("res://Items/Bow.tscn")

func _init():
	ACCELERATION = 100
	MAX_SPEED = 25
	FRICTION = 200
	damage = 1
	health = 10

var attack_timer
var player_pos
var mouse_pos = Vector2.ZERO
var player_near = false

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var stateMachine = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('enemies')
	weapon = weapon_scene.instance()
	add_child(weapon)
	weapon.shoot_speed = 200
	attack_timer = Timer.new()
	attack_timer.set_one_shot(false)
	attack_timer.set_wait_time(3)
	attack_timer.connect("timeout", self, "shoot")
	add_child(attack_timer)
	
	
	

	attack_timer.start()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = to_local(Utils.player.position)
	if health <= 0:
		state = DEAD 
		if has_node('attack_timer'):
			attack_timer.queue_free()
	velocity = move_and_slide(velocity)
	match state:
		IDLE:
			stateMachine.travel("Idle")
			velocity = Vector2.ZERO
			player_pos= to_local(Utils.player.position)
			if not player_near:
				state = RUN
			if player_pos.x > 0:
				scale.x = 1
			elif player_pos.x < 0:
				scale.x = -1

		RUN:
			stateMachine.travel("Run")
			if not player_near:
				accelerate_towards_point(global_position.direction_to(Utils.player.global_position))
			else:
				state = IDLE
			player_pos= to_local(Utils.player.position)
			if player_pos.x > 0:
				scale.x = 1
			elif player_pos.x < 0:
				scale.x = -1

		DEAD:
			velocity = Vector2.ZERO
		HURT:
			velocity = Vector2.ZERO
			
	

func _on_Hurtbox_area_entered(area):
	self.health-=area.get_parent().damage
func shoot():
	if state != DEAD:
		weapon.shoot(position + weapon.position, (Utils.player.global_position - position).normalized(), false)
		yield(get_tree().create_timer(0.2), "timeout")
	if state != DEAD:
		weapon.shoot(position + weapon.position, (Utils.player.global_position - position).normalized(), false)
		yield(get_tree().create_timer(0.2), "timeout")
	if state != DEAD:
		weapon.shoot(position + weapon.position, (Utils.player.global_position - position).normalized(), false)



func modulate():
	$Sprite.material.set("shader_param/active", false)
	if state != DEAD:
		state = IDLE

func die():
	stateMachine.travel("Death")
	.die()

func _on_Area2D_body_entered(body):
	player_near = true


func _on_Area2D_body_exited(body):
	player_near = false
