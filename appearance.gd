class_name Appearance extends Resource

@export_category("Unit Details")
@export var name : String
@export_multiline var description : String

@export_category("Base model spritesheet")
@export var body_spritesheets : Array[CompressedTexture2D]
@export var body_spritesheets_frame_data : Array[Vector2i]
@export var portrait : CompressedTexture2D
@export var portrait_frame_data : Vector2i

@export_category("Gear slots")
@export var clothing_slots : Array[ClothingSlot]

func _ready():
	populate_arh(null,body_spritesheets, body_spritesheets_frame_data, clothing_slots)

func populate_arh(arh : AppearanceResourceHandler, base_spritesheet : Array[CompressedTexture2D], base_spritesheet_frame_data : Array[Vector2i],gear_slots : Array[ClothingSlot]):
	# Ensure there is a resource handler, otherwise create one
	# zero every array, and populate it with what is passed in
	if arh == null:
		arh = AppearanceResourceHandler.new()
	else:
		arh.base_spritesheets.clear()
		arh.base_spritesheets.append_array(base_spritesheet)
		
		arh.base_spritesheets_frame_data.clear()
		arh.base_spritesheets_frame_data.append_array(base_spritesheet_frame_data)
		
		arh.gear_slots.clear()
		arh.gear_slots.append_array(gear_slots)


class AppearanceResourceHandler extends Appearance:
	
	var base_spritesheets : Array[CompressedTexture2D]
	var base_spritesheets_frame_data : Array[Vector2i]
	var gear_slots : Array[ClothingSlot]
	
	func vector_to_frame_data(v2in : Vector2i, vframe : int, hframe : int) -> void:
		if v2in != null:
			vframe = v2in.y
			hframe = v2in.x
		else:
			vframe = 1
			hframe = 1
	
	func unpack_gear_arrays():
		pass
	
	func resource_to_sprite(cs : ClothingSlot):
		pass
	
	func get_sprites():
		pass
