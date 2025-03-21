extends Node

# Enemy scene to instance
@export var enemy_scene: PackedScene

# List of spawn zones (Area2D nodes)
@export var spawn_zones: Array[Area2D]

# Time interval between enemy spawns (seconds)
var spawn_timer: float = 0.0

# Game Manager reference
@onready var game_manager: Node = %GameManager
@onready var level: Node2D = $".."

func _ready():
	# Set the spawn timer
	spawn_timer = Database.spawn_interval

func _process(delta):
	# Update the spawn timer
	spawn_timer -= delta
	
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = Database.spawn_interval  # Reset the timer after spawning an enemy

func spawn_enemy():
	if spawn_zones.is_empty():
		print("No spawn zones assigned!")
		return

	# Pick a random spawn zone
	var spawn_zone = spawn_zones[randi() % spawn_zones.size()]
	
	# Declare spawn_position
	var spawn_position: Vector2 = Vector2()
	
	# Get the RectangleShape2D from the CollisionShape2D
	var collision_shape = spawn_zone.get_node("CollisionShape2D").shape
	if collision_shape is RectangleShape2D:
		# Calculate random position within the RectangleShape2D bounds
		var rect_size = collision_shape.extents * 2  # RectangleShape2D's extents are half the size
		spawn_position = spawn_zone.global_position + Vector2(
			randi_range(-rect_size.x / 2, rect_size.x / 2),
			randi_range(-rect_size.y / 2, rect_size.y / 2)
			)
	else:
		print("Unsupported collision shape type for spawn zone.")
		return

	# Instance the enemy and position it
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_position
	enemy.game_manager = game_manager
	level.add_child(enemy)
