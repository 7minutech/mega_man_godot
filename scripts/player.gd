extends CharacterBody2D


const speed = 100
var current_direction = "none"
var enemy_in_atk_range = false
var enemy_atk_cd = true
var health = 5
var alive = true
var atk_ip = false
var jump_velcoity = -400
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var arrow = preload("res://arrow.tscn")

func _physics_process(delta: float):
	$CanvasLayer2/HBoxContainer/ScoreLabel.text = "Score: " + str(Global.player_score)
	set_ui_health()
	player_movement(delta)
	enemy_atk()
	current_camera()
	if velocity.x == 0:
		attack()
	
	if health <= 0:
		health = 0
		# end scren here 
		alive = false
		#print("dead")
		self.queue_free()

func _ready():
	randomize()
	$AnimatedSprite2D.play("idle")
	
func player_movement(delta):
	#velocity.y = get_my_gravity() * delta
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_pressed("right"):
		current_direction = "right"
		play_anim("walk")
		velocity.x = speed
		if Input.is_action_just_pressed("jump") and is_on_floor():
			play_jump_sound()
			print("jump")
			jump()
	elif  Input.is_action_pressed("left"):
		current_direction = "left"
		play_anim("walk")
		velocity.x = -speed
		if Input.is_action_just_pressed("jump") and is_on_floor():
			play_jump_sound()
			jump()
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		play_jump_sound()
		jump()
	else:
		play_anim("idle")
		velocity.x = 0
	move_and_slide()
	
#func get_my_gravity() -> float:
	#return jump_gravity if velocity.y < 0.0 else fall_gravity
	

func jump():
	velocity.y = jump_velcoity

func play_anim(movement : String):
	var direction = current_direction
	var anim = $AnimatedSprite2D
	if direction == "right":
		anim.flip_h = false
		if movement == "walk":
			anim.play("walk")
		elif movement == "idle":
			if atk_ip == false:
				anim.play("idle")
	elif direction == "left":
		anim.flip_h = true
		if movement == "walk": 
			anim.play("walk")
		elif movement == "idle":
			if atk_ip == false:
				anim.play("idle")

				
	


func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_atk_range = true
		if body.has_method("atk"):
			body.atk()
	#print(body)
	pass # Replace with function body. 


func _on_player_hitbox_body_exited(body: Node2D) -> void:
		if body.has_method("enemy"):
			enemy_in_atk_range = false
		pass # Replace with function body.
func enemy_atk():
	if(enemy_in_atk_range && enemy_atk_cd == true):	
		health -= 1
		print(health)
		enemy_atk_cd = false
		$ATKCooldown.start(	)
		$AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.modulate = Color.WHITE
	
func  player():
	pass
	


func _on_atk_cooldown_timeout() -> void:
	enemy_atk_cd = true
	pass # Replace with function body.

func attack():
	var dir = current_direction
	if Input.is_action_just_pressed("sword_attack") or Input.is_action_just_pressed("bow_attack"):
		Global.player_current_atk = true
		atk_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
		if Input.is_action_just_pressed("sword_attack"):
			$SwordSound.pitch_scale = (randf_range(0.7, 1.2))
			$SwordSound.play()
			$AnimatedSprite2D.play("sword_attack")
		if Input.is_action_just_pressed("bow_attack"):
			$BowSound.pitch_scale = (randf_range(1.5, 2))
			$BowSound.play()
			$AnimatedSprite2D.play("bow_attack", 4.0)
			spawn_arrow()
		$DealATKTimer.start()
			
	


func _on_deal_atk_timer_timeout() -> void:
	$DealATKTimer.stop()
	Global.player_current_atk = false
	atk_ip = false
	pass # Replace with function body.

func spawn_arrow():
	var arrow_obj = arrow.instantiate()
	if current_direction == "right":
		arrow_obj.rotation = 0
	if current_direction == "left":
		arrow_obj.rotation = PI
	arrow_obj.global_position = $ArrowSpawn.global_position
	add_child(arrow_obj)


func _on_arrow_spawn_timer_timeout() -> void:
	spawn_arrow()
	$ArrowSpawnTimer.stop()
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("idle")
	pass # Replace with function body.


func _on_player_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("enemy"):
		enemy_in_atk_range = true
		
	pass # Replace with function body.


func _on_player_hitbox_area_exited(area: Area2D) -> void:
	if area.has_method("enemy"):
		enemy_in_atk_range = false
	pass # Replace with function body.

func current_camera():
	if Global.current_scene == "world":
		$WorldCamera.enabled = true
		$BossCamera.enabled = false
	if Global.current_scene == "boss":
		$WorldCamera/ScoreLabel.hide()
		$BossCamera.enabled = true 
		$WorldCamera.enabled = false
		
func set_ui_health():
	if health == 4:
		$CanvasLayer/Heart5.hide()
	if health == 3:
		$CanvasLayer/Heart4.hide()
	if health == 2:
		$CanvasLayer/Heart3.hide()
	if health == 2:
		$CanvasLayer/Heart3.hide()
	if health == 1:
		$CanvasLayer/Heart2.hide()
	if health == 0:
		$CanvasLayer/Heart1.hide()
	
func play_jump_sound():
	$JumpSound.pitch_scale = (randf_range(1.5, 2))
	$JumpSound.play()
