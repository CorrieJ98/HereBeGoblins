extends Sprite3D


@onready var subvp = get_node("SubViewport")
func _ready():
	texture = subvp.get_texture()
