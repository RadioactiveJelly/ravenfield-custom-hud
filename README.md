#
Ravenfield - Custom HUD
------------------------------------------
Scripts for creating custom HUDs for Ravenfield! A template (the Black Ops:Cold War HUD) is provided as an example. Below is short documentation for each script. Please note that these scripts are in active development and are thus likely to be updated as time goes on.

When making UI elements, follow the naming conventions of the targets listed below. Format is "targetName(Type)". If you don't use the same name listed below, you'll have to edit the script. Bold targets are **required**. Everything else is optional.

#### CustomHUD_Main
This script handles hiding the default HUD. This script also handles hiding the weapon HUD if the player has no weapon and auto hiding all the UI elements when dead or when
disabling the HUD via the "End" key.
###### Targets:
  - **canvas(Canvas)**
  - WeaponHUD(Animator)  

The game object holding this script also needs a data container with two strings using these IDs:
  - hudName
  - hudVersion

#### CustomHUD_HealthBar
This script changes an image set to "Filled" mode's fill amount. If applicable, it also plays a red flashing animation when at low HP.
###### Targets:
  - **healthBar(Image)**
  - animator(Animator)
  - redFlash(Image)  

#### CustomHUD_PlayerName
This script changes a specified text element to the player's in-game name. Can be overriden via mutator settings.
###### Targets:
  - **playerName(Text)**

#### CustomHUD_Squad
This script changes a specified text element to match what would otherwise be displayed in the defaulth HUD's squad text.
###### Targets:
  - **squadText(Text)**

#### CustomHUD_Vehicle
This script handles displaying the current player's vehicle name and vehicle HP. Currently, only a numerical display is available for the vehicle HP. Automatically hides and unhides itself depending on whether the player is in a vehicle or not.
###### Targets:
  - **vehicleName(Text)**
  - **vehicleHealth(Text)**

#### CustomHUD_Weapon
This script handles updating the HUD elements for the current weapon's ammo, spare ammo, name, fire mode and heat levels (if applicable). It's set to hide the spare ammo element depending on the "maxSpareAmmo" variable of weapons. If it's -1 the script will just hide the element, if -2 it will use the infinity symbol.
###### Targets:
  - **ammoText(Text)**
  - **spareAmmoText(Text)**
  - **heatText(Text)**
  - **weaponName(Text)**
  - **fireMode(Text)**


If you're having trouble with setting up, you can take a look at how the BO:CW HUD is set up.

You're allowed to edit these scripts as you see fit! All I ask is for some credit if you decide to use these.

**You are not allowed to redistrbute the Black Ops: Cold War Style HUD. It's only included here as an example.**



