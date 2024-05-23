class_name BuildingResource extends UnitResourceAutoLoad

enum BuildingSubtypes {BARRACKS, TOWNHALL, WATCHTOWER}

@export_category("Basic Building Properties")
@export var name : String
@export_multiline var description : String
@export var subtype : BuildingSubtypes

@export_category("Building Advanced")
@export var health : int
@export var mesh : PackedScene

