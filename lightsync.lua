--[[

WHAT TO DO:


The only thing you need to do is to connect all components to the computer and rename them.
Below this are 4 components you need to build.

"lightcontrol": this is from where you will change the sign colors to be in snyc with the light network. You can have only one.

"ledsigns": these group CAN to be set to all signs which should change color. You do not need it, because this version uses 
				  all components that have no nickname.  you want to leave the nickname of the signs just empty.

"prefabsaver": this sign is special. It will provide the brightness and glossy setting. It needs to have the "ledsigns" AND "prefabsaver"
			      group. You can use multiple groups by splitting them with a space.

"lightpole": Unfortunately you NEED one lightpole, which needs to be connected to the computer and the light controller.
		      Reason: You get a colorSlot from the controller, but it has no function to get the decimal color. 
		      But the lightpole does. So I only need the lightpole to get the decimal color values.

After that you should be good to go. Don't forget to set the wished brightness and glossyness setting in the "prefabsaver" sign.


If you have problems or questions about the code, just dm me on discord or ping me on the Ficsit Networks help channel. (name: "hereux")
Feel free make changes, and if you do, it would be cool to know.



Powered by Hereux.
No rights reserved!

]]--
lightcontrol = component.proxy(component.findComponent("lightcontrol")[1])	-- The light controller
all_proxies = component.proxy(component.findComponent(""))					-- All signs that should change colors
prefabsaver = component.proxy(component.findComponent("prefabsaver")[1])	-- One sign for brightness and glossyness setting 
lightpole = component.proxy(component.findComponent("lightpole")[1])		-- A lightpole for getting the decimal color
all_signs = {}
sign_list = {"Build_StandaloneWidgetSign_SmallVeryWide_C", "Build_StandaloneWidgetSign_Large_C", "Build_StandaloneWidgetSign_Square_Small_C",
"Build_StandaloneWidgetSign_Square_Tiny_C", "Build_StandaloneWidgetSign_Square_C", "Build_StandaloneWidgetSign_Small_C", "Build_StandaloneWidgetSign_SmallWide_C",
"Build_StandaloneWidgetSign_Medium_C", "Build_StandaloneWidgetSign_Huge_C", "Build_StandaloneWidgetSign_Portrait_C"}

lightcontrol_controlled = false
UPDATE_TIME = 0.3								-- How many seconds the computer should wait between checking for updates.
												-- (lower = faster, higher = slower. When fast it will use more cpu.)
function tableContains(table, value)
  for i = 1,#table do
    if (table[i] == value) then
      return true
    end
  end
  return false
end

for _, proxy in pairs (all_proxies) do
	proxy_name = proxy:getType().name

	-- Wenn das Objekt kein Nickname hat oder "ledsigns"
	if proxy.nick == "" or proxy.nick == "ledsigns" then
		-- Wenn das Objekt ein Schild ist
		if tableContains(sign_list, proxy_name) then 
			table.insert(all_signs, proxy)
		end
	end
end

-- Speichern der alten Zustände

old_on_state = lightcontrol.isLightEnabled
OldLightPrefab = prefabsaver:getPrefabSignData()
OldColorSlot = lightcontrol.colorSlot

-- Funktion zur Konstruktion der Schildfarbe
function construct_sign_prefab(color, SignPrefab)
    local signcolor = structs.Color(r,g,b,a)
    signcolor.r = color[1]
    signcolor.g = color[2]
    signcolor.b = color[3]
    signcolor.a = color[4]
    SignPrefab.background = signcolor
    SignPrefab.foreground = signcolor
    SignPrefab.auxiliary = signcolor
    
	print("Calculated RGBA Values: ",color[1],color[2],color[3],color[4])
    return SignPrefab
end

-- Funktion zur Umwandlung von Prozent in RGB
function dez_to_rgba(color)
    local rgba_color = {color.r * 255 // 1, color.g * 255 // 1, color.b * 255 // 1, color.a}
    return rgba_color
end


-- Funktion um die Prefabs von allen Lichtern zu verändern
function change_all_lights(prefab)
	for _,sign in pairs(all_signs) do
	    sign:setPrefabSignData(prefab)
    end
end

-- 
function update_sign_config(color_slot, rgba_color, sign_prefab, list_with_signs)
	if not color_slot then
		color_slot = lightcontrol.colorSlot
	end
	
	if not sign_prefab then
		sign_prefab = OldLightPrefab
	end		
	
	if not rgba_color then
		dez_color = lightpole:getColorFromSlot(color_slot)
		rgba_color = dez_to_rgba(dez_color)
	end
		
	updated_prefab = construct_sign_prefab(rgba_color, sign_prefab)
	
	if not list_with_signs then
		change_all_lights(updated_prefab)
	else
		print("Feature not implemented yet!")
	end
end
				
-- Lädt den Prefab vom Einstellschild und lädt ihn auf alle anderen Schilder
update_sign_config(nil, nil, nil, nil)

-- Hauptprozess
while true do
    event.pull(UPDATE_TIME)
    
   	newOnState = lightcontrol.isLightEnabled
  	newColorSlot = lightcontrol.colorSlot
	
	
	-- Normale Farbkontrolle über Lichtpult
	if lightcontrol_controlled == true then
	
    	-- Zustandsänderung der Lichtsteuerung
    	if newOnState ~= old_on_state then
        	if newOnState == true then
    			update_sign_config(nil, nil, nil, nil)
		
        	else
        		print(oldColorSlot, newColorSlot)
				update_sign_config(nil, {0,0,0,1}, nil, nil)
	    	end
        	old_on_state = newOnState
        
        
    	-- Änderung des Farbslots
    	elseif newColorSlot ~= OldColorSlot then
			update_sign_config(NewColorSlot, nil, nil, nil)
   	 		OldColorSlot = newColorSlot
	    end
	 
	 else 
	 	local colors = {}
	 	for color = 1, 3, 1 do
	 		print("exe")
			color = math.random(1, 80) / 100
			table.insert(colors, color)
		end
		table.insert(colors, 1.0)
	 	update_sign_config(nil, colors, nil, nil)
	 end
end