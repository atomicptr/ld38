extends Node2D

onready var explosion_prefab = preload("res://entities/explosion.tscn")
onready var healthpickup_prefab = preload("res://entities/health_pickup.tscn")
onready var powerup_prefab = preload("res://entities/powerup_pickup.tscn")
onready var bomb_prefab = preload("res://entities/bomb_pickup.tscn")

onready var exp_container = get_node("explosion_container")
onready var gameover_gui = get_node("gameover")
onready var sounds = get_node("sounds")

onready var earth = get_node("earth")
onready var player = get_node("player")

var explosions = []
var to_remove = []

var score = 0
var gameover = false

var time = 0.0
var last_go_explosion = 3.0
const EXPLOSION_TIMEOUT = .75

const DROP_MODIFIER = 20 # 20 means 1 in 20 chance to drop

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

func drop_chance(pos):
    var rng = randi() % DROP_MODIFIER

    # worst rng ever, but time is limited :D
    if rng < 5:
        drop_pickup(healthpickup_prefab, pos)
    elif (rng == 10 or rng == 14 or rng == 18) and player != null and player.upgrade_level + 1 < player.UPGRADE_LEVELS.size(): # don't drop if player has fully upgraded
        drop_pickup(powerup_prefab, pos)
    elif rng == 16:
        drop_pickup(bomb_prefab, pos)

func drop_pickup(prefab, pos):
    print("Dropped pickup at ", pos)
    var pickup = prefab.instance()
    add_child(pickup)
    pickup.set_global_pos(pos)

func game_over():
    get_node("gui").queue_free()
    player.destroy()
    get_node("spawner").queue_free()
    get_tree().call_group(0, "enemy", "destroy")
    time = 0.0
    gameover = true

    gameover_gui.show()
    gameover_gui.get_node("go_score").set_text("Score: " + String(score))

func sfx(name, mult=false):
    sounds.play(name, mult)

func _on_restart_button_pressed():
    get_tree().change_scene("res://game.tscn")
