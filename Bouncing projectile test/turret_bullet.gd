extends CharacterBody2D


const SPEED = 600.0
const max_bounces = 5

var velociter : Vector2
var bounces = 0
@onready var raycast = get_node("BounceDetector")

func _ready():
	set_as_top_level(true)



func _physics_process(delta):
	var forward_global_x = transform[0]
	velociter = forward_global_x
	var collision_info = move_and_collide(velociter.normalized() * delta * SPEED)
	
	if raycast.is_colliding():
		bounce()

func bounce():
	bounces += 1
	var surface_normal = raycast.get_collision_normal()
	var surface_right_angle = rad_to_deg(atan2(surface_normal.y, surface_normal.x))
	var new_angle = 2 * surface_right_angle - rad_to_deg(rotation) - 180
	rotation = deg_to_rad(new_angle) 
