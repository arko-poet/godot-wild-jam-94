class_name DNAStrand extends RefCounted

signal strand_mutated

var bases: Array[DNABase]
var stats: Stats

func _init(incoming_stats: Stats):
	stats = incoming_stats


## modifies the bases of this DNAStrand by the incoming_strand
##
## position: where the beginning of the incoming strand is positioned relative to the this DNAStrand
##
## Genetic Operations:
## 1. Conservation = no aligned base from incoming strand so base does not change 
## 2. Evolution = bases match so base value is added
## 3. Mutation = bases don't match so random change occurs
## 4. Growth = 1 incoming base is added if it has no pair in this DNAStrand
## 5. Rejection = remaining incoming DNA bases get rejected
func combine_strands(
		incoming_strand: DNAStrand, position: int, mutation_allowed: bool = false
) -> void:
	assert(incoming_strand.bases.size() > 0)
	assert(position < Strands.MAX_STRAND_LENGTH)
	assert(incoming_strand.bases.size() + position > 0)
	
	var new_bases: Array[DNABase]
	for base_index in bases.size():
		var incoming_strand_index = base_index - position
		var base = bases[base_index]
		
		# if this check fails then base doesn't change -> Convervation
		if (
			incoming_strand_index < incoming_strand.bases.size()
			and incoming_strand_index >= 0 and base_index >= position
		):
			var incoming_base = incoming_strand.bases[incoming_strand_index]
			# Evolution
			if base.is_matching(incoming_base):
				base.value += incoming_base.value
			# Mutation
			elif mutation_allowed:
				if randf() < 0.5:
					incoming_base.value -= base.value
					base = incoming_base
				else: # Conservation
					base.value -= incoming_base.value
		
		new_bases.append(base)
	
	# Growth
	if position + incoming_strand.bases.size() > bases.size():
		var growth_index = bases.size() - position
		var growth_base := incoming_strand.bases[growth_index]
		new_bases.append(growth_base)
	
	# Rejection
	# Remaining bases in incoming strand get ignored
			
	bases = new_bases
	strand_mutated.emit()


func get_attribute_sum(attribute: DNABase.Attribute) -> int:
	var sum := 0
	for base in bases:
		if base.attribute == attribute:
			sum += base.value
	return sum
