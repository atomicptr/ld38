extends KinematicBody2D

const MOVEMENT_SPEED = 50.0

func _ready():
    set_process(true)

func _process(delta):
    move(Vector2(0, 1) * MOVEMENT_SPEED * delta)

    if is_colliding():
        var hit = get_collider()

        if hit.has_method("on_contact_with_enemy"):
            hit.on_contact_with_enemy()
            queue_free()

func hit():
    print("ENEMY GOT HIT!!!")
    destroy()

func destroy():
    # TODO: add explosion
    queue_free()
