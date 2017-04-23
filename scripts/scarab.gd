extends KinematicBody2D

onready var Game = get_tree().get_root().get_node("game")
onready var player = Game.get_node("player")
onready var particles = get_node("particles")

const MOVEMENT_SPEED = 600.0

var rnd_movement_speed_mod = 0.0
var speed_bonus = 1.0

var health = 5

var velocity = Vector2(0, 0)

func _ready():
    rnd_movement_speed_mod = randf() * (MOVEMENT_SPEED + speed_bonus)

    set_process(true)

func _process(delta):
    move(velocity * delta)

    velocity *= 0.9

    if is_colliding():
        var hit = get_collider()

        if hit.has_method("on_contact_with_scarab"):
            hit.on_contact_with_scarab()
            destroy()

func hit():
    health -= 1

    if health <= 0:
        destroy()
    else:
        var explosion = Game.explode(get_global_pos(), false).get_node("particles")
        explosion.set_lifetime(0.3)
        explosion.set_amount(100)

func set_speed_bonus(bonus):
    pass

func _on_timer_timeout():
    particles.set_emitting(true)
    Game.sfx("scarab_jump")
    var dir = player.get_global_pos() - get_global_pos()
    velocity = dir.normalized() * MOVEMENT_SPEED

func destroy(sound=true):
    Game.drop_chance(get_global_pos())
    Game.add_score(200)
    Game.explode(get_global_pos(), sound)
    queue_free()
