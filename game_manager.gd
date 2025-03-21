extends Node

@onready var totalKills = 0
@onready var killsNeeded = Database.player_killsNeeded
@onready var health = Database.playerHealth
@onready var vorathMaxHealth = Database.playerHealth

@onready var kills_label: Label = $"../ui/PanelContainer/MarginContainer/GridContainer/killsLabel"
@onready var next_upgrade: Label = $"../ui/PanelContainer/MarginContainer/GridContainer/nextUpgrade"
@onready var health_panel: Label = $"../ui/PanelContainer/MarginContainer/GridContainer/health"
@onready var wave_label: Label = $"../ui/PanelContainer/MarginContainer/GridContainer/waveLabel"

var hintarray = ["Don't Die","IceTeaKB","Wave 99","7", "Cake Is a Lie","Selene Loves Pancakes","You Can Buy Upgrades!", "Breakcore", "1337", "ESCAPE", "Shadows Die Once", "Mido", "Cyatmrw"]
var upgradeList = ["attackRange", "projectile", "upgradeSpeed", "attackBehind", "lifeSteal", "slideAttack"]

var upgrade1
var upgrade2
var upgrade3


func _ready() -> void:
	totalKills = Database.return_player_totalKills()
	killsNeeded = Database.player_killsNeeded
	if Database.spawnAtWave > 0:
		while Database.level != Database.spawnAtWave:
			increaseLevel()
	updateData()

func updateData():
	wave_label.text = "Wave: " + str(Database.level)
	kills_label.text = "Souls: " + str(totalKills)
	next_upgrade.text = "Souls left: " + str(killsNeeded)
	health_panel.text = "Health: " + str(health)

func decrease_health(damage):
	print("decrease player health")
	health -= damage
	print(health)
	updateData()
	if (health <= 0):
		get_tree().paused = true
		var hint = hintarray.pick_random()
		$"../ui/pause/gameOverPanel/VBoxContainer2/VBoxContainer/hint".text = hint
		%gameOverPanel.show()

func heal(healAmount):
	health += healAmount
	# cannot overheal above max
	if health >= Database.playerHealth && !Database.vorathForm:
		health = Database.playerHealth
	elif health >= vorathMaxHealth:
		health = vorathMaxHealth
	# vorath gains 1% max health increase
	if Database.vorathForm:
		vorathMaxHealth += ceil(Database.playerHealth * 0.01)
	updateData()

func add_kill():
	totalKills += Database.soulGained
	killsNeeded -= Database.soulGained
	Database.increase_player_totalKills(Database.soulGained)
	$death.play()
	updateData()
	if killsNeeded <= 0:
		print(Database.finalPactOwned)
		print(Database.chosenForm)
		if Database.finalPactOwned && !Database.chosenForm:
			Database.chosenForm = true
			upgrade1 = "seleneForm"
			upgrade2 = "letgo"
			upgrade3 = "vorathForm"
			$"../ui/pause/upgradePanel/VBoxContainer2/hboxUpgrd/upgrade1".icon = load("res://img_upgradeIcons/" + upgrade1 +".png")
			$"../ui/pause/upgradePanel/VBoxContainer2/hboxUpgrd/upgrade2".icon = load("res://img_upgradeIcons/" + upgrade2 +".png")
			$"../ui/pause/upgradePanel/VBoxContainer2/hboxUpgrd/upgrade3".icon = load("res://img_upgradeIcons/" + upgrade3 +".png")
			get_tree().paused = true
			%upgradePanel.show()
		elif Database.level == 99:
			if Database.vorathForm:
				Database.vorathFormEnding = true
				Database.seleneFormEnding = false
				Database.letgoFormEnding = false
				$"../ui/pause/victoryPanel/VBoxContainer2/continueEND".text = "Watch Vorath Ending"
			elif Database.seleneForm:
				Database.vorathFormEnding = false
				Database.seleneFormEnding = true
				Database.letgoFormEnding = false
				$"../ui/pause/victoryPanel/VBoxContainer2/continueEND".text = "Watch Selene Ending"
			else:
				Database.vorathFormEnding = false
				Database.seleneFormEnding = false
				Database.letgoFormEnding = true
				$"../ui/pause/victoryPanel/VBoxContainer2/continueEND".text = "Watch True Ending"
			get_tree().paused = true
			%victoryPanel.show()
		else:
			increaseLevel()

