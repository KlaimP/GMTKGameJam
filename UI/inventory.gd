extends Control

class_name Inventory

@export var inventory: Array[Card]
@export var card_slot: PackedScene

func _on_button_button_down() -> void:
	var slot = card_slot.instantiate()
	slot.itemName = "Bebebe"
	inventory.append(slot)
	$BoxContainer/HBoxContainer.add_child(slot)
