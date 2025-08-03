extends Control

class_name Inventory

@export var inventory: Array[Card]
@export var card_slot: PackedScene
@export var max_slots: int

func add_card(card: Card):
	if (inventory.size() >= max_slots):
		return
	var slot = card_slot.instantiate()
	slot.itemName = "Bebebe"
	var plant: Plant
	
	slot.plant = plant
	inventory.append(slot)
	$BoxContainer/VBoxContainer.add_child(slot)
