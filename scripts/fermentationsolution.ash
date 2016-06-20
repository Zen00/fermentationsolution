/***********************************************\
				
			Fermentation Solution
			Written by Zen00
			v. 1.0.2

\***********************************************/


script "Fermentation Solution";


/***********************************************\

					OPTIONS

\***********************************************/


//Remove the comment lines if you want to let me know you're using this script, so I know people are interested and keep writing
//notify Zen00;

//Use Clara's Bell if you have it on hand and want to
boolean bellNC = false;

/***********************************************\

					SCRIPT
					
			Do not edit past this point
		unless you know what you're doing
		(all warranties void if edited)

\***********************************************/


string mayor = "place.php?whichplace=knoll_friendly&action=dk_mayor";
string fungus = "";
int previousChains = item_amount($item[spooky bicycle chain]);

void doStuff()
{
	visit_url("questlog.php");
	wait(5);
	
	if(get_property("questM03Bugbear").to_string() == "unstarted")
	{
		print("Starting quest!", "blue");
		visit_url("place.php?whichplace=knoll_friendly&action=dk_mayor");
	}
	if(get_property("questM03Bugbear").to_string() == "started")
	{
		print("Getting a pitchfork!", "blue");
		if(item_amount($item[annoying pitchfork]) == 0)
			buy(1, $item[annoying pitchfork]);

		visit_url(mayor);
	}
	if(get_property("questM03Bugbear").to_string() == "step1")
	{
		print("Getting a fungus!", "blue");
		if(fungus == "")
		{
			matcher fungusFinder = create_matcher("(flaming|frozen|stinky)(?=\\b)", visit_url(mayor));
			find(fungusFinder);
			fungus = group(fungusFinder);
		}

		string fungusName = fungus + " mushroom";
		if(item_amount(to_item(fungusName)) == 0)
			buy(1, to_item(fungusName));
		visit_url(mayor);
	}
	if(get_property("questM03Bugbear").to_string() == "step2")
	{
		print("Starting the adventure sequence in The Spooky Gravy Barrow!", "blue");
		string familiarItemName = "pregnant " + fungus + " mushroom";
		string familiarName = fungus + " gravy fairy";
		if(item_amount(to_item(familiarItemName)) > 0)
			use(1, to_item(familiarItemName));
		if(have_familiar($familiar[spooky gravy fairy]))
			use_familiar($familiar[spooky gravy fairy]);
		else if(have_familiar($familiar[frozen gravy fairy]))
			use_familiar($familiar[frozen gravy fairy]);
		else if(have_familiar($familiar[stinky gravy fairy]))
			use_familiar($familiar[stinky gravy fairy]);
		else if(have_familiar($familiar[flaming gravy fairy]))
			use_familiar($familiar[flaming gravy fairy]);
		else
			abort("No elemental familiar detected, sorry!");
		maximize("0.2 item drop, -combat", 0, 0, false);
		if(item_amount($item[small leather glove]) == 0)
			buy(1, $item[small leather glove]);
		put_closet(previousChains, $item[spooky bicycle chain]);
		set_property("choiceAdventure5", 2);
		if(bellNC && (item_amount($item[Clara's bell]) > 0))
			use(1, $item[Clara's bell]);

		while(item_amount($item[spooky bicycle chain]) == 0)
		{
			if((item_amount($item[spooky fairy gravy]) > 1) && (item_amount($item[spooky glove]) == 0))
			{
				cli_execute("make spooky glove");
			}
			if((item_amount($item[inexplicably glowing rock]) > 0) && (item_amount($item[spooky glove]) > 0) && (get_property("choiceAdventure5") != 1))
			{
				equip($slot[acc3], $item[spooky glove]);
				set_property("choiceAdventure5", 1);
			}

			adventure(1, $location[The Spooky Gravy Burrow]);
		}
	}
	if(get_property("questM03Bugbear").to_string() == "step3")
	{
		print("The queen is dead, long live you!", "blue");
		take_closet(previousChains, $item[spooky bicycle chain]);
		visit_url(mayor);
		print("Congratulations on finishing your quest! Drink respectfully.", "green");
	}
}

void main()
{
	if(!knoll_available())
		abort("You're not under the proper moon sign to use this script, try again next ascension!");
	if(get_property("questM03Bugbear").to_string() == "finished")
		abort("You've already completed the quest and have no further need for this script this ascension!");
	if(my_level() < 2)
		abort("You don't have The Spooky Forest access yet, so this quest is not available!");
	if(my_adventures() == 0)
		abort("You're out of adventures! :(");
	if(my_inebriety() > inebriety_limit())
		abort("You're drunk, lets not waste adventures now shall we?");

	if(get_property("lastCouncilVisit").to_int() < 2)
		council();
	while(get_property("questM03Bugbear").to_string() != "finished")
		doStuff();
}
