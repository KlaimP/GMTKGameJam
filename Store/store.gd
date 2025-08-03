extends Control

var money: int = 5 # кол-во денег

@export var inventory: Inventory # инвентарь

func _ready():
	update_currency_label()
	
	$Item1.pressed.connect(func(): buy_item(1, "carnifex", ResourceLoader.load("res://plants/types/carnifex.tres")))
	$Item2.pressed.connect(func(): buy_item(1, "item_name2", ResourceLoader.load("res://plants/types/cucold.tres")))
	$Item3.pressed.connect(func(): buy_item(1, "item_name3", ResourceLoader.load("res://plants/types/gib.tres")))
	
	$BackButton.pressed.connect(_on_back_pressed)

func buy_item(cost: int, item_name: String, type: PlantType):
	if money >= cost and inventory.inventory.size() != inventory.max_slots:
		money -= cost
		var plant: Card
		inventory.add_card(plant, type) # добавление карты (входные параметры в класс?)
		update_currency_label()

func update_currency_label():
	$MoneyLabel.text = "MONEY: " + str(money)

func _on_back_pressed():
	self.hide()
	$"../OpenStoreButton".show()

func _on_open_store_button_pressed() -> void:
	self.show()
	$"../OpenStoreButton".hide()
