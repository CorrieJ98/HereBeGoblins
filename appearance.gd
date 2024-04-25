class_name Appearance extends Resource

@export_category("Unit Details")
@export var name : String
@export_multiline var description : String

@export_category("Base model spritesheet")
@export var body_spritesheets : Array[CompressedTexture2D]
@export var body_spritesheets_frame_data : Array[Vector2i]
@export var portrait : CompressedTexture2D
@export var portrait_frame_data : Vector2i

# TODO need more armour types - currently this only covers a
# single armour segment (ie Beastmaster_Back) when there are several
# that need a category. Array[Array[CompressedTexture2D]] is not
# supported so i need another method. Maybe an exported int to
# instantiate new arrays as per how many clothing slots are needed.

@export_category("Clothing slots")
@export var clothing_slot : Array[ClothingSlot]

@export_category("OBSOLETE!!!! Armour and clothing spritesheets") 
@export var armour_slots : Array[String]
@export var armour_spritesheets : Array[CompressedTexture2D]
@export var armour_spritesheets_frame_data : Array[Vector2i]

@export_category("Weapon spritesheets")
@export var weapon_spritesheets : Array[CompressedTexture2D]
@export var weapon_spritesheets_frame_data : Array[Vector2i]

func _ready():
	populate_arh(null,body_spritesheets,
	body_spritesheets_frame_data,
	armour_spritesheets,
	armour_spritesheets_frame_data,
	weapon_spritesheets,weapon_spritesheets_frame_data)


# This is just silly, late night code. Theres a future issue here.
func populate_arh(arh : AppearanceResourceHandler, base_spritesheet : Array[CompressedTexture2D], base_spritesheet_frame_data : Array[Vector2i],armour_spritesheets : Array[CompressedTexture2D], armour_spritesheet_frame_data : Array[Vector2i], weapon_spritesheets : Array[CompressedTexture2D], weapon_spritesheets_frame_data : Array[Vector2i]):
	
	# aliases to make this absolute mess easier to read
	var bss = base_spritesheet
	var bss_fd = base_spritesheet_frame_data
	var ass = armour_spritesheets
	var ass_fd = armour_spritesheets_frame_data
	var wss = weapon_spritesheets
	var wss_fd = weapon_spritesheets_frame_data
	
	# Ensure there is a resource handler, otherwise create one
	# zero every array, and populate it with what is passed in
	if arh == null:
		arh = AppearanceResourceHandler.new()
	else:
		arh.base_spritesheets.clear()
		arh.base_spritesheets.append_array(bss)
		
		arh.base_spritesheets_frame_data.clear()
		arh.base_spritesheets_frame_data.append_array(bss_fd)
		
		arh.clothing_spritesheets.clear()
		arh.clothing_spritesheets.append_array(ass)
		
		arh.clothing_spritesheets_frame_data.clear()
		arh.clothing_spritesheets_frame_data.append_array(ass_fd)
		
		arh.equippable_spritesheets.clear()
		arh.equippable_spritesheets.append_array(wss)
		
		arh.equippable_spritesheets_frame_data.clear()
		arh.equippable_spritesheets_frame_data.append_array(wss_fd)

class AppearanceResourceHandler extends Appearance:
	
	var base_spritesheets : Array[CompressedTexture2D]
	var base_spritesheets_frame_data : Array[Vector2i]
	var clothing_spritesheets : Array[CompressedTexture2D]
	var clothing_spritesheets_frame_data : Array[Vector2i]
	var equippable_spritesheets : Array[CompressedTexture2D]
	var equippable_spritesheets_frame_data : Array[Vector2i]
	
	func _get_array_size(arr : Array) -> int:
		return arr.size()
	
	func vector_to_frame_data(v2in : Vector2i, vframe : int, hframe : int) -> void:
		if v2in != null:
			vframe = v2in.y
			hframe = v2in.x
		else:
			vframe = 1
			hframe = 1
