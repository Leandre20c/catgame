extends CharacterBody2D

var speed = 100

var player_stat

func _ready():
	pass

func _physics_process(delta):
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	
	if direction.x == 0 and direction.y == 0:
		player_stat = 'idle'
	elif direction.x != 0 or direction.y != 0:
		if Input.is_action_pressed("walk"):
			player_stat = 'walking'
			speed = 25
		else:
			player_stat = 'running'
			speed = 100
		
	velocity = direction * speed
	move_and_slide()
	
	play_anim(direction)
	

func play_anim(dir):
	if dir.y == -1:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('n_walk')
		if player_stat == 'running':
			$AnimatedSprite2D.play('n_run')
	elif dir.x == 1:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('e_walk')
		if player_stat == 'running':
			$AnimatedSprite2D.play('e_run')
	elif dir.y == 1:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('s_walk')
		if player_stat == 'running':
			$AnimatedSprite2D.play('s_run')
	elif dir.x == -1:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('w_walk')
		if player_stat == 'running':
			$AnimatedSprite2D.play('w_run')
	
	elif dir.x > 0.5 and dir.y < -0.5:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('ne_walk')
		if player_stat == 'running':
			$AnimatedSprite2D.play('ne_run')
	elif dir.x > 0.5 and dir.y > 0.5:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('se_walk')
		if player_stat == 'running':
			$AnimatedSprite2D.play('se_run')
	elif dir.x < -0.5 and dir.y < -0.5:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('nw_walk')
		if player_stat == 'running':
			$AnimatedSprite2D.play('nw_run')
	elif dir.x < -0.5 and dir.y > 0.5:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('sw_walk')
		if player_stat == 'running':
			$AnimatedSprite2D.play('sw_run')
	else:
		$AnimatedSprite2D.animation = 'idle'

func founded():
	queue_free()

func _on_human_player_detected(state):
	founded()
