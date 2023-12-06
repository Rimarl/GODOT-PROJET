extends CharacterBody2D

var speed = 25
var player_chase = false
var player = null

func _physics_process(delta):
	$Animation_Sprite2D.play("fly")
	if player_chase:
		position += (player.position - position)/speed


func _on_area_detection_body_entered(body):
	player = body
	player_chase = true


func _on_area_detection_body_exited(body):
	body = null
	player_chase = false

