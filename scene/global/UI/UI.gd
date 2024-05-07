class_name UI extends CanvasLayer

func _on_select(profile):
	# pass selected unit profile
	pass

class HUD extends UI:
	enum SelectedObjectType {BUILDING, UNIT}
	
	var profile = null     # not typed as to take either UnitProfile or BuildingProfile
	
	
	# on selection, get the objects profile and import that data
	# to here and display it
	
	# on deselect, wipe the hud back to its barebones
