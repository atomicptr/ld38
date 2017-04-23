extends KinematicBody2D

onready var Game = get_tree().get_root().get_node("game")

const MOVEMENT_SPEED = 30.0

var rnd_movement_speed_mod = 0.0
var speed_bonus = 1.0

var health = 15

func _ready():
    rnd_movement_speed_mod = randf() * (MOVEMENT_SPEED + speed_bonus)

    set_process(true)

func _process(delta):
    move(Vector2(0, 1) * (MOVEMENT_SPEED + rnd_movement_speed_mod) * delta)

    if is_colliding():
        var hit = get_collider()

        if hit.has_method("on_contact_with_enemy2"):
            hit.on_contact_with_enemy2()
            destroy()

    if get_global_pos().y > 800:
        queue_free() # out of bounds, went past the planet

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

func destroy(sound=true):
    Game.drop_chance(get_global_pos())
    Game.add_score(250)
    Game.explode(get_global_pos(), sound)
    queue_free()
