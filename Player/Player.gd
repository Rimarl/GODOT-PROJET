extends CharacterBody2D
var enemies_remaining = 0
var veloc = Vector2.ZERO
var Acc = 500
var max_speed = 100
var FRECTION = 500
var jump_speed = 300
var is_on_ground = false
var jump_cooldown = true
var current_dir = "none"
var animationPlayer = null

var enemy_inattck_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false # attack in progresse

func _ready():
	var enemy_group = get_parent().get_node("enemy_groupe")
	enemies_remaining = enemy_group.get_child_count()
	print("Number of children in enemy_group:",enemies_remaining)
	animationPlayer = $AnimationPlayer
	
	
func _physics_process(delta):
	"""
	if Input.is_action_just_pressed("ui_right"):
		veloc.x += 10 
	elif Input.is_action_just_pressed("ui_left"):
		veloc.x += -10
	elif Input.is_action_just_pressed("ui_up"):
		veloc.y += -10
	elif Input.is_action_just_pressed("ui_down"):
		veloc.y += 10
	else:
		veloc.x = 0
		veloc.y = 0
	"""
	var input_vector=Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector.normalized()
	if is_on_ground and Input.is_action_just_pressed("jump") and jump_cooldown:
		veloc.y = -jump_speed
		jump_cooldown = false
		$jump_timer.start()	  
	if input_vector != Vector2.ZERO:
		if input_vector.y==0:
			if input_vector.x > 0:
				animationPlayer.play("RunRight")
				current_dir = "Right"
			else :
				animationPlayer.play("RunLeft")
				current_dir = "Left"
		else:
			if input_vector.y > 0:
				animationPlayer.play("RunDown")
				current_dir = "Down"
			else :
				animationPlayer.play("RunUp")
				current_dir = "Up"
		"""veloc = input_vector*max_speed*delta"""
		veloc = veloc.move_toward(input_vector * max_speed, Acc*delta)
	else:
		if current_dir =="Right":
			animationPlayer.play("IdRight")
		elif current_dir =="Left":
			animationPlayer.play("IdLeft")
		elif current_dir =="Down":
			animationPlayer.play("IdDown")
		elif current_dir =="Up":
			animationPlayer.play("IdUp")
		else:
			animationPlayer.play("IdDown")
				
		veloc = veloc.move_toward(Vector2.ZERO, FRECTION*delta)
	#print(veloc)	
	"""Elle est utile lorsque vous avez besoin d'un contrôle précis sur la manière dont votre objet réagit aux collisions."""
	
	move_and_collide(veloc*delta)
	enemy_attack()
	attack()
	update_health_bar()
	if health <= 0:
		player_alive = false
		health=0
		print("Player have been killed")
		switch_to_gameover_scene()
		self.queue_free()
		

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattck_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattck_range = false


func _on_jump_timer_timeout():
	jump_cooldown = true

func enemy_attack():
	
	if enemy_inattck_range==true and enemy_attack_cooldown==true:
		health = health - 20
		enemy_attack_cooldown = false
		$"attack-cooldown".start()
		print("health = ", health)

# quand le temps se termine == reviens true
func _on_attackcooldown_timeout():
	enemy_attack_cooldown = true 

func attack():
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true #mise a joure
		attack_ip = true
		if current_dir=="Right":
			animationPlayer.play("AttackRight")
			$deal_attack_timer.start()
		if current_dir=="Left":
			animationPlayer.play("AttackLeft")
			$deal_attack_timer.start()
		if current_dir=="Down":
			animationPlayer.play("AttackDown")
			$deal_attack_timer.start()
		if current_dir=="Up":
			animationPlayer.play("AttackUp")
			$deal_attack_timer.start()
		

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false

func update_health_bar():
	var health_bar = $HealthBar
	health_bar.value = health
	
func _on_regin_time_timeout():
	if health < 100:
		health = health + 10
		if health > 100:
			health = 100
func _on_CharacterBody2D_ground_entered():
	is_on_ground = true
func _on_CharacterBody2D_ground_exited():
	is_on_ground = false
	$jump_timer.stop()
	
func enemy_killed():
	
	enemies_remaining -= 1
	
	if enemies_remaining  == 0:
		player_data.coin = 0
		get_tree().change_scene_to_file("res://win/win.tscn")
		
		
func switch_to_gameover_scene():
	print("Switching to gameover scene")
	player_data.coin = 0 
	get_tree().change_scene_to_file("res://gameover.tscn")
	



