extends KinematicBody2D

onready var Game = get_tree().get_root().get_node("game")

func on_contact_with_enemy():
    get_parent().decrease_health()

func on_contact_with_enemy2():
    Game.sfx("explosion_earth")
    var explosion = Game.explode(get_global_pos(), false).get_node("particles")
    explosion.set_param(2, 500) # Linear Velocity
    explosion.set_param(11, 1.5) # initial size
    explosion.set_amount(1000)
    explosion.set_color(Color("#BE2633"))
    get_parent().sprite.hide()
    Game.game_over()
