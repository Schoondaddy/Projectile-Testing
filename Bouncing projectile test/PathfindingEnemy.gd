extends CharacterBody2D


const SPEED = 300.0
const accel = 7

@onready var navigator = $"Navigator"

func _physics_process(delta):
	navigator.target_position = get_global_mouse_position()
	
	var direction : Vector2
	direction = (navigator.get_next_path_position() - global_position).normalized()
	velocity = lerp(velocity, direction * SPEED, accel * delta)
	
	move_and_slide()