# upgrade pop up
func showUpgradesRun():
	if len(upgradeList) != 0:
		# upgrades are determined if there are 3 left
		if len(upgradeList) == 3:
			upgrade1 = upgradeList[0]
			upgrade2 = upgradeList[1]
			upgrade3 = upgradeList[2]
		elif len(upgradeList) < 3:
			if len(upgradeList) == 2:
				upgrade1 = upgradeList[0]
				upgrade2 = upgradeList[1]
				upgrade3 = "NONE"
			elif len(upgradeList) == 1:
				upgrade1 = upgradeList[0]
				upgrade2 = "NONE"
				upgrade3 = "NONE"
			else:
				upgrade1 = "NONE"
				upgrade2 = "NONE"
				upgrade3 = "NONE"
		else:
			# randomly show upgrades
			upgrade1 = upgradeList.pick_random()
			upgrade2 = upgradeList.pick_random()
			upgrade3 = upgradeList.pick_random()
			while upgrade1 == upgrade2:
				upgrade2 = upgradeList.pick_random()
			while upgrade1 == upgrade3 || upgrade2 == upgrade3:
				upgrade3 = upgradeList.pick_random()
		if upgrade3 == "NONE":
			$"../ui/pause/upgradePanel/VBoxContainer2/hboxUpgrd/upgrade3".hide()
			if upgrade2 == "NONE":
				$"../ui/pause/upgradePanel/VBoxContainer2/hboxUpgrd/upgrade2".hide()
				if upgrade1 == "NONE":
					$"../ui/pause/upgradePanel/VBoxContainer2/hboxUpgrd/upgrade1".hide()
		# apply text to upgrades
		$"../ui/pause/upgradePanel/VBoxContainer2/hboxUpgrd/upgrade1".icon = load("res://img_upgradeIcons/" + upgrade1 +".png")
		$"../ui/pause/upgradePanel/VBoxContainer2/hboxUpgrd/upgrade2".icon = load("res://img_upgradeIcons/" + upgrade2 +".png")
		$"../ui/pause/upgradePanel/VBoxContainer2/hboxUpgrd/upgrade3".icon = load("res://img_upgradeIcons/" + upgrade3 +".png")
		get_tree().paused = true
		%upgradePanel.show()

func useUpgradeButton(upgrade):
	match upgrade:
		"upgradeSpeed":
			Database.playerSpeed = floor(Database.playerSpeed * 1.2)
			print("player speed increased" + str(Database.playerSpeed))
			Database.upgradeSpeed = true
		"attackRange":
			Database.increaseAttackRange = true
		"projectile":
			Database.additionalProjectile = true
		"attackBehind": 
			Database.attackBehind = true
		"lifeSteal":
			Database.lifeSteal = true
		"slideAttack":
			Database.slideAttack = true
		"seleneForm":
			Database.seleneForm = true
			Database.playerSpeed += 40
			increaseLevel()
		"vorathForm":
			Database.vorathForm = true
			increaseLevel()
		"letgo":
			Database.letgoForm = true
			increaseLevel()
		
	upgradeList.remove_at(upgradeList.find(upgrade))
		
func showDescriptionUpgrade(upgrade):
	match upgrade:
		"upgradeSpeed":
			$"../ui/pause/upgradePanel/VBoxContainer2/upgradedesc".text = "Increase Movement Speed by 20%"
		"attackRange":
			$"../ui/pause/upgradePanel/VBoxContainer2/upgradedesc".text = "Increase the attack range by 20%"
		"projectile":
			$"../ui/pause/upgradePanel/VBoxContainer2/upgradedesc".text = "When you attack shoots an projectile"
		"attackBehind": 
			$"../ui/pause/upgradePanel/VBoxContainer2/upgradedesc".text = "When you attack also attack behind you"
		"lifeSteal":
			$"../ui/pause/upgradePanel/VBoxContainer2/upgradedesc".text = "Heal for 1% of the damage dealt"
		"slideAttack":
			$"../ui/pause/upgradePanel/VBoxContainer2/upgradedesc".text = "can slide while attacking"
		"seleneForm":
			$"../ui/pause/upgradePanel/VBoxContainer2/upgradedesc".text = "Selene severs her connection with Vorath. Garanteed Crits, your critcal hits deal 99x more damage, increase attack range by 90% and increased movement speed"
		"vorathForm":
			$"../ui/pause/upgradePanel/VBoxContainer2/upgradedesc".text = "Vorath devours Selene. On attack gain 1% max health points, your attacks deal additional damage based on 60% of current health"
		"letgo":
			$"../ui/pause/upgradePanel/VBoxContainer2/upgradedesc".text = "Let go"
