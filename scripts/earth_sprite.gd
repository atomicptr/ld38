extends KinematicBody2D

func on_contact_with_enemy():
    get_parent().decrease_health()
