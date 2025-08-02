extends Sprite2D

var wetness : float = 0. # влажность
var capacity : int = 1 # вместимость
var coef_of_minerals : float = 0. # коэффициент минералов

var up_tile: Sprite2D = self

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	Events.plant.emit(up_tile)
