extends Node2D

var height 
var exit = preload("res://Exit.tscn")
var width

var coords_x
var coords_y

var x1 = 0
var y1 = 0

var built = false

# Called when the node enters the scene tree for the first time.
func _init():
	randomize()
	width = randi()%15 + 10
	height = randi()%15 + 10
	add_to_group("rooms")
func spawn_exits():
		var directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
		directions.erase(Utils.player_movement * -1)
		for direction in directions:
			var instance = exit.instance() 
			match direction:
				Vector2.UP:
					instance.position = get_parent().map_to_world(Vector2(x1 + width/2,y1-5))
				Vector2.DOWN:
					instance.position = get_parent().map_to_world(Vector2(x1 + width/2,y1+height+10))
				Vector2.RIGHT:
					instance.position =  get_parent().map_to_world(Vector2(x1 + width+5,y1 + height/2+2))
				Vector2.LEFT:
					instance.position = get_parent().map_to_world(Vector2(x1-5,y1 + height/2+2))
			instance.direction = direction
			call_deferred("add_child", instance)

func disable_dark():
	#get_node("DarkArea").disable()
	pass
func enable_dark():
	#get_node("DarkArea").enable()
	#yield(get_tree().create_timer(1.5), "timeout")
	delete_tiles()
	for node in get_children():
		node.queue_free()

func delete_tiles():
	var maze = get_parent()
	var foreground = get_parent().get_node("Foreground")
	for i in range(x1, x1+ width+1):
		for j in range(y1, y1 + height+2):
			maze.set_cell(i, j, -1)
			foreground.set_cell(i, j, -1)
	
	"""for i in range(9):
		maze.set_cell(x1+width+1+i, (y1 + height)/2-1, -1)
		maze.set_cell(x1+width+1+i, (y1 + height)/2+3, -1)
	
	for i in range(8):
		maze.set_cell(x1-i-1, (y1 + height)/2-1, -1)
		maze.set_cell(x1-i-1, (y1 + height)/2+3, -1)
	for i in range(9):
		maze.set_cell((x1+width)/2-2, y1-1-i, -1)
		maze.set_cell((x1+width)/2-1, y1-1-i, -1)
		maze.set_cell((x1+width)/2, y1-1-i, -1)
		maze.set_cell((x1+width)/2+1, y1-1-i, -1)
		maze.set_cell((x1+width)/2+2, y1-1-i, -1)
	for i in range(9):
		maze.set_cell((x1+width)/2-2, y1+height+6+i, -1)
		maze.set_cell((x1+width)/2-1, y1+height+6+i, -1)
		maze.set_cell((x1+width)/2, y1+height+6+i, -1)
		maze.set_cell((x1+width)/2+1, y1+height+6+i, -1)
		maze.set_cell((x1+width)/2+2, y1+height+6+i, -1)"""
	built = false
func close_door():
	match Utils.player_movement:
		Vector2.UP:
			get_node("UpDoor").close()
		Vector2.DOWN:
			get_node("DownDoor").close()
		Vector2.RIGHT:
			get_node("RightDoor").close()
		Vector2.LEFT:
			get_node("LeftDoor").close()
func open_doors():
	get_tree().get_root().get_node("Maze/Player/Camera2D").shake(50)
	var list = []
	for elem in ["DownDoor", "UpDoor", "LeftDoor", "RightDoor"]:
		if has_node(elem):
			list.append(elem)
	match Utils.player_movement:
		Vector2.UP:
			get_node("DownDoor").open()
			list.erase("DownDoor")
			get_node(Utils.random_choice(list)).open()
		Vector2.DOWN:
			get_node("UpDoor").open()
			list.erase("UpDoor")
			get_node(Utils.random_choice(list)).open()
		Vector2.RIGHT:
			get_node("LeftDoor").open()
			list.erase("LeftDoor")
			get_node(Utils.random_choice(list)).open()
		Vector2.LEFT:
			get_node("RightDoor").open()
			list.erase("RightDoor")
			get_node(Utils.random_choice(list)).open()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
