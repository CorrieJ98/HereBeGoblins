class_name Ability extends Resource

enum UnitBasicAbilities {GATHER,BUILD}
enum UnitSpecialAbilities{INVISIBLITY, TRUESIGHT, FLIGHT}
enum UnitTraits {HERO, WORKER, UNIQUE}

enum BuildingBasicAbilities {SPAWNUNITS,TECHUPGRADE}
enum BuildingSpecialAbilities {RALLYPOINT, TRUESIGHT,ATTACK}
enum BuildingTraits {UNIQUE}

class UnitAbilities extends Ability:
	enum UnitPassives {TRUESIGHT, FLIGHT}

class BuildingAbilities extends Ability:
	pass
