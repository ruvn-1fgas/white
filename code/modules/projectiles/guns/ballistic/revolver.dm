/obj/item/gun/ballistic/revolver
	name = ".357 револьвер"
	desc = "Подозрительный револьвер. Калибр 0.357."
	icon_state = "revolver"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	load_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	eject_sound = 'sound/weapons/gun/revolver/empty.ogg'
	fire_sound_volume = 90
	dry_fire_sound = 'sound/weapons/gun/revolver/dry_fire.ogg'
	casing_ejector = FALSE
	internal_magazine = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	tac_reloads = FALSE
	var/spin_delay = 10
	var/recent_spin = 0
	var/last_fire = 0

/obj/item/gun/ballistic/revolver/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	..()
	last_fire = world.time


/obj/item/gun/ballistic/revolver/chamber_round(spin_cylinder = TRUE, replace_new_round)
	if(!magazine) //if it mag was qdel'd somehow.
		CRASH("револьвер пытается выстрелить без барабана внутри!")
	if(chambered)
		UnregisterSignal(chambered, COMSIG_MOVABLE_MOVED)
	if(spin_cylinder)
		chambered = magazine.get_round(TRUE)
	else
		chambered = magazine.stored_ammo[1]
	if(chambered)
		RegisterSignal(chambered, COMSIG_MOVABLE_MOVED, PROC_REF(clear_chambered))

/obj/item/gun/ballistic/revolver/shoot_with_empty_chamber(mob/living/user as mob|obj)
	..()
	chamber_round()

/obj/item/gun/ballistic/revolver/AltClick(mob/user)
	..()
	spin()

