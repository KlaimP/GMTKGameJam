extends Node2D

@export var selected_card: PackedScene
@export var where_plant: Node

func _ready() -> void:
	Events.plant.connect(_plant)

func _plant(tile : Sprite2D):
	var plant = selected_card.instantiate()
	plant.position = tile.position
	plant.where_plant = tile
	where_plant.add_child(plant)
