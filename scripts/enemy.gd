extends KinematicBody2D

const MOVEMENT_SPEED = 50.0

var rnd_movement_speed_mod = 0.0

func _ready():
    rnd_movement_speed_mod = randf() * MOVEMENT_SPEED

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

func destroy():
    get_tree().get_root().get_node("game").explode(get_global_pos())
    queue_free()
