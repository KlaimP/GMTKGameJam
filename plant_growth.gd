extends Node2D

@export var growth_textures : Array[Texture2D] 
@export var speed : float = 0.1
@export var weather_factor: float = 1.
@export var moisture_factor: float = 1.
@export var energy_conservation: float = 0.5
@export var is_day_plant: bool

var is_day: bool

var stage : int = 0
var growth: float
var energy: float
var water: float

func _ready() -> void:
	$Texture.texture = growth_textures[0]


func _process(delta: float) -> void:
	if (is_day == is_day_plant):
		if (stage == 0):
			growth += speed * moisture_factor * delta
		else:
			growth += speed * weather_factor * moisture_factor * delta
			energy += speed * energy_conservation
	else:
		if (energy > 0):
			growth += speed * weather_factor * moisture_factor * delta
			energy -= speed
	
	if (growth >= 1):
		growth = 0
		stage += 1
		if (stage < growth_textures.size()):
			$Texture.texture = growth_textures[stage]
		else:
			pass
