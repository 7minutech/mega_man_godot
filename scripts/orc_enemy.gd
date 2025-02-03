extends CharacterBody2D


var speed = 100
var player_chase  = false
var player = null
var health = 100
var player_in_atk_range = false
var attack_ip = false
var can_take_damage = true


func _physics_process(delta: float):
	deal_with_dmg()
	if(player_chase):
		position += (player.position - position)/speed
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
	pass # Replace with function body.


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if(body.has_method("player")):
		player_in_atk_range = false
	pass # Replace with function body.

func deal_with_dmg():
	if(player_in_atk_range && Global.player_current_atk):
		if can_take_damage:
			health -= 20
			$DMG_Cooldown.start()
			can_take_damage = false
			print(health)
			if (health <= 0):
				self.queue_free()


func _on_dmg_cooldown_timeout() -> void:
	can_take_damage = true
	pass # Replace with function body.
