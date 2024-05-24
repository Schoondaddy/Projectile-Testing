extends CharacterBody2D



const MAX_SPEED = 1000.0
const rocket_acceleration = .015


var accelerating : bool = false
var velociter : Vector2
var SPEED = 75.0

func _ready():
	await get_tree().create_timer(.5).timeout
	accelerating = true


func _physics_process(delta):
	if accelerating:
		SPEED = lerp(SPEED, MAX_SPEED, rocket_acceleration)
	var forward_global_x = transform[0]
	velociter = forward_global_x
	var collision_info = move_and_collide(velociter.normalized() * delta * SPEED)
	



func _on_area_2d_body_entered(body):
	accelerating = false
	SPEED = 0
	for child in get_children():
		if child.name != "ExplosionParticles":
			child.queue_free()
	get_node("ExplosionParticles").emitting = 1
	await get_tree().create_timer(3).timeout
	queue_free()
