extends Worker

func _ready():
	super._ready()
	team = 1

func _on_attack_timer_timeout():
	search_for_enemies("units")

# 3:42 #48
