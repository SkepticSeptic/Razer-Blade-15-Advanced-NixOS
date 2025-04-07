# Razer-Blade-15-Advanced-NixOS
Personal configs for the Razer Blade 15 Advanced. Running NixOS, i3wm, &amp; some performance tweaks


# Hardware Support Limitations & issues:
Currently the hardware I haven't been able to get working is:
  SD card reader.
Other issues:
  Can't wake from suspend, cryptic errors, need to investigate, so supend is disabled.
  When building, logrotate can sometimes provide an exit code of 1 when there is nothing to do. Fixed in # Fix logrotate bug
  
# Features:
iGPU only with offloading to the dGPU when needed
Limiting the size of the touchpad to avoid accidental palm taps while typing
Properly setting up double & triple clicks/taps to right & middle click
Battery saving through tlp
Battery usage around 8-12w depending on workload, meaning 6-8 hours of battery life on a full charge
