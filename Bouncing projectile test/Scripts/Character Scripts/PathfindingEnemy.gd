extends CharacterBody2D


const SPEED = 300.0
const accel = 7

var bulletPath = preload("res://Scenes/Spawnables/gravity_bullet.tscn")
var can_fire = true

@onready var Player = $"../Player"
@onready var navigator = $"Navigator"

func _physics_process(delta):
	if global_position.distance_to(Player.global_position) > 300:
		navigator.target_position = Player.global_position
		var direction : Vector2
		direction = (navigator.get_next_path_position() - global_position).normalized()
		velocity = lerp(velocity, direction * SPEED, accel * delta)
	else:
		velocity = lerp(velocity, Vector2(0,0), .5)
	if can_fire:
		can_fire = false
		fire_bullet()
		await get_tree().create_timer(5).timeout
		can_fire = true
	
	
	move_and_slide()


func fire_bullet():
	var bullet = bulletPath.instantiate()
	add_child(bullet)
	bullet.global_position = global_position
	bullet.rotation = atan2(Player.global_position.y - global_position.y, Player.global_position.x - global_position.x)

