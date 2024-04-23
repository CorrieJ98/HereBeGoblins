class_name Appearance extends Resource

@export_category("Unit Details")
@export var name : String
@export_multiline var description : String

@export_category("Base model spritesheet")
@export var body_spritesheets : Array[CompressedTexture2D]
@export var body_spritesheets_frame_data : Array[Vector2i]
@export var portrait : CompressedTexture2D
@export var portrait_frame_data : Vector2i

@export_category("Armour and clothing spritesheets")
@export var armour_spritesheets : Array[CompressedTexture2D]
@export var armour_spritesheets_frame_data : Array[Vector2i]

@export_category("Weapon spritesheets")
@export var weapon_spritesheets : Array[CompressedTexture2D]
@export var weapon_spritesheets_frame_data : Array[Vector2i]

func _ready():
	populate_asc(null,body_spritesheets,
	body_spritesheets_frame_data,
	armour_spritesheets,
	armour_spritesheets_frame_data,
	weapon_spritesheets,weapon_spritesheets_frame_data)


# This is just silly
func populate_asc(asc : AppearanceSpritesheetContainer, base_spritesheet : Array[CompressedTexture2D], base_spritesheet_frame_data : Array[Vector2i],armour_spritesheets : Array[CompressedTexture2D], armour_spritesheet_frame_data : Array[Vector2i], weapon_spritesheets : Array[CompressedTexture2D], weapon_spritesheets_frame_data : Array[Vector2i]):
	
	# aliases to make this absolute mess easier to read
	var bss = base_spritesheet
	var bss_fd = base_spritesheet_frame_data
	var ass = armour_spritesheets
	var ass_fd = armour_spritesheets_frame_data
	var wss = weapon_spritesheets
	var wss_fd = weapon_spritesheets_frame_data
	
	if asc == null:
		asc = AppearanceSpritesheetContainer.new()
	else:
		pass

class AppearanceSpritesheetContainer extends Appearance:
	
	var base_spritesheets : Array[CompressedTexture2D]
	var base_spritesheets_frame_data : Array[Vector2i]
	var clothing_spritesheets : Array[CompressedTexture2D]
	var clothing_spritesheets_frame_data : Array[Vector2i]
	var equippable_spritesheets : Array[CompressedTexture2D]
	var equippable_spritesheets_frame_data : Array[Vector2i]
