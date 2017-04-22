extends KinematicBody2D

onready var enemy_prefab = preload("res://entities/enemy.tscn")

const MIN = 20
const MAX = 300
const DELAY = 2.0

var direction = 1

var time = 0.0
var last_enemy_spawned = 0.0
var extra_delay = 0.0

func _ready():
    set_process(true)

func _process(delta):
    var x = get_global_pos().x

    if x <= MIN or x >= MAX:
        direction *= -1

    move(Vector2(50 * direction * delta, 0))

    if time - last_enemy_spawned > DELAY + extra_delay:
        var enemy = enemy_prefab.instance()
        get_tree().get_root().get_node("game").add_child(enemy)
        enemy.set_global_pos(get_global_pos())

        last_enemy_spawned = time

    time += delta
