extends Node

var faceRight = true
var isAttacking = false
signal weapon_changed
#signal money_changed
signal accessory_changed
signal items_count_changed

var active_weapons = ["Cknife", "Bow", "Shotgun", "Sword", "SunshineBow", "Yamato"]
var active_accessories = ["Glove"]
#var money = 0 setget money_set
var i = 0
var current_weapon = active_weapons[i]
func _ready():
	connect("accessory_changed", self, "instance_accessory")

func _input(_event):
	if Input.is_action_just_pressed("weapon_change") and Utils.player.can_attack:
		i+=1
		if i >= active_weapons.size():
			i = 0
		current_weapon = active_weapons[i]
		emit_signal("weapon_changed")
