class_name Warrior extends Unit

func _ready():
	super._ready()
	
	unit_type = unit_types.WARRIOR
	cost = 65
	damage = 10
	unit_img = preload("res://assets/GUI/WarriorImg.jpg")

func _on_navigation_agent_3d_target_reached():
	if current_state == states.ATTACKING:
		attack()
	else:
		change_state("idle")

func _on_attack_timer_timeout():
	search_for_enemies("enemy")
