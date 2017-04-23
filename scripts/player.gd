extends KinematicBody2D

onready var particles = get_node("particles")
onready var earth = get_node("../earth")
onready var Game = get_tree().get_root().get_node("game")
onready var bullet_container = Game.get_node("bullet_container")
onready var sprite = get_node("rocket")

onready var bullet_prefab = preload("res://entities/bullet.tscn")

const ACCELERATION = 7.0

const PARTICLE_LIFETIME_MOVING = 0.7
const PARTICLE_LIFETIME_STILL = 0.4
const BULLET_DELAY = 0.1
const IFRAME_TIME = 5.0 # 5s iframe

const DAMAGE_FROM_BODYCONTACT = 50
const HEALTH_PICKUP_VAL = 25

const UPGRADE_LEVELS = {
    0: [Vector2(0, -1)],
    1: [Vector2(-0.125, -1), Vector2(0.125, -1)],
    2: [Vector2(-0.5, -1), Vector2(0, -1), Vector2(0.5, -1)],
    3: [Vector2(-0.5, -1), Vector2(0, -1), Vector2(0.5, -1), Vector2(0, 1)],
    4: [Vector2(-0.5, -1), Vector2(0, -1), Vector2(0.5, -1), Vector2(-0.125, 1), Vector2(0.125, 1)],
    5: [Vector2(-0.5, -1), Vector2(0, -1), Vector2(0.5, -1), Vector2(-0.5, 1), Vector2(0, 1), Vector2(0.5, 1)],
    6: [Vector2(-0.5, -1), Vector2(0, -1), Vector2(0.5, -1), Vector2(-0.5, 1), Vector2(0, 1), Vector2(0.5, 1), Vector2(1, 0), Vector2(-1, 0)],
    7: [Vector2(-0.5, -1), Vector2(0, -1), Vector2(0.5, -1), Vector2(-0.5, 1), Vector2(0, 1), Vector2(0.5, 1), Vector2(1, 0), Vector2(-1, 0), Vector2(-0.125, -1), Vector2(0.125, -1), Vector2(-0.125, 1), Vector2(0.125, 1)],
}

const OVERHEAT_PER_SHOT = 5
const OVERHEAT_COOLDOWN_TIME = 0.6 # seconds

var time = 0.0

var health = 100
var overheat = 0
var upgrade_level = 0
var is_overheat = false

var velocity = Vector2(0, 0)
var is_in_earth_collider = false

var last_bullet_shot = 0.0
var last_hit_received = -IFRAME_TIME
var last_overheat_cooltime = 0.0

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

    # change color white in iframe
    if time - last_hit_received < IFRAME_TIME:
        sprite.set_modulate(Color("#FFFF00"))
    else:
        sprite.set_modulate(Color("#FFFFFF"))

    # cool down weapon if it's overheat
    if overheat > 0:
        if time - last_overheat_cooltime > OVERHEAT_COOLDOWN_TIME:
            if is_overheat:
                overheat -= OVERHEAT_PER_SHOT * 3
            else:
                overheat -= OVERHEAT_PER_SHOT

            if overheat < 0:
                overheat = 0

            last_overheat_cooltime = time

    if is_overheat and overheat <= 0:
        overheat = 0
        is_overheat = false

    # check if is colliding with enemy
    if is_colliding():
        var hit = get_collider()

        if hit.is_in_group("enemy"):
            self.hit(DAMAGE_FROM_BODYCONTACT)
            hit.destroy()

    # clean bullets
    for bullet in bullet_container.get_children():
        if bullet.get_global_pos().y < -100:
            bullet.queue_free()

func shoot_bullet():
    if not is_overheat and time - last_bullet_shot > BULLET_DELAY:
        spawn_bullet()

        Game.sfx("laser")

        overheat += OVERHEAT_PER_SHOT

        if overheat >= 100:
            is_overheat = true
            Game.sfx("overheat")

        last_bullet_shot = time

func spawn_bullet():
    var direction_vectors = UPGRADE_LEVELS[upgrade_level]

    for vec in direction_vectors:
        var bullet = bullet_prefab.instance()
        var bullet_pos = get_global_pos()
        bullet_pos.y -= 10.0
        bullet.set_direction_vector(vec)
        bullet_container.add_child(bullet)
        bullet.set_global_pos(bullet_pos)

func hit(damage):
    if time - last_hit_received > IFRAME_TIME:
        health -= damage
        last_hit_received = time
        Game.sfx("hit")

    if health <= 0:
        Game.game_over()

func destroy():
    Game.explode(get_global_pos())
    queue_free()

func on_contact_with_enemy():
    self.hit(DAMAGE_FROM_BODYCONTACT)

func _on_earth_body_enter(body):
    if body.is_in_group("player"):
        is_in_earth_collider = true

func _on_earth_body_exit(body):
    if body.is_in_group("player"):
        is_in_earth_collider = false

func on_health_pickup():
    Game.sfx("healthpickup")
    if health + HEALTH_PICKUP_VAL > 100:
        health = 100
    else:
        health += HEALTH_PICKUP_VAL

func on_powerup_pickup():
    Game.sfx("powerup")

    if upgrade_level + 1 < UPGRADE_LEVELS.size():
        upgrade_level += 1
