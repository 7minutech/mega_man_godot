extends CharacterBody2D


var speed = 100
var player_chase  = false
var player = null

func _physics_process(delta: float):
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
