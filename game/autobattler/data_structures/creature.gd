class_name Creature extends RefCounted

signal health_changed
signal died

## used for loading appropariate textures/animations
enum Species {
	TURTLE,
	SALAMANDER
}

var name: String
var species: Species

var dna_strand: DNAStrand

## these stats are a sum of base stats and dna_strand - these are used in combat
var max_health: int:
	set(value):
		max_health = value
		health = max_health
var damage: int
var speed: int
## current health state in combat
var health: int:
	set(value):
		health = max(0, value)
		health_changed.emit()
		if health == 0:
			died.emit()

var _base_health: int
var _base_damage: int
var _base_speed: int


func _init(p_name: String, p_dna_strand: DNAStrand, p_species := Species.SALAMANDER,
		p_base_health := 100, p_base_damage := 10, p_base_speed := 5) -> void:
	name = p_name
	species = p_species
	
	dna_strand = p_dna_strand
	dna_strand.strand_mutated.connect(_on_strand_mutated)
	
	_base_health = p_base_health
	_base_damage = p_base_damage
	_base_speed = p_base_speed
	
	_update_stats()


func _on_strand_mutated() -> void:
	_update_stats()


func _update_stats() -> void:
	max_health = _base_health + dna_strand.get_attribute_sum(DNABase.Attribute.HEALTH)
	damage = _base_damage + dna_strand.get_attribute_sum(DNABase.Attribute.DAMAGE)
	speed = _base_speed + dna_strand.get_attribute_sum(DNABase.Attribute.SPEED)
