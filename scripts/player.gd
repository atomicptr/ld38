extends KinematicBody2D

onready var particles = get_node("particles")

const ACCELERATION = 7.0

var velocity = Vector2(0, 0)

var is_in_earth_collider = false

func _ready():
    set_process(true)

func _process(delta):

    if Input.is_action_pressed("left"):
        velocity.x -= (ACCELERATION * 0.8)

    if Input.is_action_pressed("right"):
        velocity.x += (ACCELERATION * 0.8)

    if Input.is_action_pressed("up"):
        velocity.y -= ACCELERATION

    if Input.is_action_pressed("down"):
        velocity.y += ACCELERATION

    if is_in_earth_collider:
        velocity.y -= (ACCELERATION * 1.5)

    print(velocity)

    move(velocity * delta)
    velocity *= 0.96

func _on_earth_body_enter(body):
    if body.is_in_group("player"):
        is_in_earth_collider = true

func _on_earth_body_exit(body):
    if body.is_in_group("player"):
        is_in_earth_collider = false
