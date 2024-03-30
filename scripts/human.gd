extends CharacterBody2D
@onready var view_field = $view_field

# Variables membres
var speed = 75
var rotation_delta = 7.5
var find_timer_progress

# Signaux
signal player_detected

# Références aux nœuds
var player = null
var target

# Direction et position
var current_dir = 's'
var previous_position = Vector2.ZERO

# Détection proche
var near_detection = false

# Rayons
var rays
var target_angle_degrees = 0

func _ready():
	
	previous_position = global_position
	rays = [$RayCast2D, $RayCast2D2, $RayCast2D3, $RayCast2D4, $RayCast2D5, $RayCast2D6, $RayCast2D7, $RayCast2D8, $RayCast2D9]
	
func _physics_process(delta):
	velocity = (global_position - previous_position) / delta
	previous_position = global_position
	anim()
	dir()
	detect_player_rays()
	rotate_rays()
	rays_detect()
	draw_timer()
	
func dir():
	if abs(velocity.x) > abs(velocity.y):
		# Si la vitesse en x est plus grande en valeur absolue que la vitesse en y,
		# cela signifie que le déplacement horizontal est plus important que le déplacement vertical
		if velocity.x > 1:
			current_dir = 'e'
		elif velocity.x < -1:
			current_dir = 'w'
	else:
		# Sinon, le déplacement vertical est plus important que le déplacement horizontal
		if velocity.y > 1:
			current_dir = 's'
		elif velocity.y < -1:
			current_dir = 'n'

func anim():
	if current_dir == 'e':
		$AnimatedSprite2D.play('e_walk')
	elif current_dir == 'w':
		$AnimatedSprite2D.play('w_walk')
	elif current_dir == 'n':
		$AnimatedSprite2D.play('n_walk')
	elif current_dir == 's':
		$AnimatedSprite2D.play('s_walk')
	
func detect_player_rays():
	for ray in get_children():
		if ray is RayCast2D and ray.is_colliding():
			var collider = ray.get_collider()
			if collider and collider.is_in_group('player'):
				target = collider
				break

func rotate_rays():
	var first_ray = null
	# Trouver le premier rayon
	for ray in get_children():
		if ray is RayCast2D:
			first_ray = ray
			break
			
	for ray in get_children():
		if ray is RayCast2D:
			if current_dir == 'e':
				target_angle_degrees = -90.0
			elif current_dir == 'w':
				target_angle_degrees = 90.0
			elif current_dir == 'n':
				target_angle_degrees = 180.0
			elif current_dir == 's':
				target_angle_degrees = 0.0
		
			if ray.rotation_degrees != target_angle_degrees:

				# Calculer la différence d'angle
				var angle_difference = target_angle_degrees - ray.rotation_degrees

				# Ajuster la différence d'angle si nécessaire pour assurer le mouvement dans la direction la plus courte
				if abs(angle_difference) > 180:
					if angle_difference > 0:
						angle_difference -= 360
					else:
						angle_difference += 360
						
				# Ajuster progressivement la rotation
				if angle_difference > 0:
					ray.rotation_degrees += min(rotation_delta, angle_difference)
				else:
					ray.rotation_degrees -= min(rotation_delta, abs(angle_difference))
					
		view_field.rotation_degrees = first_ray.rotation_degrees

func rays_detect():
	var detected_rays_count = 0
	for ray in rays:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider and collider.is_in_group('player'):
				detected_rays_count += 1
				player = ray.get_collider()

	if detected_rays_count > 0 and not $find_timer.is_stopped():
		# Le timer est déjà en cours, pas besoin de le redémarrer
		pass
	elif detected_rays_count > 0 and $find_timer.is_stopped():
		# Aucun ray détectant actuellement, mais le timer est arrêté, donc on le démarre
		$find_timer.start()
	elif detected_rays_count == 0 and near_detection == false:
		# Aucun ray détectant actuellement, donc on arrête le timer
		$find_timer.stop()
	
func _on_detect_area_2_body_entered(body):
	if body.is_in_group('player'):
		player = body
		if player.player_stat != 'walking':
			near_detection = true
			$find_timer.start()

func _on_detect_area_2_body_exited(body):
	if body.is_in_group('player'):
		player = null
		$find_timer.stop()
		near_detection = false

func _on_find_timer_timeout():
	emit_signal("player_detected", true)

func draw_timer():
	find_timer_progress = ($find_timer.time_left / $find_timer.wait_time)
	
	if find_timer_progress != 0:
		$TextureProgressBar.visible = true
	else:
		$TextureProgressBar.visible = false
		
	$TextureProgressBar.value = (find_timer_progress) * 100
