extends Control

@onready var description: Label = $MarginContainer/VBoxContainer/description
@onready var description_player: Label = $MarginContainer/VBoxContainer/descriptionPlayer
@onready var cost: Label = $MarginContainer/VBoxContainer/descriptionCost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func showPlayerWevemaster():
	description.text = "Start at wave " + str(Database.spawnAtWave + 5)
	description_player.text = "Currently start at wave: " + str(Database.spawnAtWave) + " " + str(Database.upgradeWavemasterOwned) + "/8"
	cost.text = "Souls Owned: " + str(Database.return_player_totalKills()) + " Souls Cost: " + str(Database.upgradeWavemasterCost)
	
func showPlayerSoulhunter():
	description.text = "Doubles souls gained in run"
	description_player.text = "Each kill gives " + str(Database.soulGained) + " souls " + str(Database.UpgradeSoulhunterOwned) + "/1"
	cost.text = "Souls Owned: " + str(Database.return_player_totalKills()) + " Souls Cost: " + str(Database.upgradeSoulhunterCost)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/upgrade_shop_subscene.tscn")


func _on_wavemaster_mouse_entered() -> void:
	showPlayerWevemaster()
	description.modulate = Color("white")


func _on_soulhunter_mouse_entered() -> void:
	showPlayerSoulhunter()
	description.modulate = Color("white")


func _on_wavemaster_pressed() -> void:
	if Database.maxLevelReached < Database.spawnAtWave + 16:
		$unableBuy.play()
		description.text = "Must complete wave: " + str(Database.spawnAtWave + 16)
		description.modulate = Color("B50000")
	elif Database.return_player_totalKills() >= Database.upgradeWavemasterCost && Database.upgradeWavemasterOwned < 8:
		$buy.play()
		Database.player_totalKills -= Database.upgradeWavemasterCost
		Database.spawnAtWave += Database.upgradeWavemasterWaveIncrease
		Database.upgradeWavemasterOwned += 1
		Database.upgradeWavemasterCost = floor(Database.upgradeWavemasterCost * Database.upgradeWavemasterIncrease)
		showPlayerWevemaster()
	else:
		$unableBuy.play()


func _on_soulhunter_pressed() -> void:
	if Database.return_player_totalKills() >= Database.upgradeSoulhunterCost && Database.UpgradeSoulhunterOwned < 1:
		$buy.play()
		Database.player_totalKills -= Database.upgradeSoulhunterCost
		Database.soulGained = ceil(Database.soulGained * 2)
		Database.UpgradeSoulhunterOwned += 1
		Database.upgradeSoulhunterCost = floor(Database.upgradeSoulhunterCost * Database.upgradeSoulhunterIncrease)
		showPlayerSoulhunter()
	else:
		$unableBuy.play()
