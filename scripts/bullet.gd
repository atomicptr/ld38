extends KinematicBody2D

const BULLET_SPEED = 200.0

var distance_traveled = 0.0

var velocity = Vector2(0, -1)

func _ready():
    set_process(true)

func _process(delta):
    move(velocity * delta * BULLET_SPEED)

    if get_global_pos().y < -100: # is out of bounds
        free()
