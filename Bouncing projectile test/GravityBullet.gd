extends CharacterBody2D


const SPEED = 600.0
const GRAVITY_CONSTANT = 100.0

var velociter : Vector2
var starting_pos
var is_stopped = false
var player_is_inside = false

@onready var Player = $"../../Player"
@onready var gravity_area = $"GravityArea"

func _ready():
	starting_pos = global_position
	set_as_top_level(true)



func _physics_process(delta):
	if global_position.distance_to(starting_pos) > 300:
		is_stopped = true
	
	
	if !is_stopped:
		var forward_global_x = transform[0]
		velociter = forward_global_x
		var collision_info = move_and_collide(velociter.normalized() * delta * SPEED)
	
	
	if player_is_inside:
		var impulse_strength = 1000
		var impulse_direction = global_position.direction_to(Player.global_position)
		
		# Simulate an impulse by directly setting the velocity
		velocity += impulse_direction.normalized() * impulse_strength * delta
	


func _on_gravity_area_body_entered(body):
	if body.name == "Player":
		player_is_inside = true


func _on_gravity_area_body_exited(body):
	if body.name == "Player":
		player_is_inside = false

