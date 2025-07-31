extends Node2D

enum stages {
	SEED,
	SPROUT,
	PLANT
}

var stage: stages

var speed: float = 0.25

var parent

var energy: float
var water: float
var growth: float

@export var seed_texture: Texture2D
@export var sprout_texture: Texture2D
@export var plant_texture: Texture2D



func _ready() -> void:
	stage = stages.SEED
	%Sprite.texture = seed_texture



func update(day_time: float, moisture: float, delta: float):
	var is_day: bool = (abs(day_time) - 0.5) < 0.
	match stage:
		stages.SEED:
			growth += moisture * speed * delta
		stages.SPROUT:
			if is_day:
				energy += speed * delta
			else:
				growth += (moisture * 0.1 + 0. if energy <= 0. else (energy * 0.5)) * speed * delta
				energy -= speed * delta * 0.5
		stages.PLANT:
			if is_day:
				energy += speed * delta
			else:
				growth += (moisture * 0.05 + 0. if energy <= 0. else energy) * speed * delta
				energy -= speed * delta * 0.8
	
	if growth > 1.:
		growth = 0.
		match stage:
			stages.SEED:
				stage = stages.SPROUT
				%Sprite.texture = sprout_texture
			stages.SPROUT:
				stage = stages.PLANT
				%Sprite.texture = plant_texture
			stages.PLANT:
				parent.delete(self)
	
	%Growth.text = str(snapped(growth, 0.1))
	%Energy.text = str(snapped(energy, 0.01))
