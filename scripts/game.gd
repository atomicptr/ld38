extends Node2D

onready var explosion_prefab = preload("res://entities/explosion.tscn")
onready var exp_container = get_node("explosion_container")
onready var gameover_gui = get_node("gameover")
onready var sounds = get_node("sounds")

onready var earth = get_node("earth")

var explosions = []
var to_remove = []

var score = 0
var gameover = false

var time = 0.0
var last_go_explosion = 3.0
const EXPLOSION_TIMEOUT = .5

func _ready():
    set_process(true)

func _process(delta):
    if Input.is_action_pressed("gameover") and not gameover:
        game_over()

    if gameover:
        var newy = lerp(earth.get_pos().y, 150, .25 * delta)
        earth.set_pos(Vector2(earth.get_pos().x, newy))

        if time - last_go_explosion > EXPLOSION_TIMEOUT:
            var explo_pos = earth.get_global_pos()

            explo_pos.x = (20 + randi() % 300)
            explo_pos.y = (150 + (randi() % 350))

            var explosion = explode(explo_pos).get_node("particles")
            explosion.set_param(11, 1.5) # initial size
            explosion.set_amount(300)
            explosion.set_randomness(13, 1.0) # random hues!!
            explosion.set_color(Color("#FF0000"))
            last_go_explosion = time

    time += delta

func add_score(add):
    score += add
    print("Score: ", score)

func explode(pos, sound=true):
    # testa
    var explosion = explosion_prefab.instance()
    exp_container.add_child(explosion)
    explosion.set_global_pos(pos)
    explosion.get_node("particles").set_emitting(true)
    explosions.push_back(explosion)

    if sound:
        sfx("explosion")

    return explosion

func game_over():
    get_node("gui").queue_free()
    get_node("player").destroy()
    get_node("spawner").queue_free()
    get_tree().call_group(0, "enemy", "destroy")
    time = 0.0
    gameover = true

    gameover_gui.show()
    gameover_gui.get_node("go_score").set_text("Score: " + String(score))

func sfx(name, mult=false):
    sounds.play(name, mult)
