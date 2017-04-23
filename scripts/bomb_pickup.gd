extends Area2D

onready var Game = get_tree().get_root().get_node("game")

func _ready():
    set_process(true)

func _process(delta):
    var pos = get_pos()
    pos.y += 10.0 * delta
    set_pos(pos)

func _on_bomb_pickup_body_enter(body):
    if body.is_in_group("player"):
        Game.sfx("explosion_earth")
        var explosion = Game.explode(get_global_pos(), false).get_node("particles")
        explosion.set_param(2, 500) # Linear Velocity
        explosion.set_param(11, 1.5) # initial size
        explosion.set_amount(1000)
        explosion.set_color(Color("#BE2633"))
        get_tree().call_group(0, "enemy", "destroy", false)
        queue_free()

func _on_timer_timeout():
    Game.explode(get_global_pos())
    queue_free()
