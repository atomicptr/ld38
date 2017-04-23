extends Area2D

onready var Game = get_tree().get_root().get_node("game")

func _ready():
    set_process(true)

func _process(delta):
    var pos = get_pos()
    pos.y += 10.0 * delta
    set_pos(pos)

func _on_powerup_pickup_body_enter(body):
    if body.is_in_group("player"):
        body.on_powerup_pickup()
        queue_free()

func _on_timer_timeout():
    Game.explode(get_global_pos())
    queue_free()
