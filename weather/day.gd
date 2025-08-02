extends Area2D

var choosed: bool = false
var day: int
var weather: int

@export var sprites: Array[Texture2D]



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if choosed:
			Events.choosed_day.emit(day)

func set_weather(w: int):
	weather = w
	if sprites.size() > w:
		$Sprite2D.texture = sprites[w]


func _on_mouse_entered() -> void:
	choosed = true


func _on_mouse_exited() -> void:
	choosed = false
