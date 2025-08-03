extends Control

class_name Inventory

@export var inventory: Array[Card]
@export var card_slot: PackedScene
@export var max_slots: int
@export var plants: PackedScene
@export var plantManager: Node2D

func add_card(card: Card, type_plant: PlantType):
	if (inventory.size() >= max_slots):
		return
	var slot = card_slot.instantiate()
	var plant = plants.instantiate()
	plant.set_type(type_plant)
	
	slot.itemName = "Bebebe"
	slot.plant = plant
	slot.plantManager = plantManager
	inventory.append(slot)
	$BoxContainer/VBoxContainer.add_child(slot)
