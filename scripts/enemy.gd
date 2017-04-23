extends KinematicBody2D

onready var Game = get_tree().get_root().get_node("game")

const MOVEMENT_SPEED = 50.0

var rnd_movement_speed_mod = 0.0
var speed_bonus = 1.0

func _ready():
    rnd_movement_speed_mod = randf() * (MOVEMENT_SPEED + speed_bonus)

    set_process(true)

func _process(delta):
    move(Vector2(0, 1) * (MOVEMENT_SPEED + rnd_movement_speed_mod) * delta)

    if is_colliding():
        var hit = get_collider()

        if hit.has_method("on_contact_with_enemy"):
            hit.on_contact_with_enemy()
            destroy()

    if get_global_pos().y > 800:
        queue_free() # out of bounds, went past the planet

func hit():
    print("ENEMY GOT HIT!!!")
    destroy()

func set_speed_bonus(bonus):
    speed_bonus = bonus

func destroy(sound=true):
    Game.drop_chance(get_global_pos())
    Game.add_score(50)
    Game.explode(get_global_pos(), sound)
    queue_free()