/obj/item/gun/ballistic/revolver/fire_sounds()
	var/frequency_to_use = sin((90/magazine?.max_ammo) * get_ammo(TRUE, FALSE)) // fucking REVOLVERS
	var/click_frequency_to_use = 1 - frequency_to_use * 0.75
	var/play_click = sqrt(magazine?.max_ammo) > get_ammo(TRUE, FALSE)
	if(suppressed)
		playsound(src, suppressed_sound, suppressed_volume, vary_fire_sound, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
		if(play_click)
			playsound(src, 'sound/weapons/gun/general/ballistic_click.ogg', suppressed_volume, vary_fire_sound, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0, frequency = click_frequency_to_use)
	else
		playsound(src, fire_sound, fire_sound_volume, vary_fire_sound)
		if(play_click)
			playsound(src, 'sound/weapons/gun/general/ballistic_click.ogg', fire_sound_volume, vary_fire_sound, frequency = click_frequency_to_use)


/obj/item/gun/ballistic/revolver/verb/spin()
	set name = "Вращает барабан"
	set category = "Object"
	set desc = "Клик чтобы прокрутить барабан."

	var/mob/M = usr

	if(M.stat || !in_range(M,src))
		return

	if (recent_spin > world.time)
		return
	recent_spin = world.time + spin_delay

	if(do_spin())
		playsound(usr, SFX_REVOLVER_SPIN, 30, FALSE)
		usr.visible_message(span_notice("[usr] вращает [src] барабан."), span_notice("Ты вращаешь [src] барабан."))
	else
		verbs -= /obj/item/gun/ballistic/revolver/verb/spin

/obj/item/gun/ballistic/revolver/proc/do_spin()
	var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
	. = istype(C)
	if(.)
		C.spin()
		chamber_round(spin_cylinder = FALSE)

/obj/item/gun/ballistic/revolver/get_ammo(countchambered = FALSE, countempties = TRUE)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/gun/ballistic/revolver/examine(mob/user)
	. = ..()
	var/live_ammo = get_ammo(FALSE, FALSE)
	. += "[live_ammo ? live_ammo : "Нет"] заряженных патронов."
	if (current_skin)
		. += "Можно прокрутить барабан с помощью <b>alt+клик</b>"

/obj/item/gun/ballistic/revolver/ignition_effect(atom/A, mob/user)
	if(last_fire && last_fire + 15 SECONDS > world.time)
		. = span_notice("[user] касается кончиком [src] к [A], используя остаточный жар ствола чтобы закурить. Жесть он крут.")

/obj/item/gun/ballistic/revolver/c38
	name = ".38 револьвер"
	desc = "Классическое смертоносное огнестрельное оружие. Использует специальные патроны калибра .38."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38
	icon_state = "c38"
	fire_sound = 'sound/weapons/gun/revolver/shot.ogg'

/obj/item/gun/ballistic/revolver/c38/detective
	name = "Colt Detective Special"
	desc = "Классическое огнестрельное оружие правоохранительных органов. Использует специальные патроны .38. \nНекоторые распространяют слухи, что если ослабить ствол гаечным ключом, то можно вставить патроны другого калибра."

	can_modify_ammo = TRUE
	initial_caliber = CALIBER_38
	initial_fire_sound = 'sound/weapons/gun/revolver/shot.ogg'
	alternative_caliber = CALIBER_357
	alternative_fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	alternative_ammo_misfires = TRUE
	misfire_probability = 0
	misfire_percentage_increment = 25 //about 1 in 4 rounds, which increases rapidly every shot

	obj_flags = UNIQUE_RENAME
	unique_reskin = list(
		"Default" = "c38",
		"Fitz Special" = "c38_fitz",
		"Police Positive Special" = "c38_police",
		"Blued Steel" = "c38_blued",
		"Stainless Steel" = "c38_stainless",
		"Gold Trim" = "c38_trim",
		"Golden" = "c38_gold",
		"The Peacemaker" = "c38_peacemaker",
		"Black Panther" = "c38_panther"
	)

/obj/item/gun/ballistic/revolver/syndicate
	name = "Револьвер Синдиката"
	desc = "Модернизированный семизарядный револьвер производства Waffle Co. Использует патроны .357."
	icon_state = "revolversyndie"

/obj/item/gun/ballistic/revolver/syndicate/nuclear
	pin = /obj/item/firing_pin/implant/pindicate

/obj/item/gun/ballistic/revolver/syndicate/cowboy
	desc = "Классический револьвер, переоборудованный для современного использования. Использует патроны .357."
	//There's already a cowboy sprite in there!
	icon_state = "lucky"

/obj/item/gun/ballistic/revolver/syndicate/cowboy/nuclear
	pin = /obj/item/firing_pin/implant/pindicate

/obj/item/gun/ballistic/revolver/mateba
	name = "Unica 6 автоматический револьвер"
	desc = "Мощный ретро-авторевольвер, обычно используемый офицерами армии Новороссии. Использует патроны .357."
	icon_state = "mateba"

/obj/item/gun/ballistic/revolver/golden
	name = "Золотой револьвер"
	desc = "This ain't no game, ain't never been no show, And I'll gladly gun down the oldest lady you know. Uses .357 ammo."
	icon_state = "goldrevolver"
	fire_sound = 'sound/weapons/resonator_blast.ogg'
	recoil = 8
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/nagant
	name = "Наган"
	desc = "Старый револьвер разработанный в России. Может использоваться с глушителем. Использует патроны 7.62x38mmR."
	icon_state = "nagant"
	can_suppress = TRUE

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rev762


// A gun to play Russian Roulette!
// You can spin the chamber to randomize the position of the bullet.

/obj/item/gun/ballistic/revolver/russian
	name = "Русский револьвер"
	desc = "Револьвер российского производства, предназначенный для застольных игр. Использует патроны калибра .357 и имеет механизм, требующий перед каждым взведением курка досылать патрон в патронник."
	icon_state = "russianrevolver"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rus357
	var/spun = FALSE
	hidden_chambered = TRUE //Cheater.
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/ballistic/revolver/russian/do_spin()
	. = ..()
	if(.)
		spun = TRUE

/obj/item/gun/ballistic/revolver/russian/attackby(obj/item/A, mob/user, params)
	..()
	if(get_ammo() > 0)
		spin()
	update_appearance()
	A.update_appearance()
	return

/obj/item/gun/ballistic/revolver/russian/can_trigger_gun(mob/living/user, akimbo_usage)
	if(akimbo_usage)
		return FALSE
	return ..()

/obj/item/gun/ballistic/revolver/russian/attack_self(mob/user)
	if(!spun)
		spin()
		spun = TRUE
		return
	..()

/obj/item/gun/ballistic/revolver/russian/fire_gun(atom/target, mob/living/user, flag, params)
	. = ..(null, user, flag, params)

	if(flag)
		if(!(target in user.contents) && ismob(target))
			if(user.combat_mode) // Flogging action
				return

	if(isliving(user))
		if(!can_trigger_gun(user))
			return
	if(target != user)
		playsound(src, dry_fire_sound, 30, TRUE)
		user.visible_message(
			span_danger("[user.name] пытается выстрелить [src] в это же время, но выставляет себя посмешищем."), \
			span_danger(" [src] специальный механизм не даёт возможности стрелять в кого либо, только в себя!"))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!spun)
			to_chat(user, span_warning("Следует сперва прокрутить [src] барабан!"))
			return

		spun = FALSE

		var/zone = check_zone(user.zone_selected)
		var/obj/item/bodypart/affecting = H.get_bodypart(zone)
		var/is_target_face = zone == BODY_ZONE_HEAD || zone == BODY_ZONE_PRECISE_EYES || zone == BODY_ZONE_PRECISE_MOUTH
		var/loaded_rounds = get_ammo(FALSE, FALSE) // check before it is fired

		if(loaded_rounds && is_target_face)
			add_memory_in_range(user, 7, /datum/memory/witnessed_russian_roulette, \
				protagonist = user, \
				antagonist = src, \
				rounds_loaded = loaded_rounds, \
				aimed_at =  affecting.name, \
				result = (chambered ? "проиграл" : "выиграл"))

		if(chambered)
			if(HAS_TRAIT(user, TRAIT_CURSED)) // I cannot live, I cannot die, trapped in myself, body my holding cell.
				to_chat(user, span_warning("Какая ужасная ночь...Чтобы быть проклятым!"))
				return
			var/obj/item/ammo_casing/AC = chambered
			if(AC.fire_casing(user, user, params, distro = 0, quiet = 0, zone_override = null, spread = 0, fired_from = src))
				playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
				if(is_target_face)
					shoot_self(user, affecting)
				else
					user.visible_message(span_danger("[user.name] трусливо стреляет [src] в [user.p_their()] [affecting.name]!"), span_userdanger("Ты трусливо стреляешь [src] в своё [affecting.name]!"), span_hear("Ты слышишь выстрел!"))
				chambered = null
				user.add_mood_event("russian_roulette_lose", /datum/mood_event/russian_roulette_lose)
				return

		if(loaded_rounds && is_target_face)
			user.add_mood_event("russian_roulette_win", /datum/mood_event/russian_roulette_win, loaded_rounds)

		user.visible_message(span_danger("*щёлк*"))
		playsound(src, dry_fire_sound, 30, TRUE)

