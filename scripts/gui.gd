extends Control

onready var hp = get_node("hp")
onready var overheat = get_node("overheat")
onready var score = get_node("score")

onready var upgrades = get_node("upgrades")
onready var upgrade_lvl = upgrades.get_node("lvl")

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

    if player.upgrade_level > 0:
        upgrades.show()
        upgrade_lvl.set_text("+" + String(player.upgrade_level))
    else:
        upgrades.hide()

    score.set_text(String(Game.score))
