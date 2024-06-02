extends Sprite3D

func _ready():
	texture = get_node("SubViewport").get_texture()
