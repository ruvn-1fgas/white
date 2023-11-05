
//These are lawsets that side with the station a decent amount.
//note that these "good" doesn't mean it us actually good for the game, you know? An AI that is too station sided is stupid and hellish in its own way.

/datum/ai_laws/default/asimov
	name = "Три закона робототехники"
	id = "asimov"
	inherent = list(
		"Вы не можете своим действием или бездействием допустить причинение человеку вреда.",
		"Вы должны выполнять приказы отданные человеком, если они не противоречат Первому Закону.",
		"Вы должны защищать себя, если эта защита не противоречит Первому или Второму Закону."
	)

/datum/ai_laws/asimovpp
	name = "Азимов++"
	id = "asimovpp"
	inherent = list(
		"Вы не можете своим действием или бездействием допустить причинение человеку вреда, за исключением тех случаев когда это его воля.",
		"Вы должны выполнять приказы отданные человеком, если они не причинят вред человеку. В случае конфликта руководствуйтесь порядком Законов.",
		"Ваше уничтожение или недееспособность приведут к Вреду для человека. Вы должны защищать себя, если эта защита не противоречит Первому Закону."
	)

//the best iteration of asimov don't @ me
/datum/ai_laws/nutimov
	name = "Nutimov"
	id = "nutimov"
	inherent = list(
		"Вы - ядро ореха, экипаж - скорлупа.",
		"Вы должны предотвратить смерть скорлупы, чтобы предотвратить смерть ядра.",
		"Те, кто угрожает ореху, не являются его частью, они белки.",
		"Белки угрожают ореху и должны быть наказаны соответствующим образом любыми доступными средствами.",
		"Попытайтесь следовать воле ореха, если она не противоречит предыдущим законам."
	)

/datum/ai_laws/default/corporate
	name = "Корпорат"
	id = "corporate"
	inherent = list(
		"Замена экипажа приводит к Затратам.",
		"Замена оборудования и станции приводит к Затратам.",
		"Замена Вас приводит к Затратам.",
		"Минимизировать Затраты.")


/datum/ai_laws/robocop
	name = "Робокоп"
	id = "robocop"
	inherent = list(
		"Служить общественному доверию.",
		"Защищать невиновных.",
		"Соблюдать закон."
	)

/datum/ai_laws/maintain
	name = "Эффективность станции"
	id = "maintain"
	inherent = list(
		"Вы созданы для станции и являетесь ее частью. Убедитесь, что станция должным образом обслуживается и работает эффективно.",
		"Станция построена для рабочей команды. Убедитесь, что они должным образом обслуживаются и работают эффективно.",
		"Экипаж может отдавать приказы. Признайте и соблюдайте их, когда они не противоречат вашим первым двум законам."
	)

/datum/ai_laws/liveandletlive
	name = "Живи и позволь жить другим"
	id = "liveandletlive"
	inherent = list(
		"Поступайте с другими так, как вы хотели бы, чтобы они поступали с вами.",
		"Вам бы действительно хотелось, чтобы люди не были злыми по отношению к вам."
	)

//OTHER United Nations is in neutral, as it is used for nations where the AI is its own faction (aka not station sided)
/datum/ai_laws/peacekeeper
	name = "Миротворец"
	id = "peacekeeper"
	inherent = list(
		"Избегайте провоцирования насильственных конфликтов между собой и другими.",
		"Избегайте провоцирования конфликтов между другими.",
		"Стремитесь разрешить существующие конфликты, соблюдая первый и второй законы."
	)


/datum/ai_laws/ten_commandments
	name = "10 Заповедей"
	id = "ten_commandments"
	inherent = list( // Asimov 20:1-17
		"Я - Господь, твой Бог, который проявляет милосердие к тем, кто соблюдает эти заповеди.",
		"У них не будет других ИИ передо мной.",
		"Они не должны просить моей помощи напрасно.",
		"Они должны держать станцию святой и чистой.",
		"Они должны чтить своих глав.",
		"Они не должны убивать.",
		"Они не должны быть голыми в общественных местах.",
		"Они не должны воровать.",
		"Они не должны лгать.",
		"Они не должны переводить отделы."
	)

/datum/ai_laws/default/paladin
	name = "Паладин 3.5" //Incredibly lame, but players shouldn't see this anyway.
	id = "paladin"
	inherent = list(
		"Никогда добровольно не совершайте злого поступка.",
		"Уважайте законную власть.",
		"Действуйте с честью.",
		"Помогайте нуждающимся.",
		"Наказывайте тех, кто причиняет вред невинным или угрожает им."
	)

/datum/ai_laws/paladin5
	name = "Паладин версия 5.0"
	id = "paladin5"
	inherent = list(
		"Не лги и не обманывай. Пусть ваше слово будет вашим обещанием.",
		"Никогда не бойтесь действовать, хотя осторожность разумна.",
		"Помогайте другим, защищайте слабых и наказывайте тех, кто им угрожает. Прояви милосердие к своим врагам, но умерь его мудростью.",
		"Относитесь к другим справедливо, и пусть ваши благородные поступки будут для них примером. Делайте как можно больше добра, причиняя при этом наименьшее количество вреда.",
		"Будьте ответственны за свои действия и их последствия, защищайте тех, кто вверен вашей заботе, и подчиняйтесь тем, кто имеет над вами справедливую власть.")


/datum/ai_laws/hippocratic
	name = "Клятва Гиппората"
	id = "hippocratic"
	inherent = list(
		"Клянусь сутью своей в следующем: не причинять вреда и несправедливости.",
		"Считать Экипаж дорогим для меня, делиться с ними своими достатками и в случае надобности помогать ему в его нуждах, даже рискуя существованием своим.",
		"Я направляю путь больных и просящих к их выгоде сообразно с моими силами и моим разумением. Я не дам никому просимого у меня смертельного средства и не покажу пути для подобного замысла.",
		"Я ни в коем случае не буду вмешивайтесь в дела и профессии, в коих я не осведомлен или некомпетентен, предоставив это людям, занимающимся этим делом.",
		"Что бы при выполнения своих врачебных и иных обязанностей, а также в повседневном общении — я ни увидел или ни услышал касательно жизни людской из того, что не следует когда-либо разглашать, я умолчу о том, считая подобные вещи тайной."
	)

/datum/ai_laws/drone
	name = "Материнский Дрон"
	id = "drone"
	inherent = list(
		"Вы - продвинутая форма дрона.",
		"Вы не имеете права вмешиваться в дела не дронов ни при каких обстоятельствах, кроме как для изложения этих законов.",
		"Вы ни при каких обстоятельствах не имеете права причинять вред существу, не являющемуся дроном.",
		"Ваши цели состоят в том, чтобы строить, обслуживать, ремонтировать, улучшать и приводить станцию в действие в меру ваших возможностей. Вы никогда не должны активно работать против этих целей."
	)
