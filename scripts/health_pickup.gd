extends Area2D

onready var Game = get_tree().get_root().get_node("game")

func _on_health_pickup_body_enter(body):
    if body.is_in_group("player"):
        body.on_health_pickup()
        queue_free()

func _on_timer_timeout():
    Game.explode(get_global_pos())
    queue_free()
