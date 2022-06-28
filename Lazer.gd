extends RayCast2D


var is_casting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	is_casting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cast_point = cast_to
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
	
	$Line2D.points[1] = cast_point
	#$Line2D.points[0] = 3 * Vector2(cos(get_local_mouse_position().angle()), sin(get_local_mouse_position().angle()))
	#$Start.position = 1 * Vector2(cos(get_local_mouse_position().angle()), sin(get_local_mouse_position().angle()))
	#$End.position = cast_point - 5 * Vector2(cos(position.x), sin(position.y))
	#$End.rotation = get_local_mouse_position().angle()

func _input(event):
	if Input.is_action_just_pressed("attack"):
		appear()
		set_process(true)
		
func appear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0.2, 5, 0.5, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
func disappear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0.2, 10, 0.5
	, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
