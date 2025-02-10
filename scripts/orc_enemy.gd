extends CharacterBody2D


var speed = 100
var player_chase  = false
var player = null
var health = 1000
var player_in_atk_range = false
var attack_ip = false
var can_take_damage = true
var taken_dmg = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _physics_process(delta: float):
	deal_with_dmg()
	if not is_on_floor():
		velocity.y += gravity * delta
	if taken_dmg:
		$AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.modulate = Color.WHITE
		taken_dmg = false
	if(player_chase):
		position.x += (player.position.x - position.x)/speed
		$AnimatedSprite2D.play("walk")
		if ((player.position.x - position.x)	 < 0):
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func _on_dectectoin_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	pass # Replace with function body.


func _on_dectectoin_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	pass # Replace with function body.
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if(body.has_method("player")):
		player_in_atk_range = true
	#print(body)
	pass # Replace with function body.


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if(body.has_method("player")):
		player_in_atk_range = false
	pass # Replace with function body.

func deal_with_dmg():
	if(player_in_atk_range && Global.player_current_atk):
		if can_take_damage:
			taken_dmg = true
			health -= 20
			$DMG_Cooldown.start()
			can_take_damage = false
			#print(health)
			if (health <= 0):
				Global.player_score += 1000
				self.queue_free()

func deal_range_dmg():
	if can_take_damage:
		health -= 20
		$DMG_Cooldown.start()
		can_take_damage = false
		#print(health)
		if (health <= 0):
			self.queue_free()


func _on_dmg_cooldown_timeout() -> void:
	can_take_damage = true
	pass # Replace with function body.


func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("arrow"):
		taken_dmg = true
		deal_range_dmg()
	pass # Replace with function body.
