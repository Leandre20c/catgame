extends CharacterBody2D
@onready var view_field = $view_field

var speed = 75

signal player_detected

var player = null

var current_dir = 's'
var previous_position = Vector2.ZERO

var target

var target_angle_degrees = 0
var rotation_speed = 15.0

func _ready():
	previous_position = global_position
	
	
func _physics_process(delta):
	velocity = (global_position - previous_position) / delta
	previous_position = global_position
	anim()
	dir()
	detect_player_rays()
	rotate_rays(delta)
	
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
	var does_see_player = target != null

func rotate_rays(delta):
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
				var rotation_delta = 7.5 / 2

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
	
	
func _on_detect_area_1_body_entered(body):
	if body.is_in_group('player'):
		player = body
		$find_timer.start()


func _on_detect_area_1_body_exited(body):
	if body.is_in_group('player'):
		player = null
		$find_timer.stop()


func _on_detect_area_2_body_entered(body):
	if body.is_in_group('player'):
		player = body
		$find_timer.start()


func _on_detect_area_2_body_exited(body):
	if body.is_in_group('player'):
		player = null
		$find_timer.stop()


func _on_find_timer_timeout():
	emit_signal("player_detected", true)
