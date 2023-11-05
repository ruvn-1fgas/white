//Brain traumas that are rare and/or somewhat beneficial;
//they are the easiest to cure, which means that if you want
//to keep them, you can't cure your other traumas
/datum/brain_trauma/special
	abstract_type = /datum/brain_trauma/special

/datum/brain_trauma/special/godwoken
	name = "Cиндром бога"
	desc = "Пациент иногда впадает в транс и становится гласом древних богов, когда разговаривает."
	scan_desc = "<b>синдрома бога</b>"
	gain_text = span_notice("Чувствую высшую силу внутри разума...")
	lose_text = span_warning("Божественное присутствие покидает голову.")

/datum/brain_trauma/special/godwoken/on_life(seconds_per_tick, times_fired)
	..()
	if(SPT_PROB(2, seconds_per_tick))
		if(prob(33) && (owner.IsStun() || owner.IsParalyzed() || owner.IsUnconscious()))
			speak("unstun", TRUE)
		else if(prob(60) && owner.health <= owner.crit_threshold)
			speak("heal", TRUE)
		else if(prob(30) && owner.combat_mode)
			speak("aggressive")
		else
			speak("neutral", prob(25))

/datum/brain_trauma/special/godwoken/on_gain()
	ADD_TRAIT(owner, TRAIT_HOLY, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/special/godwoken/on_lose()
	REMOVE_TRAIT(owner, TRAIT_HOLY, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/special/godwoken/proc/speak(type, include_owner = FALSE)
	var/message
	switch(type)
		if("unstun")
			message = pick_list_replacements(BRAIN_DAMAGE_FILE, "god_unstun")
		if("heal")
			message = pick_list_replacements(BRAIN_DAMAGE_FILE, "god_heal")
		if("neutral")
			message = pick_list_replacements(BRAIN_DAMAGE_FILE, "god_neutral")
		if("aggressive")
			message = pick_list_replacements(BRAIN_DAMAGE_FILE, "god_aggressive")
		else
			message = pick_list_replacements(BRAIN_DAMAGE_FILE, "god_neutral")

	playsound(get_turf(owner), 'sound/magic/clockwork/invoke_general.ogg', 200, TRUE, 5)
	voice_of_god(message, owner, list("colossus","yell"), 2.5, include_owner, name, TRUE)

/datum/brain_trauma/special/bluespace_prophet
	name = "Блюспейс пророчество"
	desc = "Пациент может ощущать движение и переплетение блюспейса вокруг себя, открывая для них проходы, которые никто другой не может видеть."
	scan_desc = "<b>созвучия блюспейса</b>"
	gain_text = span_notice("Чувствую, как голубое пространство пульсирует вокруг...")
	lose_text = span_warning("Слабая пульсация синего пространства исчезает в тишине.")
	/// Cooldown so we can't teleport literally everywhere on a whim
	COOLDOWN_DECLARE(portal_cooldown)

/datum/brain_trauma/special/bluespace_prophet/on_life(seconds_per_tick, times_fired)
	if(!COOLDOWN_FINISHED(src, portal_cooldown))
		return

	COOLDOWN_START(src, portal_cooldown, 10 SECONDS)
	var/list/turf/possible_turfs = list()
	for(var/turf/T as anything in RANGE_TURFS(8, owner))
		if(T.density)
			continue

		var/clear = TRUE
		for(var/obj/O in T)
			if(O.density)
				clear = FALSE
				break
		if(clear)
			possible_turfs += T

	if(!LAZYLEN(possible_turfs))
		return

	var/turf/first_turf = pick(possible_turfs)
	if(!first_turf)
		return

	possible_turfs -= (possible_turfs & range(first_turf, 3))

	var/turf/second_turf = pick(possible_turfs)
	if(!second_turf)
		return

	var/obj/effect/client_image_holder/bluespace_stream/first = new(first_turf, owner)
	var/obj/effect/client_image_holder/bluespace_stream/second = new(second_turf, owner)

	first.linked_to = second
	second.linked_to = first

/obj/effect/client_image_holder/bluespace_stream
	name = "Блюспейс поток"
	desc = "Скрытый путь через блюспейс..."
	image_icon = 'icons/effects/effects.dmi'
	image_state = "bluestream"
	image_layer = ABOVE_MOB_LAYER
	image_plane = GAME_PLANE_UPPER
	var/obj/effect/client_image_holder/bluespace_stream/linked_to

/obj/effect/client_image_holder/bluespace_stream/Initialize(mapload, list/mobs_which_see_us)
	. = ..()
	QDEL_IN(src, 30 SECONDS)

/obj/effect/client_image_holder/bluespace_stream/Destroy()
	if(!QDELETED(linked_to))
		qdel(linked_to)
	linked_to = null
	return ..()

/obj/effect/client_image_holder/bluespace_stream/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(!(user in who_sees_us) || !linked_to)
		return

	var/slip_in_message = pick("скользит в сторону странным образом и исчезает", "прыгает в невидимое измерение",\
		"выставляет одну ногу прямо, [user.ru_ego()] дергает ногой, и внезапно исчезает", "останавливается, а затем выпадает из реальности", \
		"втягивается в невидимый водоворот, исчезая из поля зрения")
	var/slip_out_message = pick("бесшумно появляется", "появляется прямо из воздуха","появляется", "выходит из невидимой двери",\
		"выскальзывает из складки пространства-времени")

	to_chat(user, span_notice("Пытаюсь войти в блюспейс поток..."))
	if(!do_after(user, 2 SECONDS, target = src))
		return

	var/turf/source_turf = get_turf(src)
	var/turf/destination_turf = get_turf(linked_to)

	new /obj/effect/temp_visual/bluespace_fissure(source_turf)
	new /obj/effect/temp_visual/bluespace_fissure(destination_turf)

	user.visible_message(span_warning("[user] [slip_in_message]."), ignored_mobs = user)

	if(do_teleport(user, destination_turf, no_effects = TRUE))
		user.visible_message(span_warning("[user] [slip_out_message]."), span_notice("...and find your way to the other side."))
	else
		user.visible_message(span_warning("[user] [slip_out_message], ending up exactly where they left."), span_notice("...and find yourself where you started?"))


/obj/effect/client_image_holder/bluespace_stream/attack_tk(mob/user)
	to_chat(user, span_warning("\The [src] actively rejects your mind, and the bluespace energies surrounding it disrupt your telekinesis!"))
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/brain_trauma/special/quantum_alignment
	name = "Квантовая связь"
	desc = "Пациент склонен к частым спонтанным квантовым запутываниям, вопреки всему, вызывающим пространственные аномалии."
	scan_desc = "<b>квантовой связи</b>"
	gain_text = span_notice("Чувствую слабую связь со всем, что меня окружает...")
	lose_text = span_warning("Больше не чувствую связи со своим окружением.")
	var/atom/linked_target = null
	var/linked = FALSE
	var/returning = FALSE
	/// Cooldown for snapbacks
	COOLDOWN_DECLARE(snapback_cooldown)

/datum/brain_trauma/special/quantum_alignment/on_life(seconds_per_tick, times_fired)
	if(linked)
		if(QDELETED(linked_target))
			linked_target = null
			linked = FALSE
			return
		if(!returning && COOLDOWN_FINISHED(src, snapback_cooldown))
			start_snapback()
		return
	if(SPT_PROB(2, seconds_per_tick))
		try_entangle()

/datum/brain_trauma/special/quantum_alignment/proc/try_entangle()
	//Check for pulled mobs
	if(ismob(owner.pulling))
		entangle(owner.pulling)
		return
	//Check for adjacent mobs
	for(var/mob/living/L in oview(1, owner))
		if(owner.Adjacent(L))
			entangle(L)
			return
	//Check for pulled objects
	if(isobj(owner.pulling))
		entangle(owner.pulling)
		return

	//Check main hand
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item && !(HAS_TRAIT(held_item, TRAIT_NODROP)))
		entangle(held_item)
		return

	//Check off hand
	held_item = owner.get_inactive_held_item()
	if(held_item && !(HAS_TRAIT(held_item, TRAIT_NODROP)))
		entangle(held_item)
		return

	//Just entangle with the turf
	entangle(get_turf(owner))

/datum/brain_trauma/special/quantum_alignment/proc/entangle(atom/target)
	to_chat(owner, span_notice("Начинаю испытывать сильное чувство связи с [target]."))
	linked_target = target
	linked = TRUE
	COOLDOWN_START(src, snapback_cooldown, rand(45 SECONDS, 10 MINUTES))

/datum/brain_trauma/special/quantum_alignment/proc/start_snapback()
	if(QDELETED(linked_target))
		linked_target = null
		linked = FALSE
		return
	to_chat(owner, span_warning("Ощущаю сильную связь с [linked_target]... физически ощущаю притяжение!"))
	owner.playsound_local(owner, 'sound/magic/lightning_chargeup.ogg', 75, FALSE)
	returning = TRUE
	addtimer(CALLBACK(src, PROC_REF(snapback)), 100)

/datum/brain_trauma/special/quantum_alignment/proc/snapback()
	returning = FALSE
	if(QDELETED(linked_target))
		to_chat(owner, span_notice("Связь резко обрывается, а вместе с ней и притяжение."))
		linked_target = null
		linked = FALSE
		return
	to_chat(owner, span_warning("Меня тянет сквозь пространство и время!"))
	do_teleport(owner, get_turf(linked_target), null, channel = TELEPORT_CHANNEL_QUANTUM)
	owner.playsound_local(owner, 'sound/magic/repulse.ogg', 100, FALSE)
	linked_target = null
	linked = FALSE

/datum/brain_trauma/special/psychotic_brawling
	name = "Насильственный психоз"
	desc = "Пациент сражается непредсказуемыми способами, начиная от оказания помощи своей цели и заканчивая нанесением ей ударов с жестокой силой."
	scan_desc = "<b>насильственного психоза</b>"
	gain_text = span_warning("Не могу сконцентрироваться на собственном настроении...")
	lose_text = span_notice("Чувствую себя более уравновешенным.")
	var/datum/martial_art/psychotic_brawling/psychotic_brawling

/datum/brain_trauma/special/psychotic_brawling/on_gain()
	..()
	psychotic_brawling = new(null)
	if(!psychotic_brawling.teach(owner, TRUE))
		to_chat(owner, span_notice("Но кулаки чешутся."))
		qdel(src)

/datum/brain_trauma/special/psychotic_brawling/on_lose()
	..()
	psychotic_brawling.remove(owner)
	QDEL_NULL(psychotic_brawling)

/datum/brain_trauma/special/psychotic_brawling/bath_salts
	name = "Химический насильственный психоз"

/datum/brain_trauma/special/tenacity
	name = "Стойкость"
	desc = "Пациент психологически не подвержен боли и травмам и может оставаться на ногах гораздо дольше, чем обычный человек."
	scan_desc = "<b>травматической невропатии</b>"
	gain_text = span_warning("Внезапно перестаю чувствовать боль.")
	lose_text = span_warning("Снова могу чувствовать боль.")

/datum/brain_trauma/special/tenacity/on_gain()
	owner.add_traits(list(TRAIT_NOSOFTCRIT, TRAIT_NOHARDCRIT), TRAUMA_TRAIT)
	..()

/datum/brain_trauma/special/tenacity/on_lose()
	owner.remove_traits(list(TRAIT_NOSOFTCRIT, TRAIT_NOHARDCRIT), TRAUMA_TRAIT)
	..()

/datum/brain_trauma/special/death_whispers
	name = "Экстрасенсорное восприятие"
	desc = "Мозг пациента застрял в функциональном предсмертном состоянии, вызывая случайные моменты осознанных галлюцинаций, которые часто интерпретируются как голоса мертвых."
	scan_desc = "<b>экстрасенсорного восприятия</b>"
	gain_text = span_warning("You feel dead inside.")
	lose_text = span_notice("You feel alive again.")
	var/active = FALSE

/datum/brain_trauma/special/death_whispers/on_life()
	..()
	if(!active && prob(2))
		whispering()

/datum/brain_trauma/special/death_whispers/on_lose()
	if(active)
		cease_whispering()
	..()

/datum/brain_trauma/special/death_whispers/proc/whispering()
	ADD_TRAIT(owner, TRAIT_SIXTHSENSE, TRAUMA_TRAIT)
	active = TRUE
	addtimer(CALLBACK(src, PROC_REF(cease_whispering)), rand(50, 300))

/datum/brain_trauma/special/death_whispers/proc/cease_whispering()
	REMOVE_TRAIT(owner, TRAIT_SIXTHSENSE, TRAUMA_TRAIT)
	active = FALSE

/datum/brain_trauma/special/existential_crisis
	name = "Экзистенциальный кризис"
	desc = "Связь пациента с реальностью ослабевает, вызывая случайные приступы небытия."
	scan_desc = "<b>экзистенциального кризиса</b>"
	gain_text = span_notice("Ощущаю себя менее реальным.")
	lose_text = span_warning("Ощущаю себя более реальным.")
	var/obj/effect/abstract/sync_holder/veil/veil
	/// A cooldown to prevent constantly erratic dolphining through the fabric of reality
	COOLDOWN_DECLARE(crisis_cooldown)

/datum/brain_trauma/special/existential_crisis/on_life(seconds_per_tick, times_fired)
	..()
	if(!veil && COOLDOWN_FINISHED(src, crisis_cooldown) && SPT_PROB(1.5, seconds_per_tick))
		if(isturf(owner.loc))
			fade_out()

/datum/brain_trauma/special/existential_crisis/on_lose()
	if(veil)
		fade_in()
	..()

/datum/brain_trauma/special/existential_crisis/proc/fade_out()
	if(veil)
		return
	var/duration = rand(5 SECONDS, 45 SECONDS)
	veil = new(owner.drop_location())
	to_chat(owner, span_warning("[pick(list(
			"Внезапно на мгновение все мысли улетучиваются, перестаю думать. Следовательно, меня не существует.",
			"Быть или не быть...",
			"Зачем существовать?",
			"Зачем быть настоящим?",
			"Хватка за существование ослабевает.",
			"А я вообще существую?",
			"Исчезаю..."))]"))
	owner.forceMove(veil)
	COOLDOWN_START(src, crisis_cooldown, 1 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(fade_in)), duration)

