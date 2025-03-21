extends Node
@onready var pause_panel: Panel = %pausePanel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var esc_pressed = Input.is_action_just_pressed("pause")
	if (esc_pressed == true):
		get_tree().paused = true
		pause_panel.show()

# continue run
func _on_button_pressed() -> void:
	pause_panel.hide()
	get_tree().paused = false

# end run
func _on_button_2_pressed() -> void:
	pause_panel.hide()
	# saves players highest run
	if Database.level > Database.maxLevelReached:
		Database.maxLevelReached = Database.level
	Database.gameOverReset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
