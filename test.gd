extends Node2D


var day_time: float = 0.
var speed: float = 0.1


var percent: float = 1.

@export var night_color: Color
@export var day_color: Color



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right"):
		if percent >= 1.:
			percent += 0.5
		else:
			percent += 0.1
		if percent > 5.0:
			percent = 5.0
	if event.is_action_pressed("left"):
		if percent > 1.:
			percent -= 0.5
		else:
			percent -= 0.1
		if percent < 0.1:
			percent = 0.1


func _process(delta: float) -> void:
	day_time += speed * percent * delta
	if day_time > 1.:
		day_time = -1.
	
	var color = lerp(Color.WHITE, night_color, day_time) if day_time >= 0. else lerp(night_color, Color.WHITE, 1.+day_time)
	%Sky.modulate = color
	%Grass.modulate = color
	%Soil.modulate = color
	
	%Time.text = str(snapped(day_time, 0.01))
	%Speed.text = str(snapped(percent, 0.01))
