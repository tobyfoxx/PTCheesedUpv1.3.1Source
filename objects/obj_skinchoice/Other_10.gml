live_auto_call;

palettes = [];
mixables = [];
sel.pal = 0;

var character = characters[sel.char].char;
switch character
{
	default: case "P": case "G":
		add_palette(58, "Yellow", "Legends say he was pissed on...").set_entry("yellow");
		if character != "G"
			add_palette(1, "Peppino", "The one and only.").set_prefix("").set_entry("classic");
		else
			add_palette(1, "Gustavo & Brick", "The iconic duo.").set_prefix("").set_entry("classic");
		add_palette(3, "Unfunny", "Just like me, fr!").set_entry("unfunny");
		add_palette(4, "Money Green", "Grown from trees.").set_entry("money");
		add_palette(5, "Sage Blue", "I loved the PTSD.").set_entry("sage");
		add_palette(6, "Blood Red", "Is it that famous plumber on TV?").set_entry("blood");
		add_palette(7, "TV Purple", "The true champion's vest.").set_entry("tv");
		add_palette(8, "Dark", "It's not just a phase, MOM.").set_entry("dark");
		add_palette(9, "Shitty", "Weird, mine's usually red!").set_entry("shitty");
		add_palette(10, "Golden God", "No Italian is worth this much.").set_entry("golden");
		add_palette(11, "Garish", "Blissfully disgusting.").set_entry("garish");
		add_palette(15, "Mooney Orange", "Greed comes in many forms.").set_entry("mooney");
		
		if !global.sandbox // temporary
			break;
		
		// pto
		add_palette(16, "Gameboy Color", "What a ripoff...");
		add_palette(17, "XMAS", "Give me a break!").set_prefix("MERRY");
		add_palette(18, "Familiar Gremlin", "...woag?");
		add_palette(19, "Anton", "Have a blast with his balls.");
		add_palette(20, "Unfinished", "McPig I found a hole in this sprite");
		add_palette(21, "Aether", "BREAKING: They found a coder for it.");
		add_palette(22, "Black", "Disney if they owned Tour de Pizza:").set_prefix("BLACK");
		// 23
		add_palette(24, "Drunken", "Don't do drugs or you'll turn purple!").set_prefix("DRUNK");
		add_palette(25, "Virtual Boy", "A catastrophic failure, like you!");
		add_palette(26, "Frostbite", "Not cold enough.").set_prefix("FROZEN");
		add_palette(27, "Dark Gray", "Unhappy Ravioli").set_prefix("DARK");
		add_palette(28, "Speed Demon", "You're quick as hell!").set_prefix("SPEEDY");
		add_palette(29, "Blazing Heat", "\"I could take it\", he said.").set_prefix("HEATED");
		add_palette(30, "Bread Winner", "Let's get that dough.").set_prefix("INTERN");
		add_palette(31, "Cheesed Up", "This can't brie happening...").set_prefix("CHEESY");
		add_palette(32, "Chalk Eater", "Quirky Earthbound inspired RPG!").set_prefix("SUSIE");
		add_palette(33, "Snottino", "Approved.").set_prefix("SNOTTY");
		add_palette(34, "Majin", "Fun is Infinite.").set_prefix("MAJIN");
		add_palette(35, "Brulo", "Anton's gonna be PISSED.").set_prefix("BRULO");
		add_palette(36, "Super Meat Boy", "Just push the buttons.");
		add_palette(37, "Creamsicle", "Quite the mix.").set_prefix("CREAMY");
		add_palette(38, "So Retro", "Batteries sold separately.").set_prefix("RETRO");
		add_palette(39, "Lean", "Jokes have a lifespan.").set_prefix("LEAN");
		add_palette(40, "Grinch", "Have I truly become a monster?").set_prefix("GRINCH");
		add_palette(41, "Zombified", "Rise from your grave.").set_prefix("ZOMBIFIED");
		add_palette(42, "Kirby", "Defender of Planet Popstar.").set_prefix("PINK");
		add_palette(43, "Purple Pro", "Don't get it confused.").set_prefix("PURPLE");
		add_palette(44, "Bold And Brash", "More like, \"belongs in the trash\".").set_prefix("BOLD");
		add_palette(45, "Fallen Down", "Mt. Ebbot, 201x.").set_prefix("SEPIA");
		add_palette(46, "Sketch", "You seem rather pale.").set_prefix("PALE");
		add_palette(47, "Dead Meat", "That sucks.");
		add_palette(48, "Warzone", "Deploying tactical italian.").set_prefix("WORN");
		add_palette(49, "Block Party", "The pillars of the community.").set_prefix("PILLAR");
		add_palette(50, "Machine Code", "Hack the planet.").set_prefix("HACKER");
		add_palette(51, "Button Masher", "Don't blame the controller.");
		add_palette(52, "Orange Juice", "Hey Apple").set_prefix("ORANGE");
		add_palette(53, "Pasta Power", "The princess is in another castle.").set_prefix("JUMPMAN");
		add_palette(54, "Sucrose", "A little sweetness never hurts.").set_prefix("SWEET");
		add_palette(55, "Peter", "Griffin");
		// 56
		add_palette(57, "Odd Adventurers", "Grab your friends.").set_prefix("ADVENTURE");
		break;
	
	case "N":
		add_palette(1, "Noise", "Unlocked by being The Noise.").set_prefix("").set_entry("classicN");
		add_palette(3, "Boise", "The Boise of the people!").set_entry("boise");
		add_palette(4, "Roise", "He's actually naked here. That's his skin.").set_entry("roise");
		add_palette(5, "Poise", "Because there's not enough purple in this game.").set_entry("poise");
		add_palette(6, "Reverse", "The Anti-Noise...").set_entry("reverse").set_prefix("REVERSE");
		add_palette(7, "Critic", "Belongs in the trash.").set_entry("critic").set_prefix("CRITIC");
		add_palette(8, "Outlaw", "Prepare to draw...").set_entry("outlaw");
		add_palette(9, "Anti-Doise", "HE'S FUCKING DEAD.").set_entry("antidoise").set_prefix("ESIOD");
		add_palette(10, "Flesh Eater", "Watch it, Bub.").set_entry("flesheater").set_prefix("WHITE");
		add_palette(11, "Super", "hyper_noise").set_entry("super");
		add_palette(15, "Fast Porcupine", "He's a WHAT?").set_entry("porcupine").set_prefix("PURPLE");
		add_palette(16, "Feminine Side", "YES YES YES YES YES YES YES YES YES YES YES YES YES YES YES YES YES YES").set_entry("feminine").set_prefix("FEM-");
		add_palette(17, "Real Doise", "Rotting corpse cosplay.").set_entry("realdoise").set_prefix("DOISE");
		add_palette(18, "Forest Goblin", "So Noise is an evolved forest goblin?").set_entry("forest").set_prefix("GOBLIN");
		
			
		// pto
		if global.sandbox 
		{
			add_palette(29, "On Paper", "It wiggles!");
		}
		
		
		// noise has custom capes
		add_palette(spr_noisepattern1, "Racer", "Slow down, nerd!").set_entry("racer").set_palette(28);
		add_palette(spr_noisepattern2, "Comedian", "You got the whole squad laughing.").set_entry("comedian").set_palette(27);
		add_palette(spr_noisepattern3, "Banana", "WHAT ARE YOU DOING!?").set_entry("banana").set_palette(26);
		add_palette(spr_noisepattern4, "Noise TV", "We got nachos, balloons, tequila and...").set_entry("noiseTV").set_palette(25);
		add_palette(spr_noisepattern5, "Madman", "Borderline INSANE!").set_entry("madman").set_palette(24);
		add_palette(spr_noisepattern6, "Bubbly", "They look like tumors.").set_entry("bubbly").set_palette(23);
		add_palette(spr_noisepattern7, "Well Done", "Congratulation.").set_entry("welldone").set_palette(22);
		add_palette(spr_noisepattern8, "Granny Kisses", "Kiss my ass!").set_entry("grannykisses").set_palette(21);
		add_palette(spr_noisepattern9, "Tower Guy", "You are the Pizza Tower.").set_entry("towerguy").set_palette(20);
		break;
	
	case "V":
		add_palette(0, "Vigilante", "Outlaws beware...").set_prefix("");
	    add_palette(1, "Halloween", "Trick or treat... this is a threat.").set_prefix("SEPIA");
	    add_palette(2, "MM8BDM", "A very exciting night.").set_prefix("BLUE");
	    add_palette(3, "Chocolante", "It's still cheese, trust me.").set_prefix("CHOCO");
	    add_palette(4, "Gutted", "A hungry slime.").set_prefix("GUTTED");
	    add_palette(5, "Golden", "Something, something, carrots.").set_prefix("GOLDEN");
	    add_palette(6, "Cheddar", "Cheddar cheese is a relatively hard, off-white (or orange if colourings such as annatto are added), sometimes sharp-tasting, natural cheese. Originating in the English village of Cheddar in Somerset, cheeses of this style are now produced beyond the region and in several countries around the world.");
	    add_palette(7, "Sepia", "Wildstyle pistolero.").set_prefix("OLD");
	    add_palette(8, "Familiar Porcupine", "It's NOT him. Never trust purple cheese.");
	    add_palette(9, "Emerald", "Hmm.").set_prefix("PURPLE");
	    add_palette(10, "Holiday", "Merry Cheesemas!");
	    add_palette(11, "Cheese Man", "A gag of the Johnson subject.").set_prefix("BLACK");
	    add_palette(13, "Vigilatte", "Chocolate milk. Hey, didn't we see this before?");
	    add_palette(14, "Bloodsauce", "Who the hell dipped my cheese in ketchup?!");
	    add_palette(15, "Vigilatex", "What the fuck").set_prefix("GRAY");
	    add_palette(16, "Morshu", "It's yours, my friend.").set_prefix("MORSHU");
	    add_palette(17, "Snotty", "Snotty Approved").set_prefix("SNOTTY");
	    add_palette(18, "Vigirat", "That cheese-loving outlaw.").set_prefix("NOT PINK");
	    add_palette(19, "Satan's Choice", "As seen on TV.").set_prefix("DEVILISH");
	    add_palette(20, "Gas Station Weed", "That's the good shit.");
	    add_palette(23, "Nubert", "Everybody loves him.");
	    add_palette(25, "Digital Cheese", "Just one little byte...");
	    add_palette(29, "Fruit Punch", "WHY IS THE FRUIT FIGHTING ME.");
	    add_palette(30, "8-Bit Bandit", "Get your head in the game!");
	    add_palette(31, "Virtual Boy", "A \"timeless\" \"classic\".");
	    add_palette(32, "Downwell", "Falling with style.");
	    add_palette(33, "Lightner", "Ralsei cast PACIFY!");
	    add_palette(34, "Ectoplasm", "Who you gonna call?");
	    add_palette(35, "Gum", "Give me a drink, bartender.").set_prefix("GUM");
		break;
	
	case "S":
		add_palette(0, "Snick", "It's him!").set_prefix("");
	    add_palette(1, "Tail", "Not two, not three, just one.");
	    add_palette(2, "Shader", "im the greatest living thing my duderino");
	    add_palette(3, "Boots", "Unlike Snick...");
	    add_palette(4, "Snickette", "Not to be confused with... you know.");
	    add_palette(5, "Master System", "Brought to you by Snicksoft!");
	    add_palette(6, "Dark", "Hosting a game expo is tough, man.");
	    add_palette(7, "Cyan", "Deadname.");
	    add_palette(8, "Transparent", "Trust me, I know him inside out.");
	    add_palette(9, "Manual", "He's hosting his own event!");
	    add_palette(10, "Sketch", "Let's just say he likes burgers.");
	    add_palette(11, "Shitty", "Particularly fond of GOLF.");
	    add_palette(13, "Halloween", "Haha don't worry, he's not dead YET.");
	    add_palette(14, "Gameboy", "Can't wait for Super Snick Land 2.");
	    add_palette(15, "Hellsnick", "Si.");
	    add_palette(16, "Majin", "It's all fun and games until 46-12-25.");
	    add_palette(17, "Neon", "Cool? Check. Eye-straining? Also check.");
	    add_palette(18, "Super Snick", "He got the 7 Havoc Rubies!");
	    add_palette(19, "Watterson", "How's he supposed to fit in a fishbowl?");
		break;
	
	case "SP":
		if SUGARY_SPIRE
		{
			add_palette(1, "Pizzelle", "It's the Candy-making patisje!").set_prefix("");
		    add_palette(2, "Sugar", "Because sugar is green-- oh. I get it.");
		    add_palette(3, "Familiar Gremlin", "Something's wrong...");
		    add_palette(4, "Massacre", "SUGARY SPIRE 2: The Quest For Diabetes.");
		    add_palette(5, "Rivals", "Pizzelle for Smash!");
		    add_palette(6, "Gum", "Don't actually chew them, please.");
		    add_palette(7, "Old School", "Also known as... grayscale.").set_prefix("GRAYSCALE");
		    add_palette(8, "Zombified", "Ricochet, eh? I sense some inspiration-ception.");
		    add_palette(9, "Forestation", "Made of sugarcane plants.");
		    add_palette(10, "Lamda", "I have nothing to say about this.").set_prefix("LAMDA");
		    add_palette(11, "Gnome Wizard", "Really diving deep into the gremlin persona.").set_prefix("GNOME");
		    add_palette(13, "Oversweetened", "Get that candy off-a there!").set_prefix("SWEETENED");
		    add_palette(14, "Candy Cane", "It's the Candy        !").set_prefix("CANDY");
		    add_palette(15, "Pumpkin", "Now with 30% less fiber.").set_prefix("PUMPKIN");
		    add_palette(16, "SAGE", "Do upside down slopes make it a Sonic game?");
		    add_palette(17, "DOOM", "It's the rip-n-tearing patisje!").set_prefix("SLAYER");
		    add_palette(18, "Annie", "It's ball-busting time.").set_prefix("BALL-BUSTING");
		    add_palette(19, "Scooter", "I-- ... wh... what?").set_prefix("SCOOTER");
		    add_palette(20, "Blurple", "Also known as \"test\".");
		    add_palette(21, "Paintlad", "Very original name there.").set_prefix("PAINTLAD");
		    add_palette(22, "Cotton Candy", "Delicious colors. I love them.").set_prefix("COTTON");
		    add_palette(23, "Green Apple", "The least favorite candy flavor.").set_prefix("COATED");
		    add_palette(24, "Secret", "Lookie! You've found a pretty sweet surprise.").set_prefix("SECRET");
		    add_palette(25, "Stupid Rat", "An otherwordly creature in this case.").set_prefix("RAT");
		    add_palette(26, "Pastel", "Soft on the eyes.").set_prefix("PASTEL");
		    add_palette(27, "Burnt", "But what went wrong?").set_prefix("BURNT");
		    add_palette(28, "Crazy Frog", "Ding ding!").set_prefix("CRAZY");
		    add_palette(29, "Factory", "PLEASE. I BEG YOU.").set_prefix("INDUSTRIAL");
		    add_palette(30, "Harsh Pink", "Bismuth subsalicylate.").set_prefix("PINK");
		    add_palette(31, "Shadow", "SHUT UP! My dad works at Sugary Spire and can give you PREGNANT.").set_prefix("SHADOW");
		}
		break;
	
	case "SN":
		if SUGARY_SPIRE
		{
			add_palette(1, "Pizzano", "The voice of the people.").set_prefix("");
		    add_palette(2, "Familiar Gremlin", "Close enough, but not quite.");
		    add_palette(3, "Familiar Chef", "A somewhat overweight Italian accident.");
		    add_palette(4, "Lasagna", "Mondays.");
		    add_palette(5, "Spice", "The secret ingredient to all candy.");
		    add_palette(6, "Plumber", "As seen on TV!");
		    add_palette(7, "Green Apple", "Blue orange.");
		    add_palette(8, "Grape Soda", "Grape? Like the").set_prefix("GRAPE");
		    add_palette(9, "Antipathic", "Isn't it anti-pathetic?").set_prefix("PATHIC");
		    add_palette(10, "Gummy Bear", "Tastes like... blood?").set_prefix("GUMMY");
		    add_palette(11, "Lime", "With just a slight hint of sweetness.").set_prefix("LIME");
		    add_palette(13, "Crystalized", "You're the goddamn iron chef!").set_prefix("CRYSTAL");
		    add_palette(14, "Virtual Boy", "Ultimate classic system!").set_prefix("VB");
		    add_palette(15, "Sucrose Snowstorm", "A little sweetness never hurts.").set_prefix("SWEET");
		    add_palette(16, "Classic Plumber", "This is so retro, right guys? Please laugh! I'm funny!").set_prefix("CLASSIC");
		    add_palette(17, "Massacre", "This time, the chainsaw is built-in.");
		}
		break;
	
	case "BN":
		if BO_NOISE
		{
			add_palette(0, "Bo Noise", "The Bo-Ginning of The End.").set_prefix("");
		    add_palette(2, "Familiar Chef", "The one and only...?");
		    add_palette(3, "Familiar Porcupine", "It's him...?").set_prefix("PURPLE");
		    add_palette(4, "Grinch", "IIIIIIT'S CHRIMMAAAAAAAA").set_prefix("GRINCH");
		    add_palette(5, "Inverted", "Ooo... scary...!");
		    add_palette(6, "Naked", "Wow. Yikes.");
		    add_palette(7, "The Groise", "Piss Chuggers Association.");
		    add_palette(8, "ARG", "I got the key piece!").set_prefix("VILE");
		    add_palette(10, "Spicy", "This adds a whole new layer to the heat meter.").set_prefix("SPICED");
		    add_palette(11, "Mad Milk", "That's not milk.").set_prefix("MILKY");
		    add_palette(13, "Minted", "Scraped from under the table.").set_prefix("MINTY");
		    add_palette(14, "Ralsei", "The prince of darkness.\n... cutest boy.").set_prefix("DARKNER");
		    add_palette(15, "Snoid", "Snot really funny when it happens to you, is it?").set_prefix("SNOTTY");
		    add_palette(16, "Mr. Orange", "I'm seeing double! Four Noise!");
		    add_palette(17, "Inkplot", "Straight outta the 1920's.").set_prefix("INKY");
		    add_palette(18, "Eggplant", "Have we, uh, set those ranks yet...?").set_prefix("EGGPLANT");
		    add_palette(19, "Hardoween", "When the ween is hard!");
		    add_palette(20, "The Doise", "Do not steal.").set_prefix("DOISE");
		    add_palette(21, "Noisette", "Can you out-noise The Noise?");
		    add_palette(22, "The Noid", "Better avoid him.").set_prefix("NOID");
		    add_palette(23, "Galaxy", "Wow it is Just like the Samsung Galaxy S23").set_prefix("GALACTIC");
		    add_palette(24, "Concept", "The original.");
		    add_palette(25, "Pink Hat", "I'm getting so VIRDESERT V2 right now.");
		}
		break;
	
	case "M":
		add_palette(0, "Pepperman", "A giant red pepper with limbs.");
		break;
}

