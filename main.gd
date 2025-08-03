extends Node2D

@export var night_color: Color
@export var day_color: Color

var day_time: float = 0.
var speed: float = 0.1

var cloudiness: float = 0.5

var ratio: float = 0.

func _process(delta: float) -> void:
	var t = abs(day_time) - 0.5
	var d = 1.775 * pow(ratio, 2) + 2.225 * ratio + 1.0
	var n = 1.775 * pow(ratio, 2) - 2.225 * ratio + 1.0
	day_time += speed * delta * lerp(d, n, smoothstep(-1., 1., -(abs(day_time) - 0.5) * 2.))
	
	if day_time > 1.:
		day_time = -1.
		Events.day_ends.emit()
	
	var color = lerp(Color.WHITE, night_color, day_time) if day_time >= 0. else lerp(night_color, Color.WHITE, 1.+day_time)
	
	%Weather.update(day_time, cloudiness, delta)


func _on_day_ratio_value_changed(value: float) -> void:
	ratio = value

func _on_cloudiness_value_changed(value: float) -> void:
	cloudiness = value

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
