extends Control

var money: int = 5 # кол-во денег

var purchases: Array [Card] # массив карт

func _ready():
	update_currency_label()

	$Item1.pressed.connect(func(): buy_item(1, "item_name1"))
	$Item2.pressed.connect(func(): buy_item(1, "item_name1"))
	$Item3.pressed.connect(func(): buy_item(1, "item_name1"))

	$BackButton.pressed.connect(_on_back_pressed)

func buy_item(cost: int, item_name: String):
	if money >= cost:
		money -= cost
		var plant: Card
		purchases.append(plant) # добавление карты (входные параметры в класс?)
		update_currency_label()

func update_currency_label():
	$MoneyLabel.text = "MONEY: " + str(money)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
