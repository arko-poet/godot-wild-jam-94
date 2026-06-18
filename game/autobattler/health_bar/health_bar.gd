class_name CreatureDisplay extends TextureProgressBar


var creature: Creature:
	set(value):
		creature = value
		creature.health_changed.connect(_update_health)
		_update_health()


func _update_health() -> void:
	max_value = creature.max_health
	value = creature.health
