extends Control

class_name Inventory

@export var inventory: Array[Card]
@export var card_slot: PackedScene
@export var max_slots: int

func _on_button_button_down() -> void:
	if (inventory.size() >= max_slots):
		return
	var slot = card_slot.instantiate()
	slot.itemName = "Bebebe"
	inventory.append(slot)
	$BoxContainer/VBoxContainer.add_child(slot)
