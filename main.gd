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
	if t < 0.:
		day_time += speed * d * delta
	else:
		day_time += speed * n * delta
	if day_time > 1.:
		day_time = -1.
		Events.day_ends.emit()
	
	var color = lerp(Color.WHITE, night_color, day_time) if day_time >= 0. else lerp(night_color, Color.WHITE, 1.+day_time)
	
	%Weather.update(day_time, cloudiness, delta)

func _on_day_ratio_value_changed(value: float) -> void:
	ratio = value

func _on_cloudiness_value_changed(value: float) -> void:
	cloudiness = value
