extends KinematicBody2D

onready var particles = get_node("particles")
onready var earth = get_node("../earth")
onready var bullet_container = get_tree().get_root().get_node("game/bullet_container")

onready var bullet_prefab = preload("res://entities/bullet.tscn")

const ACCELERATION = 7.0

const PARTICLE_LIFETIME_MOVING = 0.7
const PARTICLE_LIFETIME_STILL = 0.4
const BULLET_DELAY = 0.1
const IFRAME_TIME = 2.0 # 2s iframe

const DAMAGE_FROM_BODYCONTACT = 30

var time = 0.0

var health = 100

var velocity = Vector2(0, 0)
var is_in_earth_collider = false

var last_bullet_shot = 0.0
var last_hit_received = 0.0

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

    # check if is colliding with enemy
    if is_colliding():
        var hit = get_collider()

        if hit.is_in_group("enemy"):
            self.hit(DAMAGE_FROM_BODYCONTACT)

    # clean bullets
    for bullet in bullet_container.get_children():
        if bullet.get_global_pos().y < -100:
            bullet.queue_free()

func shoot_bullet():
    if time - last_bullet_shot > BULLET_DELAY:
        spawn_bullet(Vector2(0, -1))
        last_bullet_shot = time

func spawn_bullet(direction_vector):
    var bullet = bullet_prefab.instance()
    var bullet_pos = get_global_pos()
    bullet_pos.y -= 10.0
    bullet.add_collision_exception_with(self)
    bullet.make_hittable("enemy")
    bullet.set_direction_vector(direction_vector)
    bullet_container.add_child(bullet)
    bullet.set_global_pos(bullet_pos)
    return bullet

func hit(damage):
    if time - last_hit_received > IFRAME_TIME:
        health -= damage
        last_hit_received = time

    if health <= 0:
        pass # TODO: you died, game over!

    print("Health: ", health)

func on_contact_with_enemy():
    self.hit(DAMAGE_FROM_BODYCONTACT)

func _on_earth_body_enter(body):
    if body.is_in_group("player"):
        is_in_earth_collider = true

func _on_earth_body_exit(body):
    if body.is_in_group("player"):
        is_in_earth_collider = false
