extends Panel

class_name Card

@export var itemName: String = "Default"
@export var texture: Texture2D

@export var hover_scale: Vector2 = Vector2.ONE * 1.2  # Во сколько раз увеличиваем
@export var anim_duration: float = 0.1                # Время анимации
@export var plant: Plant

var _orig_scale: Vector2
var _tween: Tween

func _ready():
	$Sprite.texture = plant.growth_textures.back()
	_orig_scale = scale
	_tween = create_tween()

func _on_mouse_entered():
	_tween.kill()
	z_index = 1
	_tween = create_tween()
	_tween.tween_property(self, "scale", hover_scale, anim_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_mouse_exited():
	_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "scale", _orig_scale, anim_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_tween.connect("finished", Callable(self, "_on_tween_finished"))

func _on_tween_finished():
	z_index = 0
