class_name Creatures extends RefCounted

#AssetsArchibald_x2/ArchibaldMutation_4
#idle
const DEAD_DIRECTORY := "dead"
const IDLE_DIRECTORY := "idle"
const SPRITE_PATH := "res://assets/art/Assets%s/%s/frame0000.png"
const AUDIO_PATH := "res://assets/sfx/aaron/SFX for Teenage Mutant Ninja Animals Game/SFX for Teenage Mutant Ninja Animals Game/%s"
const CREATURE_SPRITE_PATHS := {
	Creature.Species.TURTLE0: "Archibald_x2/ArchibaldMutation_0",
	Creature.Species.TURTLE1: "Archibald_x2/ArchibaldMutation_1",
	Creature.Species.TURTLE2: "Archibald_x2/ArchibaldMutation_2",
	Creature.Species.TURTLE3: "Archibald_x2/ArchibaldMutation_3",
	Creature.Species.TURTLE4: "Archibald_x2/ArchibaldMutation_4",
	Creature.Species.TURTLE5: "Archibald_x2/ArchibaldMutation_5",
	Creature.Species.TURTLE6: "Archibald_x2/ArchibaldMutation_6",
	Creature.Species.TURTLE7: "Archibald_x2/ArchibaldMutation_7",
	Creature.Species.TURTLE8: "Archibald_x2/ArchibaldMutation_8",
	Creature.Species.BYAKA: "Byaka_x2",
	Creature.Species.FLYGRUB: "Flygrub_x2",
	Creature.Species.SALAMANDER: "Salamander_x2",
	Creature.Species.FLESHMANCER: "Fleshmancer_x2"
}
const CREATURE_NAMES := {
	Creature.Species.BYAKA: "Byaka",
	Creature.Species.FLYGRUB: "Flygrub",
	Creature.Species.SALAMANDER: "Salamander",
	Creature.Species.FLESHMANCER: "Fleshmancer"
}
const CREATURE_AUDIO_PATHS := {
	Creature.Species.TURTLE0: "Stage I/Archibald I Roar 1.wav",
	Creature.Species.TURTLE1: "Stage I/Archibald I Roar 1.wav",
	Creature.Species.TURTLE2: "Stage II/Archibald II Roar 1.wav",
	Creature.Species.TURTLE3: "Stage II/Archibald II Roar 1.wav",
	Creature.Species.TURTLE4: "Stage II/Archibald II Roar 1.wav",
	Creature.Species.TURTLE5: "Stage IV/Archibald IV Roar 2.wav",
	Creature.Species.TURTLE6: "Stage IV/Archibald IV Roar 2.wav",
	Creature.Species.TURTLE7: "Stage IV/Archibald IV Roar 2.wav",
	Creature.Species.TURTLE8: "Stage IV/Archibald IV Roar 2.wav",
	Creature.Species.BYAKA: "Stage I/Enemy I Vocalization 3.wav",
	Creature.Species.FLYGRUB: "Stage II/Enemy II Buzz.wav",
	Creature.Species.SALAMANDER: "Stage III/Salamander Sound 1.wav",
	Creature.Species.FLESHMANCER: "Stage IV/Enemy IV Growl 1.wav"
	}


static func get_creature_texture(creature: Creature) -> Texture2D:
	var creature_sprite_path: String = CREATURE_SPRITE_PATHS[creature.species]
	var sub_directory := DEAD_DIRECTORY if creature.dead else IDLE_DIRECTORY
	return load(SPRITE_PATH % [creature_sprite_path, sub_directory])

static func get_creature_audio(creature: Creature) -> AudioStreamWAV:
	var creature_audio_path: String = CREATURE_AUDIO_PATHS[creature.species]
	return load(AUDIO_PATH % creature_audio_path)

static func get_enemy(level: int) -> Creature:
	if level <= 2:
		return get_byaka(level)
	elif level <= 4:
		return get_flygrub(level)
	elif level <= 6:
		return get_salamander(level)
	elif level == 7:
		return get_fleshmancer(level)
	else:
		return get_random_enemy(level)


static func get_byaka(level: int) -> Creature:
	var species := Creature.Species.BYAKA
	return Creature.new(CREATURE_NAMES[species], DNAStrand.new(), species, 5 + level, 5 + level, 3 + level)


static func get_flygrub(level: int) -> Creature:
	var species := Creature.Species.FLYGRUB
	return Creature.new(CREATURE_NAMES[species], DNAStrand.new(), species, 5 + level, 5 + level, 3 + level)


static func get_salamander(level: int) -> Creature:
	var species := Creature.Species.SALAMANDER
	return Creature.new(CREATURE_NAMES[species], DNAStrand.new(), species, 5 + level, 5 + level, 3 + level)


static func get_fleshmancer(level: int) -> Creature:
	var species := Creature.Species.FLESHMANCER
	var creature := Creature.new(CREATURE_NAMES[species], DNAStrand.new(), species, 666, 5 + level, 3 + level)
	creature.max_health = 666
	return creature

static func get_random_enemy(level: int) -> Creature:
	var species := 9 + randi() % 4
	return Creature.new(CREATURE_NAMES[species], DNAStrand.new(), species,  5 + level, 5 + level, 3 + level)
