extends CharacterBody2D


var speed = 75
var can_take_damage = true
var health = 100
var player_in_atk_range = false
var taken_dmg = false
func _ready() -> void:
	$AnimatedSprite2D.play("fly")
	$AnimatedSprite2D.flip_h = true

func _physics_process(delta: float) -> void:
	velocity.x = -speed
	deal_with_dmg()
	move_and_slide()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
	pass # Replace with function body.

func deal_dmg():
	if can_take_damage:
		health -= 20
		$AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.modulate = Color.WHITE
		$DMG_Cooldown.start()
		#can_take_damage = false
		print(health)
		if (health <= 0):
			Global.player_score += 500
			self.queue_free()
			

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.has_method("player")):
		player_in_atk_range = true
		print("hoit")
	if area.has_method("arrow"):
		taken_dmg = true
		deal_dmg()
	print(area)
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	if(area.has_method("player")):
		player_in_atk_range = false
	pass # Replace with function body.
func enemy():
	pass


func _on_dmg_cooldown_timeout() -> void:
	can_take_damage = true
	pass # Replace with function body.
	
func deal_with_dmg():
	if(player_in_atk_range && Global.player_current_atk):
		if can_take_damage:
			taken_dmg = true
			health -= 20
			$DMG_Cooldown.start()
			can_take_damage = false
			print(health)
			if (health <= 0):
				self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.has_method("player")):
		player_in_atk_range = true

	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body.has_method("player")):
		player_in_atk_range = false
	pass # Replace with function body.

func flying():
	pass