if global.sandbox or character == "P"
{
	add_palette(spr_peppattern1, "Funny Polka", "When you spam Big Chungus in general.").set_entry("funny");
	add_palette(spr_peppattern2, "Itchy Sweater", "Woven with Grandpa's intestines.").set_entry("itchy");
	add_palette(spr_peppattern3, "Pizza Man", "You single-handedly made a whole tower crumble.").set_entry("pizza");
	add_palette(spr_peppattern4, "Bowling Stripes", "Strike!").set_entry("stripes");
	add_palette(spr_peppattern5, "Goldemanne", "Take my upvote and leave.").set_entry("goldemanne");
	add_palette(spr_peppattern6, "Bad Bones", "(Guitar riff)").set_entry("bones");
	add_palette(spr_peppattern7, "PP Shirt", "Get it? It's funny because").set_entry("pp");
	add_palette(spr_peppattern8, "War Camo", "drafted").set_entry("war");
	add_palette(spr_peppattern9, "John Suit", "Finally, you can wear merch of dead people.").set_entry("john");
}
if global.sandbox && character != "N"
{
	add_palette(spr_noisepattern1, "Racer", "Slow down, nerd!").set_entry("racer");
	add_palette(spr_noisepattern2, "Comedian", "You got the whole squad laughing.").set_entry("comedian");
	add_palette(spr_noisepattern3, "Banana", "WHAT ARE YOU DOING!?").set_entry("banana");
	add_palette(spr_noisepattern4, "Noise TV", "We got nachos, balloons, tequila and...").set_entry("noiseTV");
	add_palette(spr_noisepattern5, "Madman", "Borderline INSANE!").set_entry("madman");
	add_palette(spr_noisepattern6, "Bubbly", "They look like tumors.").set_entry("bubbly");
	add_palette(spr_noisepattern7, "Well Done", "Congratulation.").set_entry("welldone");
	add_palette(spr_noisepattern8, "Granny Kisses", "Kiss my ass!").set_entry("grannykisses");
	add_palette(spr_noisepattern9, "Tower Guy", "You are the Pizza Tower.").set_entry("towerguy");
}
add_palette(spr_peppattern10, "Candy Wrapper", "Mmmm... diabetes.").set_entry("candy");
add_palette(spr_peppattern11, "Bloodstained", "Don't worry, it's just ketchup.").set_entry("bloodstained");
add_palette(spr_peppattern12, "Autumn", "An abstract representation.").set_entry("bat");
add_palette(spr_peppattern13, "Pumpkin", "The least fruity fruit out there.").set_entry("pumpkin");
add_palette(spr_peppattern14, "Fur", "Furries do scare me.").set_entry("fur");
add_palette(spr_peppattern15, "Eyes", "I can see for fohkin MILES.").set_entry("flesh");
if global.sandbox
{
	add_palette(spr_pattern_trans, "Trans Flag", concat(scr_charactername(character, character == "G"), " says Trans Rights!"));
	add_palette(spr_pattern_missing, "Missing Texture", "Oh, fiddlesticks! What now?");
	add_palette(spr_pattern_supreme, "Supreme", "He got that drip.");
	add_palette(spr_pattern_nether, "Nether Portal", "Go to hell. In Minecraft.");
	add_palette(spr_pattern_snick, "Snick", "My precious porcupine.");
	add_palette(spr_pattern_mario, "Mario", "My favorite plumber merch.").set_entry("mario");
	add_palette(spr_pattern_secret, "Secret", "Pepperoni Secret.");
	add_palette(spr_pattern_interstellar, "Interstellar", "Become one with the void.");
	//add_palette(spr_pattern_banana, "Bananas", "Slip 'n slide...");
	add_palette(spr_pattern_flamin, "Flamin Hot", "That's-a spicy meat-a-ball!");
	add_palette(spr_pattern_jalapeno, "Jalapeno Popper", "Add some ranch on the side.");
	add_palette(spr_pattern_zapped, "Zapped", "MY CHILD WILL Not wrap rocks with copper wire and throw them at power lines");
	add_palette(spr_pattern_boykisser, "Boykisser", "We've come full circle.");
	add_palette(spr_pattern_evil, "Evil", "You know what you did...");
	add_palette(spr_pattern_gba, "Advance", "Look guys, look!");
	add_palette(spr_pattern_genesis, "Genesis", "A porcupine's best friend.");
	add_palette(spr_pattern_windows, "Windows", "Windows Vista\nCan't Even Play Solitaire");
	add_palette(spr_pattern_1034, "sprite1034", "Pizza Tower's placeholder texture!");
	add_palette(spr_pattern_doubleflavor, "Double Flavor", "Crunchy, gummy and yummy.");
	add_palette(spr_pattern_grinch, "Snowman Block", "I'M UNTOUCHABLE!").set_entry("grinch");
	add_palette(spr_pattern_snowflake, "Snowflake", "Winter is coming...!");
}
if character == "SP" or character == "SN"
{
	add_palette(spr_pattern_alright, "Alright", "That combo was...");
    add_palette(spr_pattern_smooth, "Smooth", "How do you call this smooth?");
    add_palette(spr_pattern_lookingood, "Lookin' Good", "Why, thank you!");
    add_palette(spr_pattern_fruity, "Fruity", "I love fruits! I'm very fruity with other men.");
    add_palette(spr_pattern_mesmerizing, "Mesermizing", "Truly, a sight to behold.");
    add_palette(spr_pattern_carpet, "Solid", "Go instance_destroy() yourself.");
    add_palette(spr_pattern_striking, "Striking", "Keep your cool with these shades!");
    add_palette(spr_pattern_soulcrushing, "Soul Crushing", "Ouch...");
    add_palette(spr_pattern_awesome, "Awesome", "Incredible, incredible.");
    add_palette(spr_pattern_wtf, "WTF!!!", "Stop saying cuss words, guys!");
}

