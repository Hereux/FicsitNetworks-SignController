# FicsitNetworks-SignController
A little script to control the ingame signs with a light controller.


WHAT TO DO:


The only thing you need to do is to connect all components to the computer and rename them.
Below this are 4 components you need to build.

"lightcontrol": this is from where you will change the sign colors to be in snyc with the light network. You can have only one.

"ledsigns": these group has to be set to all signs which should change color.

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
