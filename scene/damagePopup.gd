extends Label

@export var float_duration: float = 0.3  # How long the popup lasts
@export var float_distance: float = 50  # How far the text moves upward
var start_position: Vector2

func _ready() -> void:
	start_position = position
	animate_popup()

func animate_popup() -> void:
	# Animate the text floating upward and fading out
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", start_position + Vector2(0, -float_distance), float_duration)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), float_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.connect("finished", Callable(self, "_on_animation_finished"))

func _on_animation_finished() -> void:
	queue_free()  # Remove the popup after the animation ends
