extends Enemy


func _init():
	ACCELERATION = 100
	MAX_SPEED = 100
	FRICTION = 200
	damage = 1
	health = 10

var attack_timer
var player_pos
var mouse_pos = Vector2.ZERO
var player_near = false
var knockback_vector = Vector2(10,10)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('enemies')
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = to_local(Utils.player.position)
	if health <= 0:
		state = DEAD 

	velocity = move_and_slide(velocity)
	match state:

		RUN:
			accelerate_towards_point(global_position.direction_to(Utils.player.global_position))
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



func modulate():
	$Sprite.material.set("shader_param/active", false)
	if state != DEAD:
		state = IDLE

func _on_Area2D_body_entered(body):
	player_near = true


func _on_Area2D_body_exited(body):
	player_near = false
