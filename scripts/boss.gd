extends Node2D

func _ready():
    set_process(true)

func _process(delta):
    var pos = get_pos()
    pos.y += 10 * delta
    set_pos(pos)

    if get_pos().y > 1000:
        queue_free()