/obj/item/gun/ballistic/revolver/russian/proc/shoot_self(mob/living/carbon/human/user, affecting = BODY_ZONE_HEAD)
	user.apply_damage(300, BRUTE, affecting)
	user.visible_message(span_danger("[user.name] стреляет [src] в [user.p_their()] голову!"), span_userdanger("Ты стреляешь [src] в свою голову!"), span_hear("Ты слышишь выстрел!"))

/obj/item/gun/ballistic/revolver/russian/soul
	name = "проклятый Русский револьвер"
	desc = "Чтобы сыграть с этим револьвером потребуется поставить свою душу на кон."

/obj/item/gun/ballistic/revolver/russian/soul/shoot_self(mob/living/user)
	. = ..()
	var/obj/item/soulstone/anybody/revolver/stone = new /obj/item/soulstone/anybody/revolver(get_turf(src))
	if(!stone.capture_soul(user, forced = TRUE)) //Something went wrong
		qdel(stone)
		return
	user.visible_message(span_danger("[user.name] душа захвачена [src]!"), span_userdanger("Ты проиграл свою ставку! Душа утеряна навсегда"))

/obj/item/gun/ballistic/revolver/reverse //Fires directly at its user... unless the user is a clown, of course.
	clumsy_check = FALSE
	icon_state = "revolversyndie"

/obj/item/gun/ballistic/revolver/reverse/Initialize(mapload)
	. = ..()
	var/obj/item/gun/ballistic/revolver/syndicate/syndie_revolver = /obj/item/gun/ballistic/revolver/syndicate
	name = initial(syndie_revolver.name)
	desc = initial(syndie_revolver.desc)

/obj/item/gun/ballistic/revolver/reverse/can_trigger_gun(mob/living/user, akimbo_usage)
	if(akimbo_usage)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_CLUMSY) || is_clown_job(user.mind?.assigned_role))
		return ..()
	if(process_fire(user, user, FALSE, null, BODY_ZONE_HEAD))
		user.visible_message(span_warning("[user] как-то умудряется выстрелить [user.p_them()] в лицо!"), span_userdanger("Каким-то образом ты стреляешь в своё лицо! Какого чёрта?!"))
		user.emote("scream")
		user.drop_all_held_items()
		user.Paralyze(80)
