extends Container

@export var radius: float = 200.
@export var start_angle: float = -180.
@export var arc_angle: float = 180.

func _notification(what: int) -> void:
	if (what == NOTIFICATION_SORT_CHILDREN):
		_arrange_children()

func _arrange_children():
	var count = get_child_count()
	if (count == 0):
		return
	
	var center = size * 0.5
	for i in range(count):
		var child = get_child(i) as Control
		var t : float = 0
		if (count > 1):
			t = float(i) / (count - 1)
		else:
			t = 0.5
		var angle = deg_to_rad(start_angle + t * arc_angle)
		var offset = Vector2(cos(angle), sin(angle)) * radius
		child.position = center + offset - child.size * 0.5
