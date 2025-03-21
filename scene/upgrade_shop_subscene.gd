extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Database.maxLevelReached <= 10:
		$MarginContainer/VBoxContainer/stage2.modulate = Color("B50000")
	if Database.maxLevelReached <= 50:
		$MarginContainer/VBoxContainer/stage3.modulate = Color("B50000")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")


func _on_stage_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/upgrade_shop.tscn")


func _on_stage_2_pressed() -> void:
	if Database.maxLevelReached > 10:
		get_tree().change_scene_to_file("res://scene/upgrade_shop_stage2.tscn")
	else:
		$MarginContainer/VBoxContainer/Label.text = "Complete wave 10 to unlock"
		$unableBuy.play()


func _on_stage_3_pressed() -> void:
	if Database.maxLevelReached > 50:
		get_tree().change_scene_to_file("res://scene/upgrade_shop_stage3.tscn")
	else:
		$MarginContainer/VBoxContainer/Label.text = "Complete wave 50 to unlock"
		$unableBuy.play()
