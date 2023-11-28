extends CharacterBody2D

var veloc = Vector2.ZERO
var Acc = 500
var max_speed = 100
var FRECTION = 500

var current_dir = "none"
var animationPlayer = null

func _ready():
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
	print(veloc)	
	"""Elle est utile lorsque vous avez besoin d'un contrôle précis sur la manière dont votre objet réagit aux collisions."""
	
	move_and_collide(veloc*delta)
