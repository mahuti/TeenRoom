//
// TeenRoom based on Ol Room 
// Theme by Mahuti
// vs. 1.1
//
local order = 0 
class UserConfig {
	
	</ label="Selected System", 
		help="Selecting auto will allow you to use this one theme folder for multiple systems (you must name your lists to match the system folders listed in this theme). Selecting a specific system name is useful if you are using multiple copies of this theme to handle different systems. ", 
		order=order++, 
		options="auto, Atari 2600, Intellivision, Nintendo 64, Nintendo NES, Nintendo SNES, ScummVM, Sega Genesis, Sony Playstation, Generic TV, Generic PC" /> 
		selected_system="auto"; 
	
	</ label="Game Titles", 
		help="Select game title style", 
		order=order++, 
		options="show wheel images, text titles, no titles" /> 
		game_titles="show wheel images";
		
	</ label="Show Playtime", 
		help="Show game playtime", 
		order=order++, 
		options="yes, no" /> 
		show_playtime="no"; 
	
	</ label="Cartridge Folder", 
		help="Choose folder that stores Cartridge art. Not all consoles use cartridge art.", 
		order=order++, 
		options="cartridge, marquee, none" /> 
		cartridge_folder="marquee"; 
		
	</ label="Boxart Folder", 
		help="Choose folder that stores Boxart Images", 
		order=order++, 
		options="boxart, flyer, none" /> 
		boxart_folder = "flyer"; 
	
	</ label="Boxart Shadows", 
		help="Show shadows underneath boxart", 
		order=order++, 
		options="yes, no" /> 
		boxart_shadows="yes"; 

    </ label="Scaling", 
		help="Controls how the layout should be scaled. Stretch will fill the entire space. Scale will scale up/down to fit the space with potential cropping of non-critical elements (eg. backgrounds).", 
		options="stretch,scale,no scale", 
		order=order++ /> 
		scale="stretch";
				
}
 
  
local config = fe.get_config();
 
// modules
fe.load_module("fade");
fe.load_module("file"); 
fe.load_module("preserve-art"); 
fe.load_module("pos") // positioning & scaling module

// stretched positioning
local posData =  {
    base_width = 1440.0,
    base_height = 1080.0,
    layout_width = fe.layout.width,
    layout_height = fe.layout.height,
    scale= config['scale'],
    debug = true,
}
local pos = Pos(posData)

function random(minNum, maxNum) {
    return floor(((rand() % 1000 ) / 1000.0) * (maxNum - (minNum - 1)) + minNum);
}
function randomf(minNum, maxNum) {
    return (((rand() % 1000 ) / 1000.0) * (maxNum - minNum) + minNum).tofloat();
}
function random_file(path) {
	
	local dir = DirectoryListing( path );
	local dir_array = []; 
	foreach ( key, value in dir.results )
	{
	    try
	    {
	        local name = value.slice( path.len() + 1, value.len() );

			// bad mac!
			if (name.find("._") == null)
			{
				dir_array.append(value); 
			}

	    }catch ( e )
	    {
	        // print(  value );
	    }
	}
	return dir_array[random(0, dir_array.len()-1)]; 
}

local console = fe.list.name; 

if (config["selected_system"] != "auto")
{
	console = config["selected_system"]; 
} 

fe.add_transition_callback(this, "on_transition"); 
function on_transition(ttype, var, ttime) {
	
	local last_console = console; 
	
	if (config["selected_system"] != "auto")
	{
		console = config["selected_system"]; 
	}
	else
	{
		console = fe.list.name;
	}
	
	switch( ttype)
	{
		case Transition.ToNewList:
		//console = fe.list.name;
		if (last_console != console)
		{
			fe.signal("reload"); 
		}
		break;
		default: 
	}
   return false;
}

local testo = fe.add_text(console, pos.x(10), pos.y(10), pos.width(1000), pos.height(400));  
testo.charsize=36; 
testo.set_rgb(247,35,0); 
 
