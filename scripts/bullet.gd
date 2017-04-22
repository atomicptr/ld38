extends KinematicBody2D

const BULLET_SPEED = 10.0

func _ready():
    set_process(true)

func _process(delta):
    move(Vector2(0, -BULLET_SPEED))

    if get_global_pos().y < -100: # is out of bounds
        free()
