extends CharacterBody2D


const speed = 100
var current_direction = "none"

func _physics_process(delta: float):
	player_movement(delta)
	pass

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
	