function set_titles( unused )
{
	// Title
	local title = fe.add_text("[Title]", pos.x(18), pos.y(18), pos.width(317), pos.height(32));
	title.charsize = 24;
	title.set_rgb(247, 35, 0);
	title.font =  console + "/" + "font"; 
} 
 
//Background
local bg = fe.add_image(console + "/" + "bg.jpg", 0,0, pos.width(1920), pos.height(1080) );


local snap_x = 361;
local snap_y = 153; 
local snap_w = 610; 
local snap_h = 460; 

local cart_width=263; 
local cart_height=50;
local cart_x = 69;
local cart_y = 739; 
local cart_pinch_x = 0;
local cart_pinch_y = 0;  
local cart_preserve_aspect_ratio = true; 
local boxart_x = 1109; 
local boxart_y = 527; 
local boxart_width = 281; 
local boxart_height = 396; 

local wheel_x = 984; 
local wheel_y = 941; 
local wheel_width = 336; 
local wheel_height = 127; 


switch (console)
{
	case "Atari 2600":
		cart_pinch_x = -3;
		cart_width=173;
		cart_height=30; 
		cart_x = 78;
		cart_y = 557; 
		cart_preserve_aspect_ratio =  false; 
		
		boxart_x = 1017; 
		boxart_y = 548; 
		boxart_width = 281; 
		boxart_height = 396; 
		
		break;
	
	case "Sega Genesis":
		cart_width=239; 
		cart_height=135;
		cart_x = 194;
		cart_y = 562; 
		wheel_x = 1068; 
		cart_preserve_aspect_ratio = false; 
		break; 
		
	case "Intellivision":
		break; 
		
	case "Nintendo NES":
		cart_width=263; 
		cart_height=50;
		cart_x = 69;
		cart_y = 739;
		cart_preserve_aspect_ratio = false; 
		
		boxart_x = 1008; 
		boxart_y = 527; 
		boxart_width = 281; 
		boxart_height = 396; 
		
		break;
		
	case "Nintendo SNES":
		cart_width=307; 
		cart_height=290;
		cart_x = 68;
		cart_y = 498; 
		cart_preserve_aspect_ratio = false; 
		boxart_x = 1004; 
		boxart_y = 603; 
		boxart_width = 393; 
		boxart_height = 287; 
		
		break;
		
	case "Nintendo 64":
		cart_width=278; 
		cart_height=182;
		cart_x = 45;
		cart_y = 502; 
		cart_preserve_aspect_ratio = false; 
		boxart_x = 1011; 
		boxart_y = 602; 
		boxart_width = 391; 
		boxart_height = 309; 
		
		break;
	case "Sony Playstation":
		cart_width=278; 
		cart_height=182;
		cart_x = 45;
		cart_y = 502; 

		boxart_x = 1011; 
		boxart_y = 602; 
		boxart_width = 391; 
		boxart_height = 309; 
	
		break;
	case "ScummVM":
		snap_x = 460;
		snap_y = 105; 
		snap_w = 610; 
		snap_h = 460; 
		
		boxart_x = 30; 
		boxart_y = 532; 
		
		wheel_x = 1020; 
		wheel_y = 951; 
		
		break; 
	default:
		
} 


///////////////////////////////////////////////////////
//			BOXART
///////////////////////////////////////////////////////

if (config["boxart_folder"] !="none")
{
	if (config["boxart_shadows"] == "yes")
	{
		local box_shadow = fe.add_image(console + "/" + "box_shadow.png", 0,0, pos.width(1440), pos.height(1080) );
		box_shadow.preserve_aspect_ratio = true;
	}

	local boxart = fe.add_artwork(config["boxart_folder"], pos.x(boxart_x), pos.y(boxart_y), pos.width(boxart_width), pos.height(boxart_height));
	boxart.preserve_aspect_ratio = false;
	boxart.trigger = Transition.EndNavigation;
}


