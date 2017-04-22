extends KinematicBody2D

const BULLET_SPEED = 200.0

var distance_traveled = 0.0

var direction_vector = Vector2(0, -1)

var hittable = []

func _ready():
    set_fixed_process(true)
    set_process(true)

func set_direction_vector(vec):
    direction_vector = vec

func make_hittable(group):
    hittable.push_back(group)

func _process(delta):
    move(direction_vector * BULLET_SPEED * delta)

func _fixed_process(delta):
    if is_colliding():
        var hit = get_collider()

        for group in hittable:
            if hit.is_in_group(group):
                if hit.has_method("hit"):
                    hit.hit()

        # todo: pass through object that is not in hittable?
        queue_free()
