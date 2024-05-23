class_name CairnResource extends UnitResourceAutoLoad

enum CairnSubtypes {BONUS, TRIGGER}

@export_category("Cairn Properties")
@export var name : String
@export_multiline var description : String
@export var subtype : CairnSubtypes

@export_category("Advanced")
@export var bounty_reward : int
@export var connect_trigger_func_call : String


@export var mesh : PackedScene

