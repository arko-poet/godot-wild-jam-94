extends Node


func _ready() -> void:
	_test_one()
	#_test_two()
	print("PASS")


func _test_one() -> void:
	var strand_a := DNAStrand.new()
	var base_a1 := DNABase.new(DNABase.Shape.RoundSocket, DNABase.Attribute.HEALTH, 4)
	var base_a2 := DNABase.new(DNABase.Shape.PointyPlug, DNABase.Attribute.DAMAGE, 6)
	var base_a3 := DNABase.new(DNABase.Shape.RoundPlug, DNABase.Attribute.DAMAGE, -3)
	var base_a4 := DNABase.new(DNABase.Shape.PointySocket, DNABase.Attribute.SPEED, 1)
	strand_a.bases.append(base_a1)
	strand_a.bases.append(base_a2)
	strand_a.bases.append(base_a3)
	strand_a.bases.append(base_a4)
	
	var strand_b := DNAStrand.new()
	var base_b1 := DNABase.new(DNABase.Shape.RoundSocket, DNABase.Attribute.DAMAGE, 2)
	var base_b2 := DNABase.new(DNABase.Shape.RoundSocket, DNABase.Attribute.HEALTH, -3)
	var base_b3 := DNABase.new(DNABase.Shape.PointySocket, DNABase.Attribute.SPEED, 4)
	var base_b4 := DNABase.new(DNABase.Shape.RoundPlug, DNABase.Attribute.DAMAGE, 5)
	strand_b.bases.append(base_b1)
	strand_b.bases.append(base_b2)
	strand_b.bases.append(base_b3)
	strand_b.bases.append(base_b4)
	
	strand_a.combine_strands(strand_b, 2, true)
	
	assert(strand_a.bases.size() == 5)

	assert(strand_a.bases[0].value == 4)
	assert(strand_a.bases[0].attribute == DNABase.Attribute.HEALTH)
	assert(strand_a.bases[0].shape == DNABase.Shape.RoundSocket)

	assert(strand_a.bases[1].value == 6)
	assert(strand_a.bases[1].attribute == DNABase.Attribute.DAMAGE)
	assert(strand_a.bases[1].shape == DNABase.Shape.PointyPlug)

	assert(strand_a.bases[2].value == -1)
	assert(strand_a.bases[2].attribute ==  DNABase.Attribute.DAMAGE)
	assert(strand_a.bases[2].shape == DNABase.Shape.RoundPlug)

	assert(strand_a.bases[3].value == 4 or strand_a.bases[3].value == -4)
	assert(strand_a.bases[3].attribute == DNABase.Attribute.HEALTH or strand_a.bases[3].attribute ==  DNABase.Attribute.SPEED)
	assert(strand_a.bases[3].shape == DNABase.Shape.PointySocket or strand_a.bases[3].shape == DNABase.Shape.RoundSocket)

	assert(strand_a.bases[4].value == 4)
	assert(strand_a.bases[4].attribute == DNABase.Attribute.SPEED)
	assert(strand_a.bases[4].shape == DNABase.Shape.PointySocket)
