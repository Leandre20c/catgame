extends CharacterBody2D

var speed = 100

var player_stat

var currentSkinIndex = 0
var skins = []


func _ready():
	currentSkinIndex = EventManager.skin_index
	# Remplissez le tableau skins avec toutes les skins disponibles
	skins.append($peach_0)
	skins.append($grey_2)
	skins.append($seal_point_0)
	# Cachez toutes les skins sauf la première
	for i in range(len(skins)):
		skins[i].visible = false
	
	skins[currentSkinIndex].visible = true


func changeSkin(newSkinIndex):
	# Vérifiez si l'index de la nouvelle skin est valide
		if newSkinIndex < 0 or newSkinIndex >= skins.size():
			return

		# Cachez l'ancienne skin
		skins[currentSkinIndex].visible = false

		# Affichez la nouvelle skin
		skins[newSkinIndex].visible = true

		# Mettez à jour l'index de la skin actuelle
		currentSkinIndex = newSkinIndex

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
			skins[currentSkinIndex].play('n_walk')
		if player_stat == 'running':
			skins[currentSkinIndex].play('n_run')
	elif dir.x == 1:
		if player_stat == 'walking':
			skins[currentSkinIndex].play('e_walk')
		if player_stat == 'running':
			skins[currentSkinIndex].play('e_run')
	elif dir.y == 1:
		if player_stat == 'walking':
			skins[currentSkinIndex].play('s_walk')
		if player_stat == 'running':
			skins[currentSkinIndex].play('s_run')
	elif dir.x == -1:
		if player_stat == 'walking':
			skins[currentSkinIndex].play('w_walk')
		if player_stat == 'running':
			skins[currentSkinIndex].play('w_run')
	
	elif dir.x > 0.5 and dir.y < -0.5:
		if player_stat == 'walking':
			skins[currentSkinIndex].play('ne_walk')
		if player_stat == 'running':
			skins[currentSkinIndex].play('ne_run')
	elif dir.x > 0.5 and dir.y > 0.5:
		if player_stat == 'walking':
			skins[currentSkinIndex].play('se_walk')
		if player_stat == 'running':
			skins[currentSkinIndex].play('se_run')
	elif dir.x < -0.5 and dir.y < -0.5:
		if player_stat == 'walking':
			skins[currentSkinIndex].play('nw_walk')
		if player_stat == 'running':
			skins[currentSkinIndex].play('nw_run')
	elif dir.x < -0.5 and dir.y > 0.5:
		if player_stat == 'walking':
			skins[currentSkinIndex].play('sw_walk')
		if player_stat == 'running':
			skins[currentSkinIndex].play('sw_run')
	else:
		skins[currentSkinIndex].animation = 'idle'

func founded():
	queue_free()
	get_tree().change_scene_to_file("res://scene/menus/death_menu.tscn")

func _on_human_player_detected(state):
	founded()
	


func _on_footstep_timer_timeout():
	if player_stat == 'running':
		$footstep_sound.pitch_scale = randf_range(0.8, 1.2)
		$footstep_sound.play()
		$footstep_sound.pitch_scale = randf_range(0.6, 1.4)
		$footstep_sound.play()
	$footstepTimer.start()
