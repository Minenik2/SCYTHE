# Global.gd
extends Node

# player souls
var player_totalKills = 0
var player_killsNeeded = 10

# stage 2
var spawnAtWave = 0
var soulGained = 1

# kill needed increase
var player_killNeededIncrease = 1.4

# amount of upgrades the player purchased
var upgradeHealthOwned = 0
var upgradeDamageOwned = 0
var upgradeCritOwned = 0
# stage 2
var upgradeWavemasterOwned = 0
var UpgradeSoulhunterOwned = 0
# stage 3
var finalPactOwned = false 

# upgrade cost
var upgradeHealthCost = 10 # 10
var upgradeDamageCost = 10
var upgradeCritCost = 20
# stage 2
var upgradeWavemasterCost = 100
var upgradeSoulhunterCost = 100
# stage 3
var finalPactCost = 1000

# upgrade cost increase
var upgradeCostIncrease = 1.1 # 1.1
var upgradeHealthIncrease = 1.2 # 1.2
var upgradeDamageIncrease = 1.2 # 1.2
var upgradeCritIncrease = 5 # 5
# stage 2
var upgradeWavemasterIncrease = 1.1
var upgradeSoulhunterIncrease = 1
var upgradeWavemasterWaveIncrease = 5

# upgrade cost cap
var upgradeHealthCostCap = 20 # 20
var upgradeDamageCostCap = 50 # 50
# stage 2
var upgradeWavemasterCostCap = 100
var upgradeSoulhunterCostCap = 100
# stage 3

# player stats
var playerDamage = 24
var playerCritChance = 0
var playerHealth = 20
var playerProjectileDamage = 0.4 # 0.4
var playerSpeed = 240 # 240

var playerLifeStealAmount = 0.01
# vorath form additional % hp damage
var vorathFormAdditionalDamage = 0.6
# crit damage multiplier
var playerCritDamage = 1.5
# selene form additional crit damage
var seleneFormAdditionalCritDamage = 99

# slime stat
var enemySlimeHealth = 24
var enemySlimeDamage = 5
var enemySlimeSpeed = 20

# Time interval between enemy spawns (seconds)
var spawn_interval: float = 1
var spawn_intervalDecrease = 0.5

# level
var level = 1 # 1
var maxLevelReached = 1
var enemySlimeHealthIncrease = 1.25 # 1.3 // abdi playest is 1.2
var enemySlimeDamageIncrease = 1.2 # 1.2

# in run upgrades
var increaseAttackRange = false
var additionalProjectile = false
var upgradeSpeed = false 
var attackBehind = false
var lifeSteal = false
var slideAttack = false
# player form
var vorathForm = false
var seleneForm = false
var chosenForm = false # player has chosen form
var letgoForm = false
# chosen player form for ending
var vorathFormEnding = false
var seleneFormEnding = false
var letgoFormEnding = false

# player Dialogues
var introDialogue = false
var firstDeathDialogue = false
var wave5Dialogue = false
var wave7Dialogue = false
var wave10Dialogue = false

# all dialogue read
var allDialogueRead = false

func gameOverReset():
	level = 1
	spawn_interval = 1 # respawn of enemy
	enemySlimeHealth = 24
	enemySlimeDamage = 5
	enemySlimeSpeed = 20
	player_killsNeeded = 10
	playerSpeed = 240 # 240
	playerCritDamage = 1.5
	
	
	#reset in-run upgrades
	increaseAttackRange = false 
	additionalProjectile = false
	upgradeSpeed = false
	attackBehind = false 
	lifeSteal = false
	slideAttack = false
	seleneForm = false
	vorathForm = false
	chosenForm = false



func return_player_totalKills():
	return player_totalKills

func increase_player_totalKills(kills):
	player_totalKills += kills

func set_player_totalKills(kills):
	player_totalKills = kills
	
func return_upgradeHealthCost():
	return upgradeHealthCost
	
func return_upgradeDamageCost():
	return upgradeDamageCost

func return_upgradeCritCost():
	return upgradeCritCost
