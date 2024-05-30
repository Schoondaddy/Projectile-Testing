extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var camera = $"Camera2D"
@onready var healthbar_path = $"Camera2D/Health"
@onready var gun = $"Gun"

var health = 100.0


func _ready():
	pass

func _physics_process(delta):
	var Xdirection = Input.get_axis("ui_left", "ui_right")
	var Ydirection = Input.get_axis("ui_up", "ui_down")
	
	if Xdirection && Ydirection:
		velocity = Vector2(Xdirection * sqrt(.5) * SPEED, Ydirection * sqrt(.5) * SPEED)
		
	else:
		velocity.x = Xdirection * SPEED
		velocity.y = Ydirection * SPEED
	
	if Input.is_action_pressed("left_click"):
		gun.shoot_handler()
	
	
	camera_offset(Xdirection, Ydirection)
	move_and_slide()

func update_health(amount):
	health += amount
	if health > 100:
		health = 100
	elif health < 0:
		health = 0
		die()
	healthbar_path.value = health

func camera_offset(x, y):
	camera.position = lerp(Vector2(50 * x, 50 * y), camera.position, .75)

func die():
	queue_free()