/datum/brain_trauma/special/existential_crisis/proc/fade_in()
	QDEL_NULL(veil)
	to_chat(owner, span_notice("Ты возвращаешься в реальность."))
	COOLDOWN_START(src, crisis_cooldown, 1 MINUTES)

//base sync holder is in desynchronizer.dm
/obj/effect/abstract/sync_holder/veil
	name = "небытие"
	desc = "Существование - это просто состояние ума."

/datum/brain_trauma/special/beepsky
	name = "Criminal"
	desc = "Преступление и наказание. Судья, прокурор и палач - ваш собственный разум."
	scan_desc = "<b>аутопокаятельной шизофрении</b>"
	gain_text = span_warning("Правосудие придет за мной.")
	lose_text = span_notice("Получаю прощение за свои преступления.")
	/// A ref to our fake beepsky image that we chase the owner with
	var/obj/effect/client_image_holder/securitron/beepsky

/datum/brain_trauma/special/beepsky/Destroy()
	QDEL_NULL(beepsky)
	return ..()

/datum/brain_trauma/special/beepsky/on_gain()
	create_securitron()
	return ..()

/datum/brain_trauma/special/beepsky/proc/create_securitron()
	QDEL_NULL(beepsky)
	var/turf/where = locate(owner.x + pick(-12, 12), owner.y + pick(-12, 12), owner.z)
	beepsky = new(where, owner)

