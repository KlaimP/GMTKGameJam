extends Node2D

###########################################################
@export_category("Plant Properties")
@export var growth_textures : Array[Texture2D] # Текстуры растений (Количество текстур = количеству стадий)
@export var speed : float = 0.1 # Скорость роста
@export var optimal_moisture: Vector2 = Vector2(0.4, 0.7) # Оптимальная влажность почвы, при котором растение растет
@export var energy_conservation: float = 0.5 # Сколько энергии оно собирает
@export var required_water : float = 0.05 # Сколько воды нужно растению
@export var absorption_rate: float = 0.1 # Сколько воды оно собирает
@export var max_water: float = 1. # Максимальное количество собранной воды
@export var is_day_plant: bool = true # Дневное ли это растение


###########################################################
@export_category("Plant state")
@export var stage : int = 0 # Стадия роста
@export var growth: float = 0. # Рост
@export var energy: float = 0. # Энергия
@export var water: float = 0. # Вода
 
###########################################################
@export_category("External var")
@export var weather_factor: float = 1. # Фактор погоды
@export var soil_moisture: float = 0.0  # Влажность почвы
@export var is_day: bool = true # День или ночь

###########################################################
var can_grow: bool = true # Может ли расти растение

func _ready() -> void:
	$Texture.texture = growth_textures[0]


func _process(delta: float) -> void:
	if (can_grow):
		process_growth(delta)

func absorb_water(delta: float) -> void:
	water += absorption_rate * delta
	water = clamp(water, 0.0, max_water + max_water * 0.25)

func die():
	can_grow = false

func suitable_moisture() -> bool:
	return soil_moisture >= optimal_moisture.x && soil_moisture <= optimal_moisture.y

func drink_water() -> void:
	water -= required_water
	if (water < 0):
		die()

func process_growth(delta: float) -> void:
	if ((is_day == is_day_plant) && can_grow):
		if(suitable_moisture()):
			if (stage == 0):
				growth += speed * weather_factor * delta
				absorb_water(delta)
				drink_water()
			else:
				growth += speed * weather_factor * delta
				energy += speed * energy_conservation
				absorb_water(delta)
				drink_water()
	else:
		if (energy > 0):
			growth += speed * weather_factor * delta
			energy -= speed
			drink_water()
	
	if (growth >= 1):
		growth = 0
		stage += 1
		if (stage < growth_textures.size()):
			$Texture.texture = growth_textures[stage]
		else:
			die()
