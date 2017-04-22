extends KinematicBody2D

onready var enemy_prefab = preload("res://entities/enemy.tscn")

const MIN = 20
const MAX = 300
const DELAY = 1.5

var direction = 1

var time = 0.0
var last_enemy_spawned = 0.0
var extra_delay = 0.0

var speed_bonus = 0.0

func _ready():
    set_process(true)

func _process(delta):
    var x = get_global_pos().x

    if x <= MIN+5 or x >= MAX-5:
        direction *= -1

    move(Vector2(50 * direction * delta, 0))

    extra_delay = randf() * 3.0

    if time - last_enemy_spawned > DELAY + extra_delay:
        var enemy = enemy_prefab.instance()
        enemy.set_speed_bonus(speed_bonus) # make them faster with time
        get_tree().get_root().get_node("game").add_child(enemy)
        enemy.set_global_pos(get_global_pos())

        last_enemy_spawned = time
        speed_bonus += 0.1

    time += delta

    if x < 10 or x > 310: # if it bugs too far into one direction, reset
        set_pos(Vector2(150, get_pos().y))

func destroy():
    print("all enemies destroyed, reset speed bonus... was ", speed_bonus)
    speed_bonus = 0.0
