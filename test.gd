extends Node2D


var day_time: float = 0.
var speed: float = 0.1

var cloudiness: float = 0.5

var ratio: float = 0.

@export var night_color: Color
@export var day_color: Color

@export var tree: PackedScene

var plants: Array


var is_in_box: bool = false




func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if is_in_box:
			var pos = get_global_mouse_position()
			var new = tree.instantiate()
			%Plants.add_child(new)
			new.position = Vector2(pos.x, 0)
			plants.append(new)
			new.parent = self




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
	
	var color = lerp(Color.WHITE, night_color, day_time) if day_time >= 0. else lerp(night_color, Color.WHITE, 1.+day_time)
	
	for p in plants:
		p.update(day_time, 0.5, delta)
	
	%Weather.update(day_time, cloudiness, delta)
	
	%Grass.modulate = color
	%Soil.modulate = color
	



func delete(obj: Node2D):
	plants.erase(obj)
	obj.queue_free()


func _on_area_2d_mouse_entered() -> void:
	is_in_box = true

func _on_area_2d_mouse_exited() -> void:
	is_in_box = false


func _on_day_ratio_value_changed(value: float) -> void:
	ratio = value

func _on_cloudiness_value_changed(value: float) -> void:
	cloudiness = value
