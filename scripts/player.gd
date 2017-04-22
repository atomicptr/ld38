extends KinematicBody2D

onready var particles = get_node("particles")
onready var earth = get_node("../earth")
onready var bullet_container = get_tree().get_root().get_node("game/bullet_container")

onready var bullet_prefab = preload("res://entities/bullet.tscn")

const ACCELERATION = 7.0

const PARTICLE_LIFETIME_MOVING = 0.7
const PARTICLE_LIFETIME_STILL = 0.4
const BULLET_DELAY = 0.1

var time = 0.0

var velocity = Vector2(0, 0)
var is_in_earth_collider = false

var last_bullet_shot = 0.0

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
        shoot_bullet()

    if is_in_earth_collider:
        velocity.y -= (ACCELERATION * 2)

    if velocity.length() > 30:
        particles.set_lifetime(PARTICLE_LIFETIME_MOVING)
    else:
        particles.set_lifetime(PARTICLE_LIFETIME_STILL)

    move(velocity * delta)
    velocity *= 0.96 # slow down...

    time += delta

func shoot_bullet():
    if time - last_bullet_shot > BULLET_DELAY:
        var bullet = bullet_prefab.instance()
        var bullet_pos = get_global_pos()
        bullet_pos.y -= 10.0

        bullet_container.add_child(bullet)
        bullet.set_global_pos(bullet_pos)

        last_bullet_shot = time

func _on_earth_body_enter(body):
    if body.is_in_group("player"):
        is_in_earth_collider = true

func _on_earth_body_exit(body):
    if body.is_in_group("player"):
        is_in_earth_collider = false
