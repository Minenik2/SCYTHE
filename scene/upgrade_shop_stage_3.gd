extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Database.finalPactOwned:
		$VBoxContainer/descriptionCost.text = "Souls Owned: " + str(Database.return_player_totalKills()) + " Souls Cost: " + str(Database.finalPactCost)
	else:
		$VBoxContainer/descriptionCost.text = "1/1"

func _on_fate_pressed() -> void:
	if Database.return_player_totalKills() >= Database.finalPactCost && !Database.finalPactOwned:
		$buy.play()
		Database.player_totalKills -= Database.finalPactCost
		Database.finalPactOwned = true
		$VBoxContainer/descriptionCost.text = "1/1"
	else:
		$unableBuy.play()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/upgrade_shop_subscene.tscn")
