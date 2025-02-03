extends CharacterBody2D


const speed = 100
var current_direction = "none"
var enemy_in_atk_range = false
var enemy_atk_cd = true
var health = 100
var alive = true
	
func _physics_process(delta: float):
	player_movement(delta)
	enemy_atk()
	if health <= 0:
		health = 0
		# end scren here 
		alive = false
		print("dead")
		self.queue_free()

func _ready():
	$AnimatedSprite2D.play("idle")
	
func player_movement(delta):
	if Input.is_action_pressed("right"):
		current_direction = "right"
		play_anim(true)
		velocity.x = speed
		velocity.y = 0
	elif  Input.is_action_pressed("left"):
		current_direction = "left"
		play_anim(true)
		velocity.x = -speed
		velocity.y = 0
	else:
		play_anim(false)
		velocity.x = 0
		velocity.y = 0
	move_and_slide()

func play_anim(movement : bool):
	var direction = current_direction
	var anim = $AnimatedSprite2D
	if direction == "right":
		anim.flip_h = false
		if movement:
			anim.play("walk")
		else:
			anim.play("idle")
	elif direction == "left":
		anim.flip_h = true
		if movement: 
			anim.play("walk")
		else:
			anim.play("idle")
	


func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_atk_range = true
	pass # Replace with function body. 


func _on_player_hitbox_body_exited(body: Node2D) -> void:
		if body.has_method("enemy"):
			enemy_in_atk_range = false
		pass # Replace with function body.
func enemy_atk():
	if(enemy_in_atk_range && enemy_atk_cd == true):	
		health -= 20
		enemy_atk_cd = false
		print("Player took damage")
		$ATKCooldown.start(	)
		print(health)
	
func  player():
	pass
	


func _on_atk_cooldown_timeout() -> void:
	enemy_atk_cd = true
	pass # Replace with function body.
