extends Control

@onready var description: Label = $MarginContainer/VBoxContainer/HBoxContainer2/description
@onready var amount_owned: Label = $"MarginContainer/VBoxContainer/HBoxContainer2/amount owned"
@onready var cost: Label = $MarginContainer/VBoxContainer/HBoxContainer2/cost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func showPlayerHealth():
	amount_owned.text = "Player health: " + str(Database.playerHealth) + " " + str(Database.upgradeHealthOwned) + "/99"

func showPlayerDamage():
	amount_owned.text = "Player damage: " + str(Database.playerDamage) + " " + str(Database.upgradeDamageOwned) + "/99"

func showPlayerCrit():
	amount_owned.text = "Player crit: " + str(Database.playerCritChance) + "% " + str(Database.upgradeCritOwned) + "/10"

func _on_health_increase_mouse_entered() -> void:
	description.text = "Increase health points by 20%"
	showPlayerHealth()
	cost.text = "Souls Owned: " + str(Database.return_player_totalKills()) + " Souls Cost: " + str(Database.return_upgradeHealthCost())

func _on_attack_increase_mouse_entered() -> void:
	description.text = "Increase damage by 20%"
	showPlayerDamage()
	cost.text = "Souls Owned: " + str(Database.return_player_totalKills()) + " Souls Cost: " + str(Database.return_upgradeDamageCost())

func _on_crit_increase_mouse_entered() -> void:
	description.text = "Increase critical chance +5%"
	showPlayerCrit()
	cost.text = "Souls Owned: " + str(Database.return_player_totalKills()) + " Souls Cost: " + str(Database.return_upgradeCritCost())

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/upgrade_shop_subscene.tscn")


func _on_health_increase_pressed() -> void:
	if Database.return_player_totalKills() >= Database.upgradeHealthCost && Database.upgradeHealthOwned < 99:
		$buy.play()
		Database.player_totalKills -= Database.return_upgradeHealthCost()
		Database.upgradeHealthCost = ceil(Database.upgradeHealthCost * Database.upgradeCostIncrease)
		# cap
		if Database.upgradeHealthCost > Database.upgradeHealthCostCap:
			Database.upgradeHealthCost = Database.upgradeHealthCostCap
		Database.playerHealth = ceil(Database.playerHealth * Database.upgradeHealthIncrease)
		Database.upgradeHealthOwned += 1
		showPlayerHealth()
		cost.text = "Souls Owned: " + str(Database.return_player_totalKills()) + " Souls Cost: " + str(Database.return_upgradeHealthCost())
	else:
		$unableBuy.play()


func _on_attack_increase_pressed() -> void:
	if Database.return_player_totalKills() >= Database.upgradeDamageCost && Database.upgradeDamageOwned < 99:
		$buy.play()
		Database.player_totalKills -= Database.return_upgradeDamageCost()
		Database.upgradeDamageCost = ceil(Database.upgradeDamageCost * Database.upgradeCostIncrease)
		# cap
		if Database.upgradeDamageCost > Database.upgradeDamageCostCap:
			Database.upgradeDamageCost = Database.upgradeDamageCostCap
		Database.playerDamage = ceil(Database.playerDamage * Database.upgradeDamageIncrease)
		Database.upgradeDamageOwned += 1
		showPlayerDamage()
		cost.text = "Souls Owned: " + str(Database.return_player_totalKills()) + " Souls Cost: " + str(Database.return_upgradeDamageCost())
	else:
		$unableBuy.play()


func _on_crit_increase_pressed() -> void:
	if Database.return_player_totalKills() >= Database.return_upgradeCritCost() && Database.upgradeCritOwned < 10:
		$buy.play()
		Database.player_totalKills -= Database.upgradeCritCost
		Database.upgradeCritCost = floor(Database.upgradeCritCost * Database.upgradeCostIncrease)
		Database.playerCritChance += Database.upgradeCritIncrease
		Database.upgradeCritOwned += 1
		showPlayerCrit()
		cost.text = "Souls Owned: " + str(Database.return_player_totalKills()) + " Souls Cost: " + str(Database.return_upgradeCritCost())
	else:
		$unableBuy.play()
