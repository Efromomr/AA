extends Node2D

var height 
var exit = preload("res://Tiles/Exit.tscn")
var width

var coords_x
var coords_y

var x1 = 0
var y1 = 0

var built = false

var rng = RandomNumberGenerator.new()

var foreground
var tiles = []
var enemies = []

# Called when the node enters the scene tree for the first time.
func _init():
	randomize()
	width = 13 + randi()%8
	height = 13 +  randi()%8
	add_to_group("rooms")
	

func _ready():
	foreground = get_parent().get_node("YSort/Foreground")
	
func spawn_painting():
	rng.randomize()
	tiles.append([Vector2(rng.randi_range(2, width/2-5), 2), rng.randi_range(5,7)])
func generate_doors():
	tiles.append([Vector2(0, height/2), Utils.random_choice([1,13])])
	tiles.append([Vector2(width, height/2), Utils.random_choice([4,14])])
	tiles.append([Vector2(width/2-1, 0), Utils.random_choice([2,11])])
	tiles.append([Vector2(width/2-1, height), Utils.random_choice([3,12])])
func generate_individual_tiles():
	for i in range(2, width/2, 2):
		tiles.append([Vector2(i,5), 8])
func generate_enemies():
	enemies.append([Utils.random_choice(["Knight1", "Knight2", "Knight3"]), Vector2(150,150)])
func spawn_enemies():
	for enemy in enemies:
		Utils.spawn_enemy(enemy[0], self, enemy[1])
func spawn_individual_tiles():
	for tile in tiles:
		foreground.set_cellv(Vector2(x1,y1)+tile[0], tile[1])
func delete_individual_tiles():
	for tile in tiles:
		foreground.set_cellv(Vector2(x1,y1)+tile[0],-1)
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
					instance.position =  get_parent().map_to_world(Vector2(x1 + width+5,y1 + height/2))
				Vector2.LEFT:
					instance.position = get_parent().map_to_world(Vector2(x1-5,y1 + height/2))
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
	for i in range(x1, x1+ width+1):
		for j in range(y1, y1 + height+2):
			maze.set_cell(i, j, -1)
			foreground.set_cell(i, j, -1)
	#if Utils.player_movement != Vector2.RIGHT:
	for i in range(8):
		maze.set_cell(x1+width+1+i, (y1 + y1 + height)/2-1, -1)
		maze.set_cell(x1+width+1+i, (y1 + y1 + height)/2+3, -1)
	#if Utils.player_movement != Vector2.LEFT:
	for i in range(8):
		maze.set_cell(x1-i-1, (y1 + y1 + height)/2-1, -1)
		maze.set_cell(x1-i-1, (y1 + y1 + height)/2+3, -1)
	#if Utils.player_movement != Vector2.UP:
	for i in range(9):
		maze.set_cell((x1+x1+width)/2-2, y1-1-i, -1)
		maze.set_cell((x1+x1+width)/2-1, y1-1-i, -1)
		maze.set_cell((x1+x1+width)/2, y1-1-i, -1)
		maze.set_cell((x1+x1+width)/2+1, y1-1-i, -1)
		maze.set_cell((x1+x1+width)/2+2, y1-1-i, -1)
	#if Utils.player_movement != Vector2.DOWN:
	for i in range(9):
		maze.set_cell((x1+x1+width)/2-2, y1+height+6+i, -1)
		maze.set_cell((x1+x1+width)/2-1, y1+height+6+i, -1)
		maze.set_cell((x1+x1+width)/2, y1+height+6+i, -1)
		maze.set_cell((x1+x1+width)/2+1, y1+height+6+i, -1)
		maze.set_cell((x1+x1+width)/2+2, y1+height+6+i, -1)
		
	for i in range(7):
		maze.set_cell(x1+width/2-1, y1+6-i, -1)
		maze.set_cell(x1+width/2, y1+6-i, -1)
		maze.set_cell(x1+width/2+1, y1+6-i, -1)
		
	for i in range(6):
		maze.set_cell(x1+width/2-1, y1+height+i, -1)
		maze.set_cell(x1+width/2, y1+height+i, -1)
		maze.set_cell(x1+width/2+1, y1+height+i, -1)
	built = false
	delete_individual_tiles()
func close_door():
	var list = []
	for elem in ["DownDoor", "UpDoor", "LeftDoor", "RightDoor"]:
		if has_node(elem):
			list.append(elem)
	match Utils.player_movement:
		Vector2.UP:
			list.erase("UpDoor")
		Vector2.DOWN:
			list.erase("DownDoor")
		Vector2.RIGHT:
			list.erase("RightDoor")
		Vector2.LEFT:
			list.erase("LeftDoor")
	for elem in list:
		get_node(elem).close()
func open_doors():
	get_tree().get_root().get_node("Maze/Camera2D").shake(100)
	var list = []
	for elem in ["DownDoor", "UpDoor", "LeftDoor", "RightDoor"]:
		if has_node(elem):
			list.append(elem)
	match Utils.player_movement:
		Vector2.UP:
			get_node("DownDoor").open()
			list.erase("DownDoor")
		Vector2.DOWN:
			get_node("UpDoor").open()
			list.erase("UpDoor")
		Vector2.RIGHT:
			get_node("LeftDoor").open()
			list.erase("LeftDoor")
		Vector2.LEFT:
			get_node("RightDoor").open()
			list.erase("RightDoor")
	var rand_door = Utils.random_choice(list)
	get_node(rand_door).open()
	list.erase(rand_door)
	if randi()%2 == 0 and len(list) > 0:
		rand_door = Utils.random_choice(list)
		get_node(rand_door).open()
		list.erase(rand_door)
		if randi()%2 == 0 and len(list) > 0:
			rand_door = Utils.random_choice(list)
			get_node(rand_door).open()
			list.erase(rand_door)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
