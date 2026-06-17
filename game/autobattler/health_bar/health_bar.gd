class_name CreatureDisplay extends TextureProgressBar

#const CREATURE_SPRITES := {
	#Creature.Species.TURTLE: "res://assets/art/AssetsArchibald_x2/ArchibaldStand.png",
	#Creature.Species.SALAMANDER: "res://assets/art/AssetsSalamander_x2/SalamanderStand.png"
#}

var creature: Creature


func set_creature(p_creature: Creature) -> void:
	creature = p_creature
	creature.health_changed.connect(_update_health)

	_update_health()


func _update_health() -> void:
	max_value = creature.max_health
	value = creature.health

#func do_turn(combat_log: RichTextLabel) -> void:
	#print("doing turn")
	#var combat_text = "{0} Does {1} [color=orange][b]DAMAGE[/b][/color]".format(
		#[member_name, stats.STRENGTH]
	#)
#
	#combat_log.append_text(combat_text)
	#combat_log.newline()
	#target_player.take_dmg(stats.STRENGTH, combat_log)


#func take_dmg(dmg: int, combat_log: RichTextLabel) -> void:
	#health -= dmg
	#print("took damage")
	#hp_bar.value = health
	#if health <= 0:
		#handle_death(combat_log)
	#pass
#
#
#func handle_death(combat_log: RichTextLabel) -> void:
	#dead = true
	#combat_log.append_text("{0} [color=red][b]DIES[/b][/color]".format([member_name]))
	#combat_log.newline()
	#print("died")
	##self.visible = false
