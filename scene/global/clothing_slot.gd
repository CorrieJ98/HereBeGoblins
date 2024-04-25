class_name ClothingSlot extends Resource

enum SlotName {L_ARM,R_ARM,BACK,HEAD,TORSO,LEGS,FEET,WEAPON1,WEAPON2,HAIR1,HAIR2}

@export var slot_name : SlotName
@export var spritesheets : Array[CompressedTexture2D]
@export var spritesheet_frames_data : Array[Vector2i]
