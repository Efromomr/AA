extends Node2D

class_name Maze_room

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

var torch = preload("res://Tiles/Torch.tscn")
var pedestal = preload("res://Tiles/Pedestal.tscn")
var wooden_box = preload('res://Tiles/Box.tscn')
var carton_box = preload('res://Tiles/Box.tscn')
var tile_scenes = {0:torch, 8:wooden_box, 9:carton_box, 15:pedestal}

var proj_deleter = preload("res://Projectiles/ProjDeleter.tscn")
var enemies_deleter = preload("res://EnemiesDeleter.tscn")

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
		tiles.append([Vector2(i,5), 9])
	for i in range(2, width/2, 2):
		tiles.append([Vector2(i,3), 0])
	#tiles.append([Vector2(1,6), 15])
func generate_enemies():
	enemies.append([Utils.random_choice(["Knight1", "Knight2", "Knight3"]), Vector2(150,150)])
func spawn_enemies():
	for enemy in enemies:
		Utils.spawn_enemy(enemy[0], self, enemy[1])
		enemies.erase(enemy)
func spawn_individual_tiles():
	for tile in tiles:
		foreground.set_cellv(Vector2(x1,y1)+tile[0], tile[1])
		if tile_scenes.has(tile[1]):
			var tile_instance = tile_scenes[tile[1]].instance()
			tile_instance.position = foreground.map_to_world(Vector2(x1,y1)+tile[0])
			tile_instance.tile = tile[0]
			call_deferred("add_child", tile_instance)
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
	delete_projectiles()
	delete_enemies()
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
		maze.set_cell((x1+x1+width)/2-1, y1-1-i, -1)
		maze.set_cell((x1+x1+width)/2, y1-1-i, -1)
		maze.set_cell((x1+x1+width)/2+1, y1-1-i, -1)
	for i in range(14):
		maze.set_cell((x1+x1+width)/2-2, y1-1-i, -1)
		maze.set_cell((x1+x1+width)/2+2, y1-1-i, -1)
	if maze.get_cell((x1+x1+width)/2-2, y1-15) != -1:
		maze.set_cell((x1+x1+width)/2-2, y1-1-13, 16)
		maze.set_cell((x1+x1+width)/2+2, y1-1-13, 16)
		
	#ya dolboed
	for i in range(6):
		maze.set_cell((x1+x1+width)/2-2, y1+height+i, -1)
		maze.set_cell((x1+x1+width)/2+2, y1+height+i, -1)
		
		
	#if Utils.player_movement != Vector2.DOWN:
	for i in range(9):
		maze.set_cell((x1+x1+width)/2-2, y1+height+6+i, -1)
		maze.set_cell((x1+x1+width)/2-1, y1+height+6+i, -1)
		maze.set_cell((x1+x1+width)/2, y1+height+6+i, -1)
		maze.set_cell((x1+x1+width)/2+1, y1+height+6+i, -1)
		maze.set_cell((x1+x1+width)/2+2, y1+height+6+i, -1)
		
	#floor cleaning
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
func delete_projectiles():
	var instance = proj_deleter.instance()
	instance.position = foreground.map_to_world(Vector2(x1, y1))
	instance.get_node("CollisionShape2D").position = Vector2(16*(width/2), 12*(height/2))
	instance.get_node("CollisionShape2D").scale = Vector2((width+16)/2, (height+18)/2)
	call_deferred("add_child", instance)
	
	"""var instance_2 = proj_deleter.instance()
	instance_2.position = foreground.map_to_world(Vector2(x1+width, y1))
	instance_2.get_node("CollisionShape2D").position = Vector2(8*(width+4), 12*height/2)
	instance_2.get_node("CollisionShape2D").scale = Vector2(10, 2)
	call_deferred("add_child", instance_2)"""
	
	
func delete_enemies():
	var instance = enemies_deleter.instance()
	instance.position = foreground.map_to_world(Vector2(x1, y1))
	instance.get_node("CollisionShape2D").position = Vector2(16*(width/2), 12*(height/2))
	instance.get_node("CollisionShape2D").scale = Vector2(width/2, height/2)
	call_deferred("add_child", instance)
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
