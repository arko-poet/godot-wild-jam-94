class_name Autobattler extends Node

signal player_won
signal player_lost

const CREATURE_SPRITES := {
	Creature.Species.TURTLE0: "res://assets/art/AssetsArchibald_x2/ArchibaldStand.png",
	Creature.Species.SALAMANDER: "res://assets/art/AssetsSalamander_x2/SalamanderStand.png"
}

var ally: Creature
var enemy: Creature

var combat_on := false

@onready var ally_sprite: Sprite2D = %AllySprite
@onready var enemy_sprite: Sprite2D = %EnemySprite

@onready var ally_stats: StatsContainer = %AllyStats
@onready var enemy_stats: StatsContainer = %EnemyStats

@onready var ally_health_bar: CreatureDisplay = %AllyHealthBar
@onready var enemy_health_bar: CreatureDisplay = %EnemyHealthBar

@onready var combat_log: RichTextLabel = %CombatLog

@onready var world: Node2D = $World
@onready var ui: Control = $Overlay/UI

@onready var title_bar: TitleBar = %TitleBar


func set_creatures(p_ally: Creature, p_enemy: Creature) -> void:
	ally = p_ally
	enemy = p_enemy
	
	if not ally.died.is_connected(_on_ally_died):
		ally.died.connect(_on_ally_died)
	if not enemy.died.is_connected(_on_ally_died):
		enemy.died.connect(_on_enemy_died)
	
	ally_sprite.texture = Creatures.get_creature_texture(ally)
	enemy_sprite.texture = Creatures.get_creature_texture(enemy)
	
	ally_stats.creature = ally
	enemy_stats.creature = enemy
	
	ally_health_bar.creature = ally
	enemy_health_bar.creature = enemy
	
	combat_log.clear()
	

## shows/hides scene
func switch_scene(on := true) -> void:
	if on:
		world.show()
		ui.show()
	else:
		world.hide()
		ui.hide()


## shows/hides scene DEPRECATED
#func switch_scene(on := true) -> void:
	#for child in get_children():
		#if child is Control:
			#if on:
				#child.show()
			#else:
				#child.hide()
	#for child in overlay.get_children():
		#if child is Control:
			#if on:
				#child.show()
			#else:
				#child.hide()


func auto_battle() -> void:
	combat_on = true
	while combat_on:
		if ally.speed > enemy.speed:
			await _do_turn(ally)
			if combat_on:
				await _do_turn(enemy)
		else:
			await _do_turn(enemy)
			if combat_on:
				await _do_turn(ally)


#func auto_battle() -> void:
	#while not enemy_party.is_empty() and not ally_party.is_empty():
		#for party_member in turn_order:
			#if party_member.dead:
				#turn_order.erase(party_member)
				#if party_member in ally_party:
					#ally_party.erase(party_member)
				#else:
					#enemy_party.erase(party_member)
				#continue
#
			#var target_player: PartyMember
			#if party_member in ally_party:
				#target_player = enemy_party[0]
				#if target_player.dead:
					#enemy_party.erase(target_player)
					#turn_order.erase(target_player)
					#continue
			#else:
				#target_player = ally_party[0]
				#if target_player.dead:
					#ally_party.erase(target_player)
					#turn_order.erase(target_player)
					#continue
#
			#party_member.target_player = target_player
			#await get_tree().create_timer(1.0).timeout # TODO band aid to be remove
			#party_member.do_turn(%CombatLog)


func _do_turn(creature: Creature) -> void:
	await get_tree().create_timer(1.0).timeout
	
	var combat_text = "{0} Does {1} [color=orange][b]DAMAGE[/b][/color]".format(
		[creature.name, creature.damage]
	)
	combat_log.append_text(combat_text)
	combat_log.newline()
	
	if creature == enemy:
		ally.health -= enemy.damage
	else:
		enemy.health -= ally.damage


func _on_ally_died() -> void:
	combat_on = false
	
	_log_death(ally)

	player_lost.emit()
	

func _on_enemy_died() -> void:
	combat_on = false
	
	print(enemy.dead)
	enemy_sprite.texture = Creatures.get_creature_texture(enemy)
	
	_log_death(enemy)
	
	player_won.emit()


func _log_death(creature: Creature) -> void:
	combat_log.append_text("{0} [color=red][b]DIES[/b][/color]".format([creature.name]))
	combat_log.newline()
