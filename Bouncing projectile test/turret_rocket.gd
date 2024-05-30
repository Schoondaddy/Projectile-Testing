extends CharacterBody2D



const MAX_SPEED = 2000.0
const rocket_acceleration : float = .005


var accelerating : bool = false
var velociter : Vector2
var SPEED : float = 500.0

func _ready():
	set_as_top_level(true)
	await get_tree().create_timer(.1).timeout
	SPEED = 75.0
	await get_tree().create_timer(.25).timeout
	accelerating = true


func _physics_process(delta):
	print(SPEED)
	if accelerating:
		SPEED = lerp(SPEED, MAX_SPEED, rocket_acceleration)
	var forward_global_x = transform[0]
	velociter = forward_global_x
	var collision_info = move_and_collide(velociter.normalized() * delta * SPEED)
	



func _on_area_2d_body_entered(body):
	accelerating = false
	SPEED = 0
	for child in get_children():
		if child.name != "ExplosionParticles" && child.name != "SmokeParticles":
			child.queue_free()
	get_node("ExplosionParticles").emitting = 1
	await get_tree().create_timer(.25).timeout
	get_node("SmokeParticles").emitting = 1
	await get_tree().create_timer(3).timeout
	queue_free()
