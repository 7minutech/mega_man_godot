extends CharacterBody2D


var speed = 100
var player_chase  = false
var player = null
var health = 100
var player_in_atk_range = false



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
		player_in_atk_range = true
	pass # Replace with function body.

func deal_with_dmg():
	if(player_in_atk_range && global.player_current_atk):
		health -= 20
		print(health)
		if (health <= 0):
			self.queue_free()
