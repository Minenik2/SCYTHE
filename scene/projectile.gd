extends Node2D

@export var speed: float = 500.0
@export var damage: int = 10
@export var lifetime: float = 0.2  # How long the projectile lasts
var movingRight = true
var start_position: Vector2

var _pierced_enemies = []  # Tracks enemies hit to avoid double damage

func _ready():
	start_position = position
	# Queue the projectile for deletion after its lifetime expires
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta: float):
	# Move the projectile forward
	if movingRight:
		position += Vector2.RIGHT.rotated(rotation) * speed * delta
	else:
		position += Vector2.LEFT.rotated(rotation) * speed * delta

func _on_Area2D_body_entered(body):
	# Check if the body is an enemy and if it hasn't been hit already
	if body.is_in_group("enemies") and body not in _pierced_enemies:
		_pierced_enemies.append(body)
		body.take_damage(damage)  # Call the enemy's damage function
