extends KinematicBody2D

onready var particles = get_node("particles")
onready var earth = get_node("../earth")

const ACCELERATION = 7.0

const PARTICLE_LIFETIME_MOVING = 0.7
const PARTICLE_LIFETIME_STILL = 0.4

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

    if Input.is_action_pressed("fire"):
        pass

    if is_in_earth_collider:
        velocity.y -= (ACCELERATION * 2)

    if velocity.length() > 30:
        particles.set_lifetime(PARTICLE_LIFETIME_MOVING)
    else:
        particles.set_lifetime(PARTICLE_LIFETIME_STILL)

    move(velocity * delta)
    velocity *= 0.96

func _on_earth_body_enter(body):
    if body.is_in_group("player"):
        is_in_earth_collider = true

func _on_earth_body_exit(body):
    if body.is_in_group("player"):
        is_in_earth_collider = false
