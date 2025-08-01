extends Node2D

#@export var tile_texture := preload("res://soil/soil texture.jpg")
@export var tile_size := Vector2(86, 86)
@export var grid_width : int = 8
@export var grid_height : int = 4
########################################
#var wetness : float = 0.
#var capacity : int = 1
#var coef_of_minerals : float = 0.

#var grid : Array [Vector2]
#var grid : Array [Sprite2D]
var grid : Array [Array]
########################################

func _ready():
	create_tile_grid()
	#badass()

func create_tile_grid():
	for y in grid_height:
		var row : Array [Sprite2D]
		for x in grid_width:
			var tile := Sprite2D.new()
			tile.texture = preload("res://soil/soil texture small.jpg")
			tile.position = Vector2(x, y) * tile_size
			tile.set_meta("wetness", randf_range(0.1, 1))
			tile.set_meta("capacity", 1)
			tile.set_meta("coef_of_minerals", randf_range(0.1, 1))
			#grid.append(Vector2(tile.x, tile.y))
			#grid.append(tile)
			row.append(tile)
			add_child(tile)
		grid.append(row)

#func badass():
	#for x in 32:
			#print(grid[x].get_meta("wetness"))
			#print(grid[x].get_meta("capacity"))
			#print(grid[x].get_meta("coef_of_minerals"))

#func badass():
	#for y in grid_height:
		#for x in grid_width:
			#print(grid[y][x].get_meta("wetness"))
			#print(grid[y][x].get_meta("capacity"))
			#print(grid[y][x].get_meta("coef_of_minerals"))
