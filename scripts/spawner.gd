extends KinematicBody2D

onready var Game = get_tree().get_root().get_node("game")

onready var enemy_prefab = preload("res://entities/enemy.tscn")
onready var enemy2_prefab = preload("res://entities/enemy2.tscn")
onready var scarab_prefab = preload("res://entities/scarab.tscn")
onready var boss_prefab = preload("res://entities/boss.tscn")

const MIN = 20
const MAX = 300
const DELAY = 2

var direction = 1

var time = 0.0
var last_enemy_spawned = 0.0
var extra_delay = 0.0

var speed_bonus = 0.0

var spawned_easter_egg = false

func _ready():
    set_process(true)

func _process(delta):
    var x = get_global_pos().x

    if x <= MIN:
        direction = 1

    if x >= MAX:
        direction = -1

    move(Vector2(50 * direction * delta, 0))

    if time - last_enemy_spawned > max(DELAY - (speed_bonus / 5), 0.3):
        var enemy = null

        if Game.score > 500 and (randi() % 100) > 95:
            enemy = enemy2_prefab.instance()
        elif Game.score > 1000 and (randi() % 100) > 90:
            enemy = scarab_prefab.instance()
        else:
            enemy = enemy_prefab.instance()

        enemy.set_speed_bonus(speed_bonus) # make them faster with time
        Game.add_child(enemy)
        enemy.set_global_pos(get_global_pos())

        last_enemy_spawned = time
        speed_bonus += 0.1

    # spawn boss after 50k score!
    if Game.score > 20000 and not spawned_easter_egg:
        spawned_easter_egg = true
        var boss = boss_prefab.instance()
        Game.add_child(boss)
        boss.set_global_pos(Vector2(40, -500))

    time += delta

func destroy():
    print("all enemies destroyed, reset speed bonus... was ", speed_bonus)
    speed_bonus = 0.0
