extends Node2D

onready var explosion_prefab = preload("res://entities/explosion.tscn")
onready var exp_container = get_node("explosion_container")

var explosions = []
var to_remove = []

func explode(pos):
    # testa
    var explosion = explosion_prefab.instance()
    exp_container.add_child(explosion)
    explosion.set_global_pos(pos)
    explosion.get_node("particles").set_emitting(true)
    explosions.push_back(explosion)
    return explosion
