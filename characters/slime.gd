extends CharacterBody2D

var dead = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager = $"../GameManager"
@onready var player = $"../main_character"  # Adjust the path to your player node
const DAMAGE_POPUP_SCENE = preload("res://scene/DamagePopup.tscn")

var damage = Database.enemySlimeDamage
var health = Database.enemySlimeHealth

# Gravity settings
var gravity = 800  # Adjust this for how fast the enemy falls
var speed = Database.enemySlimeSpeed  # Movement speed towards the player
var color:float = float(Database.level) / 10
var setColor = Color.from_hsv(color, 0.67, 1, 1)
var blink_timer: Timer  # Timer for blinking

# Flag to check if the enemy is on the ground
var on_ground = false
var crit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = setColor
	#print("hello i spawned")
	# Create a Timer for blinking
	blink_timer = Timer.new()
	blink_timer.wait_time = 0.1  # Duration of each blink
	blink_timer.one_shot = true
	add_child(blink_timer)
	blink_timer.connect("timeout", Callable(self, "_on_blink_timeout"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not dead:
		# Apply gravity
		if not is_on_floor():  # Check if the enemy is on the floor
			velocity.y += gravity * delta  # Apply gravity to the Y-axis
		else:
			velocity.y = 0  # Stop falling if on the ground
			# Chase the player
			chase_player(delta)
		
		# Move the enemy using CharacterBody2D's move_and_slide method
		move_and_slide()  # move_and_slide() will automatically use velocity

		# Play default animation
		animated_sprite_2d.play("default")

# Chase player function
func chase_player(delta: float) -> void:
	if player and not dead:
		# Calculate direction to the player
		var direction = (player.position - position).normalized()
		
		# Move the enemy horizontally towards the player
		velocity.x = direction.x * speed

# Handle animation finish for destruction
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "destroyed":
		queue_free()

# Check if enemy is on the ground
func _on_floor_collision(area: Area2D) -> void:
	on_ground = true
	velocity.y = 0  # Stop falling if on the ground

func _on_no_floor_collision(area: Area2D) -> void:
	on_ground = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("scythe") && !dead:
		var damageTaken = game_manager.getPlayerDamage()
		# if vorath form
		if Database.vorathForm:
			damageTaken += ceil(game_manager.health * Database.vorathFormAdditionalDamage)
		# check if projectile
		if area.name == "projectile":
			damageTaken = floor(damageTaken * Database.playerProjectileDamage)
		# check if crits
		if Database.playerCritChance >= randi_range(1,100) || Database.seleneForm:
			crit = true
			damageTaken = ceil(damageTaken * Database.playerCritDamage)
		health -= damageTaken
		# lifesteal upgrade
		if Database.lifeSteal || Database.vorathForm:
			game_manager.heal(ceil(damageTaken * Database.playerLifeStealAmount))
		# Show the damage popup
		show_damage_popup(damageTaken)
		crit = false
		
		if health > 0:
			blink()
			$ligthhit.play()
		else:
			game_manager.add_kill()
			dead = true
			animated_sprite_2d.play("destroyed")

func show_damage_popup(damageAmount: int) -> void:
	# Instantiate the DamagePopup scene
	var popup = DAMAGE_POPUP_SCENE.instantiate()
	
	popup.position = global_position  # Set its position to the slime's position
	get_parent().add_child(popup)  # Add to the same parent as the slime
	if crit:
		popup.modulate = Color(1, 0, 0)  # Red for crits
	popup.text = str(damageAmount)  # Set the damage value as the popup text

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "main_character" && !dead:
		$hit.play()
		var x_delta = body.position.x - position.x
		game_manager.decrease_health(damage)
		if x_delta > 0:
			body.jump_side(500)
		else:
			body.jump_side(-500)
			
func blink() -> void:
	# Change the sprite's color to white (flash effect)
	$".".modulate = Color(255, 255, 255, 255)
	blink_timer.start()

func _on_blink_timeout() -> void:
	# Revert the sprite's color back to normal
	$".".modulate = setColor  # Default color
