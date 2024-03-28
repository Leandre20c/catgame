extends CharacterBody2D

var speed = 100

var player_stat


func _physics_process(delta):
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	
	if direction.x == 0 and direction.y == 0:
		player_stat = 'idle'
	elif direction.x != 0 or direction.y != 0:
		if Input.is_action_pressed("crouch"):
			player_stat = 'crouching'
		else:
			player_stat = 'walking'
		
	velocity = direction * speed
	move_and_slide()
	
	play_anim(direction)
	

func play_anim(dir):
	if player_stat == 'idle':
		$AnimatedSprite2D.animation = 'idle'
	if dir.y == -1:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('n_walk')
	if dir.x == 1:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('e_walk')
	if dir.y == 1:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('s_walk')
	if dir.x == -1:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('w_walk')
	
	if dir.x > 0.5 and dir.y < -0.5:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('ne_walk')
	if dir.x > 0.5 and dir.y > 0.5:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('se_walk')
	if dir.x < -0.5 and dir.y < -0.5:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('nw_walk')
	if dir.x < -0.5 and dir.y > 0.5:
		if player_stat == 'walking':
			$AnimatedSprite2D.play('sw_walk')
