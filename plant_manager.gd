extends Node2D

@export var selected_card: Panel
@export var where_plant: Node

func _ready() -> void:
	Events.plant.connect(_plant)

func _plant(tile : Sprite2D):
	#var plant = selected_card.plant.instantiate()
	selected_card.plant.position = tile.position
	selected_card.plant.where_plant = tile
	where_plant.add_child(selected_card.plant)
