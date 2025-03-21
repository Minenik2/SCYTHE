extends CharacterBody2D


const JUMP_VELOCITY = -250.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@export var projectile_scene: PackedScene  # Assign your Projectile.tscn here
@export var projectile_spawn_offset: Vector2 = Vector2(20, 0)  # Adjust based on player sprite
var isAttacking = false;
var increasedRange = false
var increasedRangeForSelene = false
var changedForm = false

func jump():
	velocity.y = JUMP_VELOCITY
	
func jump_side(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x

func _physics_process(delta: float) -> void:
	changeForm()
	
	if velocity.x != 0 && isAttacking == false:
		if !$step.playing && is_on_floor():
			$step.play()
		sprite_2d.flip_h = velocity.x < 0
		if $Sprite2D.flip_h:
			$Sprite2D/attackArea/hitbox_attack.position.x = -abs($Sprite2D/attackArea/hitbox_attack.position.x)
			$Sprite2D/attackAreaBehind/hitbox_attack.position.x = abs($Sprite2D/attackAreaBehind/hitbox_attack.position.x)
		else:
			$Sprite2D/attackArea/hitbox_attack.position.x = abs($Sprite2D/attackArea/hitbox_attack.position.x)
			$Sprite2D/attackAreaBehind/hitbox_attack.position.x = -abs($Sprite2D/attackAreaBehind/hitbox_attack.position.x)
		$Sprite2D.play("run")
	elif velocity.x == 0 && isAttacking == false:
		sprite_2d.animation = "default"
		
	# attacking
	if Input.is_action_just_pressed("attack"):
		if !isAttacking:
			$attack.play()
			if Database.additionalProjectile:
				shoot_projectile($Sprite2D.flip_h)
				if Database.attackBehind:
					shoot_projectile(!$Sprite2D.flip_h)
			if Database.increaseAttackRange:
				if !increasedRange:
					increaserange(1.2)
					increasedRange = true
			if Database.seleneForm:
				if !increasedRangeForSelene:
					increaserange(1.9)
					increasedRangeForSelene = true
		$Sprite2D.play("attack")
		isAttacking = true
	if $Sprite2D.animation == "attack" && $Sprite2D.frame == 3:
		$Sprite2D/attackArea/hitbox_attack.disabled = false
		if Database.attackBehind:
			$Sprite2D/attackAreaBehind/hitbox_attack.disabled = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if isAttacking == false:
			sprite_2d.animation = "jump"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && isAttacking == false:
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if isAttacking == false || Database.slideAttack:
		var direction := Input.get_axis("left", "right")
		if direction:
			if isAttacking:
				velocity.x = direction * floor(Database.playerSpeed / 2)
			else:
				velocity.x = direction * Database.playerSpeed
		else:
			velocity.x = move_toward(velocity.x, 0, 27)
	# stand still when attacking
	else:
		velocity.x = 0

	move_and_slide()

func shoot_projectile(movingRight):
	if projectile_scene:
		#print("i shoot")
		var projectile = projectile_scene.instantiate()
		if Database.seleneForm:
			projectile.lifetime = 0.8
			if Database.increaseAttackRange:
				projectile.lifetime = 1.2
		elif Database.increaseAttackRange:
			projectile.lifetime = 0.3
		projectile.movingRight = !movingRight
		projectile.position = global_position + projectile_spawn_offset.rotated(global_rotation)
		projectile.rotation = global_rotation
		get_parent().add_child(projectile)
		


func _on_scythehit_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_sprite_2d_animation_finished() -> void:
	if $Sprite2D.animation == "attack":
		$Sprite2D/attackArea/hitbox_attack.disabled = true
		$Sprite2D/attackAreaBehind/hitbox_attack.disabled = true # attack behind
		isAttacking = false
		
func changeForm():
	if Database.vorathForm:
		$Sprite2D.modulate = Color("B50000") # Equivalent to #B50000
		Database.playerLifeStealAmount = 0.1
	elif Database.seleneForm:
		$Sprite2D.modulate = Color("007EF7") # Equivalent to #007EF7
		Database.playerCritDamage = Database.seleneFormAdditionalCritDamage

func increaserange(amountRange):
	var rangeIncreaseAmount = floor($Sprite2D/attackArea/hitbox_attack.shape.size.x * amountRange)
	var rangeBehindIncreaseAmount = floor($Sprite2D/attackAreaBehind/hitbox_attack.shape.size.x * amountRange)
	print("increased range")
	if !$Sprite2D.flip_h:
		$Sprite2D/attackArea/hitbox_attack.shape.size.x = -rangeIncreaseAmount
		$Sprite2D/attackArea/hitbox_attack.position.x += rangeIncreaseAmount / 6
		$Sprite2D/attackAreaBehind/hitbox_attack.shape.size.x = -rangeBehindIncreaseAmount
		$Sprite2D/attackAreaBehind/hitbox_attack.position.x -= rangeBehindIncreaseAmount / 6
	else:
		$Sprite2D/attackArea/hitbox_attack.shape.size.x = rangeIncreaseAmount
		$Sprite2D/attackArea/hitbox_attack.position.x -= rangeIncreaseAmount / 6
		$Sprite2D/attackAreaBehind/hitbox_attack.shape.size.x = rangeBehindIncreaseAmount
		$Sprite2D/attackAreaBehind/hitbox_attack.position.x += rangeBehindIncreaseAmount / 6