func getPlayerDamage():
	return Database.playerDamage
	
func hideUpgrades():
	%upgradePanel.hide()
	get_tree().paused = false

func _on_upgrade_1_mouse_entered() -> void:
	showDescriptionUpgrade(upgrade1)


func _on_upgrade_2_mouse_entered() -> void:
	showDescriptionUpgrade(upgrade2)


func _on_upgrade_3_mouse_entered() -> void:
	showDescriptionUpgrade(upgrade3)


func increaseLevel():
	Database.level += 1
	Database.enemySlimeDamage = floor(Database.enemySlimeDamage * Database.enemySlimeDamageIncrease)
	Database.enemySlimeHealth = floor(Database.enemySlimeHealth * Database.enemySlimeHealthIncrease)
	# show upgrade on dividable levels
	if Database.level % 2 == 0 && Database.level > (5 * Database.upgradeWavemasterOwned):
		showUpgradesRun()
	# increase kills needed
	Database.player_killsNeeded = floor(Database.player_killsNeeded * Database.player_killNeededIncrease)
	if Database.level > 2 && Database.enemySlimeSpeed < 50:
		Database.enemySlimeSpeed += 5
	# spawnrate cap
	if Database.spawn_interval > 0.05:
		Database.spawn_interval = Database.spawn_interval * Database.spawn_intervalDecrease
	# wave checkpoints
	if Database.level % 5 == 0:
		Database.spawn_interval = 0.5
		Database.enemySlimeSpeed = 25
		Database.player_killsNeeded = 20
		if Database.level > (5 * Database.upgradeWavemasterOwned):
			$"../TileMapLayer".position.y += 500
		$"../TileMapLayer".modulate = Color.from_hsv(float(Database.level) / 100, 0.67, 1, 1)
	# set kills needed
	killsNeeded = Database.player_killsNeeded
	print("Level: " + str(Database.level) + " - Enemies Spawn every " + str(Database.spawn_interval) + " seconds - Slime speed: " + str(Database.enemySlimeSpeed) + " Slime Health: " + str(Database.enemySlimeHealth) + " Slime Damage: " + str(Database.enemySlimeDamage))
	updateData()

func _on_upgrade_1_pressed() -> void:
	hideUpgrades()
	useUpgradeButton(upgrade1)


func _on_upgrade_2_pressed() -> void:
	hideUpgrades()
	useUpgradeButton(upgrade2)


func _on_upgrade_3_pressed() -> void:
	hideUpgrades()
	useUpgradeButton(upgrade3)

# game over button
func _on_continue_pressed() -> void:
	# gameover reset happens when player dies
	%pausePanel.hide()
	if Database.level > Database.maxLevelReached:
		Database.maxLevelReached = Database.level
	Database.gameOverReset()
	get_tree().paused = false
	if !Database.firstDeathDialogue:
		get_tree().change_scene_to_file("res://scene/dialogue.tscn")
	elif !Database.wave5Dialogue && Database.maxLevelReached >= 5:
		get_tree().change_scene_to_file("res://scene/dialogue.tscn")
	elif !Database.wave7Dialogue && Database.maxLevelReached >= 10:
		get_tree().change_scene_to_file("res://scene/dialogue.tscn")
	elif !Database.wave10Dialogue && Database.maxLevelReached >= 15:
		get_tree().change_scene_to_file("res://scene/dialogue.tscn")
	else:
		get_tree().change_scene_to_file("res://scene/main_menu.tscn")


func _on_continue_end_pressed() -> void:
	%victoryPanel.hide()
	Database.gameOverReset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/dialogue.tscn")
