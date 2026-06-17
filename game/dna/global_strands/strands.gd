class_name Strands extends RefCounted

const MAX_STRAND_LENGTH := 8
const MAX_BASE_VALUE := 99
const MIN_BASE_VALUE := -99


static func get_random_strand() -> DNAStrand:
	var strand := DNAStrand.new()
	var strand_length := 1 + randi() % (MAX_STRAND_LENGTH - 1)
	for i in strand_length:
		var shape := randi() % DNABase.Shape.size()
		var attribute := randi() % DNABase.Attribute.size()
		var value := MIN_BASE_VALUE + randi() % (-1 * MIN_BASE_VALUE + MAX_BASE_VALUE)
		strand.bases.append(DNABase.new(shape, attribute, value))
	return strand


static func get_demo_strand() -> DNAStrand:
	var strand := DNAStrand.new()
	
	var shape := DNABase.Shape.RoundSocket
	var attribute := DNABase.Attribute.HEALTH
	var value := 5
	strand.bases.append(DNABase.new(shape, attribute, value))
	
	shape = DNABase.Shape.RoundPlug
	attribute = DNABase.Attribute.DAMAGE
	value = 1
	strand.bases.append(DNABase.new(shape, attribute, value))
	
	shape = DNABase.Shape.PointySocket
	attribute = DNABase.Attribute.SPEED
	value = 1
	strand.bases.append(DNABase.new(shape, attribute, value))
	
	shape = DNABase.Shape.PointyPlug
	attribute = DNABase.Attribute.HEALTH
	value = -2
	
	strand.bases.append(DNABase.new(shape, attribute, value))
		
	return strand