/datum/brain_trauma/special/beepsky/on_lose()
	QDEL_NULL(beepsky)
	return ..()

/datum/brain_trauma/special/beepsky/on_life()
	if(QDELETED(beepsky) || !beepsky.loc || beepsky.z != owner.z)
		if(prob(30))
			create_securitron()
		else
			return

	if(get_dist(owner, beepsky) >= 10 && prob(20))
		create_securitron()

	if(owner.stat != CONSCIOUS)
		if(prob(20))
			owner.playsound_local(beepsky, 'sound/voice/beepsky/iamthelaw.ogg', 50)
		return

	if(get_dist(owner, beepsky) <= 1)
		owner.playsound_local(owner, 'sound/weapons/egloves.ogg', 50)
		owner.visible_message(span_warning("[owner] тело дергается, как будто его шокировали.") , span_userdanger("Чувствую тяжелую руку ЗАКОНА."))
		owner.adjustStaminaLoss(rand(40, 70))
		QDEL_NULL(beepsky)

	if(prob(20) && get_dist(owner, beepsky) <= 8)
		owner.playsound_local(beepsky, 'sound/voice/beepsky/criminal.ogg', 40)

/obj/effect/client_image_holder/securitron
	name = "Секьюритрон"
	desc = "Преступление и наказание. Судья, прокурор и палач - ваш собственный разум."
	image_icon = 'icons/mob/silicon/aibots.dmi'
	image_state = "secbot-c"

/obj/effect/client_image_holder/securitron/Initialize(mapload)
	. = ..()
	name = pick("Officer Beepsky", "Officer Johnson", "Officer Pingsky")
	START_PROCESSING(SSfastprocess, src)

/obj/effect/client_image_holder/securitron/Destroy()
	STOP_PROCESSING(SSfastprocess,src)
	return ..()

/obj/effect/client_image_holder/securitron/process()
	if(prob(40))
		return

	var/mob/victim = pick(who_sees_us)
	forceMove(get_step_towards(src, victim))
	if(prob(5))
		var/beepskys_cry = "Level 10 infraction alert!"
		to_chat(victim, "[span_name("[name]")] exclaims, \"[span_robot("[beepskys_cry]")]")
		if(victim.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat))
			victim.create_chat_message(src, raw_message = beepskys_cry, spans = list("robotic"))
