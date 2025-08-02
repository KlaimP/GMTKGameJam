extends Node2D

@export var tile_texture : Texture2D
@export var tile_size := Vector2(86, 86) # размер тайла
@export var grid_width : int = 16 # длина
@export var grid_height : int = 4 # ширина
########################################
@export var tile : PackedScene
var grid : Array [Array] # матрица тайлов
########################################

func _ready():
	create_tile_grid()

func create_tile_grid():
	for y in grid_height:
		var row : Array [Sprite2D]
		for x in grid_width:
			var tile := tile.instantiate()
			tile.texture = tile_texture
			tile.modulate = Color(0.1, 0.1, 0.1) * (grid_height - y)
			tile.position = Vector2(x, y) * tile_size
			tile.wetness = randf_range(0.1, 1)
			tile.capacity = 1
			tile.coef_of_minerals = randf_range(0.1, 1)
			if (y>0):
				tile.up_tile = grid[0][x]
			row.append(tile)
			add_child(tile)
		grid.append(row)