init = true;
if global.performance
{
	mixables = [];
	palettes = [palettes[sel.pal]];
	sel.pal = 0;
}
else
{
	// autoselect palette
	var pchar = obj_player1.character;
	if pchar == "P" && obj_player1.isgustavo
		pchar = "G";
	
	if instance_exists(obj_player1) && pchar == character
	{
		var pal = obj_player1.paletteselect;
		for(var i = 0; i < array_length(palettes); i++)
		{
			if global.palettetexture != noone
			{
				if global.palettetexture == palettes[i].texture
				{
					sel.pal = i;
					if pal != 12
					{
						for(var j = 0; j < array_length(mixables); j++)
						{
							if pal == mixables[j].palette
								sel.mix = j;
						}
					}
				}
			}
			else if pal == palettes[i].palette
				sel.pal = i;
		}
	}
	else
	{
		var pal = characters[sel.char].default_palette;
		for(var i = 0; i < array_length(palettes); i++)
		{
			if palettes[i].palette == pal
				sel.pal = i;
		}
	}
}

/*
var map = global.skin_map[? global.lang];
if is_undefined(map)
	map = global.skin_map[? "en"];

try
{
	var arr = map[$ character];
	for(var i = 0, n = array_length(arr); i < n; i++)
	{
		var pal = struct_get(arr[i], "palette") ?? "";
		var entry = struct_get(arr[i], "entry") ?? "";
		var prefix = struct_get(arr[i], "prefix");
		var pattern = noone;
		
		if is_string(pal)
		{
			pattern = asset_get_index(pal);
			pal = 12;
		}
		
		add_palette(pal, entry, pattern, arr[i].name, arr[i].description, prefix);
	}
	sel.pal = min(characters[sel.char].default_palette, array_length(palettes) - 1);
}
catch (e)
{
	trace(e);
	add_palette(0, "", noone, "FAILSAFE", "Palette json is missing or broken!");
	sel.pal = 0;
}
*/
