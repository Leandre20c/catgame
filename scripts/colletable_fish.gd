extends Area2D
@onready var collected = $collected

func _on_body_entered(body):
	if body.is_in_group('player'):
		queue_free()
