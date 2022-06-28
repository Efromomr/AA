extends KinematicBody2D

export var ACCELERATION = 100
export var MAX_SPEED = 300
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4
export var damage = 1

enum {
	IDLE,
	RUN,
	HURT,
	DEAD,
	ATTACK,
	WANDER
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var deathTimer
var player_point

export var state = IDLE


onready var stats = $Stats
onready var hurtbox = $Hurtbox
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var stateMachine = animationTree.get("parameters/playback")
var player_direction

var rest_timer

func _ready():
	state = WANDER
	deathTimer = Timer.new()
	deathTimer.set_one_shot(true)
	deathTimer.set_wait_time(2)
	deathTimer.connect("timeout", self, "queue_free")
	add_child(deathTimer)
	
	rest_timer = Timer.new()
	rest_timer.set_one_shot(true)
	rest_timer.set_wait_time(3)
	rest_timer.connect("timeout", self, "rush")
	add_child(rest_timer)
	
	rest_timer.start()
	

func _physics_process(delta):
	knockback = move_and_collide(velocity*delta)
	match state:
		IDLE:
			stateMachine.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		DEAD:
			$Hurtbox/CollisionShape2D.disabled = true
			$Hitbox/CollisionShape2D.disabled = true
			$CollisionShape2D.disabled = true
			stateMachine.travel("Death")
			velocity = Vector2(0,0)
		WANDER:
			wanderController.start_wander_timer(0.1)
		RUN:
			stateMachine.travel("Run")
			#var collision = move_and_collide(velocity)
			if knockback and knockback.collider is TileMap:
				rest_timer.start()
				state = IDLE
				
				


func accelerate_towards_point(direction):
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	$Sprite.flip_h = (velocity.x < 0)

func rush():
	player_direction = global_position.direction_to(Utils.player.global_position)
	state = RUN
	accelerate_towards_point(player_direction)

func _on_Hurtbox_area_entered(area):
	if (stats.health - area.get_parent().damage > 0):
		hurt()
	elif state != DEAD:
		state = DEAD
			
			
	stats.health -= area.get_parent().damage
	#knockback = area.get_parent().knockback_vector * 150


	
func hurt():
	pass
