extends Area2D

onready var sprite = get_node("sprite")

const SCALE_SPEED = 2.5

var anim_running = false
var health = 5

var target_scale = null
var target_pos = null

var rot = 0

func is_dead():
    return health == 0

func decrease_health():
    if anim_running:
        return

    if health > 0:
        health -= 1
    else:
        return # TODO: you died, game over!

    anim_running = true

    if health == 4:
        target_scale = Vector2(0.85, 0.85)

    if health == 3:
        target_scale = Vector2(0.7, 0.7)

    if health == 2:
        target_scale = Vector2(0.6, 0.6)

    if health == 1:
        target_scale = Vector2(0.4, 0.4)

    var explosion = get_tree().get_root().get_node("game").explode(get_global_pos()).get_node("particles")
    explosion.set_param(2, 500) # Linear Velocity
    explosion.set_param(11, 1.5) # initial size
    explosion.set_amount(1000)
    explosion.set_color(Color("#0099FF"))

    get_tree().call_group(0, "enemy", "destroy")

func change_size(delta):
    var scalex = lerp(get_scale().x, target_scale.x, SCALE_SPEED * delta)
    var scaley = lerp(get_scale().y, target_scale.y, SCALE_SPEED * delta)

    set_scale(Vector2(scalex, scaley))

    var delta_scale = (target_scale - get_scale()).length()

    if delta_scale < 0.0001:
        anim_running = false

func _ready():
    set_process(true)

func _process(delta):
    if anim_running:
        change_size(delta)

    rot -= 0.05

    sprite.set_rotd(rot)
