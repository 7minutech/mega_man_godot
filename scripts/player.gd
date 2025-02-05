extends CharacterBody2D


const speed = 100
var current_direction = "none"
var enemy_in_atk_range = false
var enemy_atk_cd = true
var health = 200
var alive = true
var atk_ip = false
@export var jump_height : float = 300
@export var jump_time_max : float = 0.8
@export var jump_time_min : float = 0.4
@onready var jump_velcoity : float = ((2.0 * jump_height) / (jump_time_max)) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_max * jump_time_max)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_max * jump_time_max)) * -1.0

func _physics_process(delta: float):
	player_movement(delta)
	enemy_atk()
	attack()
	if health <= 0:
		health = 0
		# end scren here 
		alive = false
		print("dead")
		self.queue_free()

func _ready():
	$AnimatedSprite2D.play("idle")
	
func player_movement(delta):
	velocity.y = get_my_gravity() * delta
	if Input.is_action_pressed("right"):
		current_direction = "right"
		play_anim("walk")
		velocity.x = speed
	elif  Input.is_action_pressed("left"):
		current_direction = "left"
		play_anim("walk")
		velocity.x = -speed
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	else:
		play_anim("idle")
		velocity.x = 0
	move_and_slide()
	
func get_my_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

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

func attack():
	var dir = current_direction
	if Input.is_action_just_pressed("Attack"):
		Global.player_current_atk = true
		atk_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("sword_attack")
		$DealATKTimer.start()
			
	


func _on_deal_atk_timer_timeout() -> void:
	$DealATKTimer.stop()
	Global.player_current_atk = false
	atk_ip = false
	pass # Replace with function body.
