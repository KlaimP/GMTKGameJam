extends Node2D

@export var selected_card: Panel
@export var where_plant: Node
@export var weather: Node

func _ready() -> void:
	Events.plant.connect(_plant)

func _plant(tile : Sprite2D):
	#var plant = selected_card.plant.instantiate()
	if selected_card == null:
		return
	selected_card.plant.position = tile.position
	selected_card.plant.where_plant = tile
	selected_card.plant.weather = weather
	where_plant.add_child(selected_card.plant)
	selected_card.queue_free()
	selected_card = null
