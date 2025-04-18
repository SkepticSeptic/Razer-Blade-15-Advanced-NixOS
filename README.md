# Razer-Blade-15-Advanced-NixOS
Personal configs for the Razer Blade 15 Advanced. Running NixOS, i3wm, &amp; some (battery) performance tweaks as well as an Arasaka themed rice. Also has a bunch of resources, nixos and not, for this laptop.

![image](https://github.com/user-attachments/assets/f47a5ee2-76b4-4112-bf92-228418b375fe)



# Hardware Support Limitations & issues:
Currently the hardware I haven't been able to get working is:

SD card reader.

# Other issues:

Can't wake from suspend, cryptic errors, need to investigate, so supend is disabled.

When building, logrotate can sometimes provide an exit code of 1 when there is nothing to do. Fixed in configuration.nix at # Fix logrotate bug
  
# Features:
iGPU only with offloading to the dGPU when needed

Limiting the size of the touchpad to avoid accidental palm taps while typing

Properly setting up double & triple clicks/taps to right & middle click

Battery saving through tlp

Battery usage around 8-12w depending on workload, meaning 6-8 hours of battery life on a full charge


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

