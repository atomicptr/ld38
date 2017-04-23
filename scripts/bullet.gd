extends Area2D

const BULLET_SPEED = 200.0
var distance_traveled = 0.0
var direction_vector = Vector2(0, -1)

func _ready():
    set_process(true)

func set_direction_vector(vec):
    direction_vector = vec

func _process(delta):
    move(direction_vector * BULLET_SPEED * delta)

func move(vec):
    set_pos(get_pos() + vec)

func _on_bullet_body_enter(body):
    if body.is_in_group("enemy"):
        body.hit()
        queue_free()
