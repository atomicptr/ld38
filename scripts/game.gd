extends Node2D

onready var explosion_prefab = preload("res://entities/explosion.tscn")
onready var exp_container = get_node("explosion_container")

var time = 0.0

var explosions = []
var to_remove = []

func _ready():
    set_process(true)

func _process(delta):
    time += delta

    print(exp_container.get_child_count())

func explode(pos):
    # testa
    var explosion = explosion_prefab.instance()
    exp_container.add_child(explosion)
    explosion.set_global_pos(pos)
    explosion.get_node("particles").set_emitting(true)
    explosions.push_back(explosion)
    return explosion
