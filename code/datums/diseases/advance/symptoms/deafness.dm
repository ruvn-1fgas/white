/**Deafness
 * Slightly decreases stealth
 * Lowers Resistance
 * Slightly decreases stage speed
 * Decreases transmissibility
 * Intense level
 * Bonus: Causes intermittent loss of hearing.
*/
/datum/symptom/deafness
	name = "Глухота"
	desc = "Вирус вызывает воспаление барабанных перепонок, вызывая периодическую глухоту."
	illness = "Aural Perforation"
	stealth = -1
	resistance = -2
	stage_speed = -1
	transmittable = -3
	level = 4
	severity = 4
	base_message_chance = 100
	symptom_delay_min = 25
	symptom_delay_max = 80
	required_organ = ORGAN_SLOT_EARS
	threshold_descs = list(
		"Сопротивление 9" = "Вызывает постоянную глухоту, а не периодическую.",
		"Скрытность 4" = "Симптом остается скрытым до тех пор, пока не станет активным.",
	)
	var/causes_permanent_deafness = FALSE

/datum/symptom/deafness/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalStealth() >= 4)
		suppress_warning = TRUE
	if(A.totalResistance() >= 9) //permanent deafness
		causes_permanent_deafness = TRUE

/datum/symptom/deafness/End(datum/disease/advance/advanced_disease)
	REMOVE_TRAIT(advanced_disease.affected_mob, TRAIT_DEAF, DISEASE_TRAIT)
	return ..()

/datum/symptom/deafness/Activate(datum/disease/advance/advanced_disease)
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/infected_mob = advanced_disease.affected_mob
	var/obj/item/organ/internal/ears/ears = infected_mob.get_organ_slot(ORGAN_SLOT_EARS)

	switch(advanced_disease.stage)
		if(3, 4)
			if(prob(base_message_chance) && !suppress_warning)
				to_chat(infected_mob, span_warning("[pick("Слышу звон в ушах.", "В ушах стреляет.")]"))
		if(5)
			if(causes_permanent_deafness)
				if(ears.damage < ears.maxHealth)
					to_chat(infected_mob, span_userdanger("Уши болезненно стреляют и начинают кровоточить!"))
					// Just absolutely murder me man
					ears.apply_organ_damage(ears.maxHealth)
					infected_mob.emote("scream")
					ADD_TRAIT(infected_mob, TRAIT_DEAF, DISEASE_TRAIT)
			else
				to_chat(infected_mob, span_userdanger("В УШАХ ЗВЕНИТ!"))
				ears.deaf = min(20, ears.deaf + 15)

/datum/symptom/deafness/on_stage_change(datum/disease/advance/advanced_disease)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/infected_mob = advanced_disease.affected_mob
	if(advanced_disease.stage < 5 || !causes_permanent_deafness)
		REMOVE_TRAIT(infected_mob, TRAIT_DEAF, DISEASE_TRAIT)
	return TRUE