///////////////////////////////////////////////////////
//		WHEEL LOGO / TITLES
///////////////////////////////////////////////////////

if ( config["game_titles"] == "show wheel images" )
{
	// wheel
	local wheel = fe.add_artwork("wheel", pos.x(wheel_x), pos.y(wheel_y), pos.width(wheel_width), pos.height(wheel_height));
	wheel.preserve_aspect_ratio = true;
	wheel.trigger = Transition.EndNavigation;
	
}
if (config["game_titles"] =="text titles"){
	// Title
	local title = fe.add_text("[Title]", pos.x(1067), pos.y(978), pos.width(244), pos.height(181));
	title.align = Align.Right;
	title.charsize = 24;
	title.set_rgb(247, 35, 0);
	title.font =  console + "/" + "font"; 
} 
 
 
 
///////////////////////////////////////////////////////
//			PLAY TIME
///////////////////////////////////////////////////////
 
if (config["show_playtime"] == "yes")
{
	// Playtime
	local playtime = fe.add_text("[Title] Playcount:[PlayedCount] Time:[PlayedTime]", pos.x(16), pos.y(993), pos.width(700),pos.height(39));
	playtime.align = Align.Left;
	playtime.charsize = 20;
	playtime.set_rgb(255, 255, 255);
}

///////////////////////////////////////////////////////
//		SNAP & SNAP OVERLAYS
///////////////////////////////////////////////////////

local snap = fe.add_artwork("snap", pos.x(snap_x), pos.y(snap_y), pos.width(snap_w), pos.height(snap_h));
snap.trigger = Transition.EndNavigation;

if (console != "scummvm")
{
	// Scanlines
	local scanlines = fe.add_image("scanlines.png", pos.x(snap_x), pos.y(snap_y), pos.width(snap_w), pos.height(snap_h));
	scanlines.preserve_aspect_ratio = false;
	scanlines.alpha = 130;

	// TV Borders
	local borders = fe.add_image("borders.png", pos.x(snap_x), pos.y(snap_y), pos.width(snap_w), pos.height(snap_h));
	borders.preserve_aspect_ratio = false;
}

///////////////////////////////////////////////////////
//		   CARTRIDGES
///////////////////////////////////////////////////////

if (config["cartridge_folder"] !="none")
{
	local cartridge = fe.add_artwork(config["cartridge_folder"], pos.x(cart_x), pos.y(cart_y), pos.width(cart_width), pos.height(cart_height));
	cartridge.preserve_aspect_ratio = true;

	if (cart_preserve_aspect_ratio == false)
	{
		cartridge.preserve_aspect_ratio = false;
		
	}
	if (cart_pinch_x != 0)
	{
		cartridge.pinch_x = cart_pinch_x; 
	}
	if (cart_pinch_y != 0)
	{
		cartridge.pinch_y = cart_pinch_y; 
	}
	cartridge.trigger = Transition.EndNavigation;
}



///////////////////////////////////////////////////////
//		IMAGE OVERLAYS / CART MASKS
///////////////////////////////////////////////////////

local overlay = fe.add_image(console + "/"+"foreground.png", 0, 0, pos.width(1440), pos.height(1080));
overlay.preserve_aspect_ratio = true;
 

 
///////////////////////////////////////////////////////
//			UNUSED
///////////////////////////////////////////////////////
 
/*
fe.load_module("file"); 
function file_exists( fullpathfilename )
{
	try{ file(fullpathfilename, "r"); return true;} catch(e){return false;}
}

local fullpathfilename = console + "/" + "box_shadow.png"; 

if (file_exists(fullpathfilename))
{
	local flyer_shadow = fe.add_image(console + "/" + "box_shadow.png", 0,0, pos.width(1440), pos.height(1080) );
	flyer_shadow.preserve_aspect_ratio = true;
}
*/
