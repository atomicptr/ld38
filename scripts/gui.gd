extends Control

onready var hp = get_node("hp")
onready var overheat = get_node("overheat")
onready var score = get_node("score")

onready var overheat_warning = get_node("overheat_warning")

onready var Game = get_tree().get_root().get_node("game")
onready var player = Game.get_node("player")

func _ready():
    set_process(true)

func _process(delta):
    hp.set_val(player.health)
    overheat.set_val(player.overheat)

    if player.is_overheat:
        overheat_warning.show()
    else:
        overheat_warning.hide()

    score.set_text(String(Game.score))
