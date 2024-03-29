extends PathFollow2D

var speed = 0

func _ready():
	if $human:
		speed = $human.speed
	else:
		speed = 0

func _process(delta):
	progress += delta * speed / 2
