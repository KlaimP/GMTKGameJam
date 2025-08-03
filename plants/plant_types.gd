extends Resource
class_name PlantType

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
