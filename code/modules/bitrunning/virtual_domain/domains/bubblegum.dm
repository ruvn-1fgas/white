/datum/lazy_template/virtual_domain/bubblegum
	name = "Логово, пропитанное кровью"
	cost = BITRUNNER_COST_HIGH
	desc = "Король демонов-убийц. Бубльгум - массивное, громоздкое чудовище, чей внешний вид прочно ассоциируется со смертью в муках."
	difficulty = BITRUNNER_DIFFICULTY_HIGH
	extra_loot = list(/obj/item/toy/plush/bubbleplush = 1)
	forced_outfit = /datum/outfit/job/miner
	key = "bubblegum"
	map_name = "bubblegum"
	reward_points = BITRUNNER_REWARD_HIGH
	safehouse_path = /datum/map_template/safehouse/lavaland_boss

/mob/living/simple_animal/hostile/megafauna/bubblegum/virtual_domain
	can_be_cybercop = FALSE
	crusher_loot = list(/obj/structure/closet/crate/secure/bitrunning/encrypted)
	health = 2000
	loot = list(/obj/structure/closet/crate/secure/bitrunning/encrypted)
	maxHealth = 2000
	true_spawn = FALSE
