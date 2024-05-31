# HereBeGoblins
## Coding standards and nomenclature within Godot 4 and GDScript

Everything you see before you is a work in progress and subject to change

Formatted for viewing within Godot 4 code editor

___

### GDScript

`func foo_name(param1,param2,param3)` or `func foo_name(p1 : type, p2 : type)`

`const k_const_name : type = value` or `const k_const_name := type()` or `const k_const_name := []` 

`enum EnumName{PARAM1,PARAM2,PARAM3}`

`var var_name : type = value` or `var varname := type()` or `var varname := []` 


### Filenames
Script Names:
	ScriptName.gd
	SuperClassScriptName.gd
		SuperClassScriptName--subclass_script_name.gd
	
	Autoload Scripts:
		_AutoLoadScriptName.gd
		_AUTO_LOAD_COMMON_VAR or _COMVAR (condensed variable name)
 
Scene Names:
	scene_name.tscn

Resources:
	Textures:
		
	Materials:
		
	Meshes:
		
	Sprites:
		
	Custom Resources:
		

