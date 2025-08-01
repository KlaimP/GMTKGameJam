extends Node2D

###########################################################
@export_group("Plant Properties")
@export var growth_textures : Array[Texture2D] # Текстуры растений (Количество текстур = количеству стадий)
@export var growth_stage_duration: Array[float] # Сколько времени занимает каждый этап роста
@export var speed : float = 0.1 # Скорость роста
@export var optimal_moisture: Vector2 = Vector2(0.4, 0.7) # Оптимальная влажность почвы, при котором растение растет
@export var energy_conservation: float = 0.1 # Сколько энергии оно собирает
@export var required_water : float = 0.05 # Сколько воды нужно растению
@export var absorption_rate: float = 0.1 # Сколько воды оно собирает
@export var max_water: float = 1. # Максимальное количество собранной воды
@export var is_day_plant: bool = true # Дневное ли это растение
@export var max_health: int = 30 # Максимальное количество жизни у растения
@export var like_rain : float = 1. # Насколько растение любит дождь

###########################################################
@export_group("Spatial")
@export var size: Array[Vector2i] # Размер растения на разных стадиях (Без учета надземной части)
@export var coordinate: Vector2i = Vector2i(0,0) # На каком тайле земли находится растение

###########################################################
@export_group("Buffs and Points")
@export var score_value: Array[int] # Количество получаемых очков на каждом этапе

###########################################################
@export_group("Plant state")
@export var stage : int = 0 # Стадия роста
@export var growth: float = 0. # Рост
@export var energy: float = 0. # Энергия
@export var water: float = 0. # Вода
@export var health: float = max_health # Количествно жизни
 
###########################################################
@export_group("External var")
@export var weather_factor: float = 1. # Фактор погоды
@export var soil_moisture: float = 0.5  # Влажность почвы
@export var is_day: bool = true # День или ночь
@export var is_rain: bool = false # Идет ли дождь
@export var growth_boosters: float = 1. # Бустер от удобрений

###########################################################
var can_grow: bool = true # Может ли расти растение
var dying_water: bool = false # Умирает ли растение от недостатка воды
var dying_growth: bool = false # Умирает ли растение от старости
var is_dormant: bool = false # Спячка у растения


func _ready() -> void:
	$Texture.texture = growth_textures[0]
	size.resize(growth_textures.size())

func _process(delta: float) -> void:
	if (can_grow):
		process_growth(delta)
	die_process(delta)

func absorb_water(delta: float) -> void:
	water += absorption_rate * delta
	water = clamp(water, 0.0, max_water + max_water * 0.25)

func die_process(delta: float) -> void:
	if (health <= 0):
		pass
	
	if (dying_water || dying_growth):
		health -= 1 * delta
	else:
		health += 1 * delta
		if (health > max_health):
			health = max_health

func suitable_moisture() -> bool:
	return soil_moisture >= optimal_moisture.x && soil_moisture <= optimal_moisture.y

func drink_water(delta: float) -> void:
	water -= required_water * delta
	if (water < 0):
		water = 0
		dying_water = true
	else: 
		dying_water = false

func process_growth(delta: float) -> void:
	if (is_day == is_day_plant):
		if (stage == 0):
			growth += speed * weather_factor * growth_boosters * delta
			if(suitable_moisture()):
				absorb_water(delta)
			drink_water(delta)
		else:
			growth += speed * weather_factor * growth_boosters / 2 * delta
			energy += energy_conservation * delta
			if(suitable_moisture()):
				absorb_water(delta)
			drink_water(delta)
	else:
		if (energy > 0):
			growth += speed * weather_factor * growth_boosters * delta
			energy -= speed * delta
			if(suitable_moisture()):
				absorb_water(delta)
			drink_water(delta)
	
	if (growth >= growth_stage_duration[stage]):
		growth = 0
		stage += 1
		if (stage < growth_textures.size()):
			$Texture.texture = growth_textures[stage]
		else:
			can_grow = false
			dying_growth = true

func give_score() -> int:
	if (stage > score_value.size()):
		return score_value.back()
	return score_value[stage]
