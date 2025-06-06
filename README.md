# Razer-Blade-15-Advanced-NixOS
Personal configs for the Razer Blade 15 Advanced. Running NixOS, hyprland, waybar, &amp; some (battery) performance tweaks as well as an Arasaka themed rice. Heavily security oriented when I feel like it. Also has a bunch of resources, nixos and not, for this laptop.

![image](https://github.com/user-attachments/assets/14c0ce93-04f1-42ab-843c-82954d52070e)


# WARNING:
Be careful directly copying this config over to yours and at least do a cursory glance over the comments (ESPECIALLY SECURITY ONES!) or you may lock yourself out and/or have other issues

Some options are only guaranteed* to work on the Razer Blade 15 Advanced 2021 model RZ09-0409BEC3*

For the everyday user, it is suggested to comment out the badusb prevention sections as well as much of the firewall.nix section, as both are overkill and can cause issues that are difficult to diagnose and/or resolve.

*Nothing is guaranteed to work here lol
*My model came with a 1920x1080@360hz display, but has been retrofitted to a QHD / 2560x1440@240hz display. (Model number: LP156QHG SPV1 NE156QHM-NX1 )


# Hardware Support Limitations & issues:
Currently the hardware I haven't been able to get working is:

SD card reader

Video camera

Bluetooth (Intel Corporation Wi-Fi 6E(802.11ax) AX210/AX1675* 2x2 [Typhoon Peak] [8086:2725] (rev 1a))

# Other issues:

~~Medium: Can't wake from suspend, cryptic errors, need to investigate, so supend is disabled.~~
Medium-fixed: Has been fixed in current release, don't know why exactly but both suspend and hibernate works without issue. /shrug

Low-patched: When building, logrotate can sometimes provide an exit code of 1 when there is nothing to do. Fixed in configuration.nix at # Fix logrotate bug

Low: So far, I have not been able to get ollama working on the GPU with the offload script, this may not be possible in the current state of nixos/ollama/nvidia/optimus, so for now it only works on CPU which isn't quite blazing fast. In the future want to possibly set up a shortcut to reboot with nvidia drivers or something.

Low-hack: With the default 15.6" 1920x1080p 360hz display, I could not get hyprland to detect it as anything above 60hz. This seemed to fix itself when I upgraded to a different monitor (see warning "*" number 2)
  
# Features:
iGPU only with offloading to the dGPU when needed

Limiting the size of the touchpad to avoid accidental palm taps while typing

Properly setting up double & triple clicks/taps to right & middle click

Battery saving through tlp

Battery usage around 8-12w depending on workload, meaning 6-8 hours of battery life on a full charge

Full LVM disk encryption

Extended security tweaks for user, firewall, and physical (badusb) security

Localized LLMs on CPU (NOT GPU!) (TODO)

zen-browser working just fine

# FOSS: do what you want with this, and feel free to open an issue if something is unclear. This is a personal config, and many things probably will be because I'm shit with documentation. Have fun!




# Additional resources for this laptop:
Useful for more info specifically for the razer blade advanced (and non advanced) 15


*Official pages:*


Official NixOS wiki page: https://nixos.wiki/wiki/Hardware/Razer

Official Arch Linux wiki: https://wiki.archlinux.org/title/Razer_Blade

Official OpenRazer page (kernel level & written in python, personally not a fan: https://openrazer.github.io/


*Projects:*

Razer laptop control (RGB, fan, power & battery optimizer), alternative to openrazer in rust with nix flakes: https://wiki.archlinux.org/title/Razer_Blade

*Other nixconfigs:*

Razer blade non advanced nixconfig: https://github.com/xiXRedNomadXix/NixOS


*Support forums:*
Integrated graphics issues, used as a source to fix drivers in my config: https://discourse.nixos.org/t/razer-blade-15-nvidia-integrated-graphics-on-nixos-issues/23576

Razer Blade 15 non advanced randomly going back into hybrid after opening lid, not experienced on my advanced, but patched in my config regardless just in case (exept it can't wake from sleep in the first place lol): https://www.reddit.com/r/NixOS/comments/nuclde/how_to_properly_set_up_lidclose_behaviour_on_a/

Didn't use this but yet another nvidia+integrated graphics discussion: https://discourse.nixos.org/t/razer-blade-15-nvidia-integrated-graphics-on-nixos-issues/23576/5?u=heywoodlh

