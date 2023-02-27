extends Node2D

var xc
var yc
var r
var matrix = []
func drawCircle(xc, yc, x, y):
	matrix[xc+x][yc+y] = 1
	matrix[xc-x][yc+y] = 1
	matrix[xc+x][yc-y] = 1
	matrix[xc-x][yc-y] = 1
	matrix[xc+y][yc+x] = 1
	matrix[xc-y][yc+x] = 1
	matrix[xc+y][yc-x] = 1
	matrix[xc-y][yc-x] = 1
 

func circleBres(xc, yc, r):
	var x = 0
	var y = r
	var d = 3 - 2 * r
	drawCircle(xc, yc, x, y)
	while (y >= x):
		 
		x+=1
 
		if (d > 0):
			y-=1
			d = d + 4 * (x - y) + 10
		else:
			d = d + 4 * x + 6
		drawCircle(xc, yc, x, y)
		
	#create_tiles()
	
func create_tiles():
	for x in range((r+xc)*2):     
		for y in range((r+yc)*2):
			if matrix[x][y] == 1:
				$TileMap.set_cell(x, y, 0)
 
 
func _ready():

	xc = 5
	yc = 5
	r = 5
	for x in range((r+xc)*2):
		matrix.append([])
		matrix[x]=[]        
		for y in range((r+yc)*2):
			matrix[x].append([])
			matrix[x][y]=0
	circleBres(xc, yc, r)
