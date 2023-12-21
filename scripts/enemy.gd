extends CharacterBody2D
var speed = 25
var player_chase = false
var player = null
var current_states
enum enemy_states  {ALIVE , DEAD}
var health=100
var player_inattack_zone = false
@onready var coin_loot = preload("res://coin.tscn")
var can_take_damage = true
var nb = 3
func _physics_process(delta):
	
	deal_with_damage()
	update_health_bar()
	
	$AnimatedSprite2D.play("fly")
	if player_chase:
		position += (player.position - position)/speed

func enemy():
	pass

#pour qu'il cour deriere lui
func _on_area_detection_body_entered(body):
	player = body
	player_chase = true


func _on_area_detection_body_exited(body):
	body = null
	player_chase = false


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
		
func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack== true:
		if can_take_damage==true:
			health = health - 50
			$take_damage_coldown.start()
			can_take_damage=false
			print("sline health = ", health)
			if health <= 0 :
				loot_coin() 
				player.enemy_killed()
				self.queue_free()
				

# pour chaque frape subit a damage - 20
func _on_take_damage_coldown_timeout():
	can_take_damage = true
	
func update_health_bar():
	var health_bar = $healthbar
	health_bar.value = health



func _on_hitbox_area_entered(area):
	if area.is_in_group("Player_Hitbox"):
		health-=1
		print(health)
	
func loot_coin():
	var coin = coin_loot.instantiate()
	coin.global_position = global_position
	get_tree().get_root().add_child(coin)
	
