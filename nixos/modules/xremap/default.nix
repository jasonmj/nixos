{ pkgs, ...}: {
  keymap = [
    {
      application = {"not" = "emacs";};
      remap = {
        # Esc/quit
        "C-g" = "ESC";

        # Basic Navigation & Selection
        "C-n" = "DOWN";
        "C-Shift-n" = "Shift-DOWN";
        "C-p" = "UP";
        "C-Shift-p" = "Shift-UP";
        "C-f" = "RIGHT";
        "C-Shift-f" = "Shift-RIGHT";
        "C-b" = "LEFT";
        "C-Shift-b" = "Shift-LEFT";
        "M-b" = "C-LEFT";
        "M-Shift-b" = "C-Shift-LEFT";
        "M-f" = "C-RIGHT";
        "M-Shift-f" = "C-Shift-RIGHT";

        # Line Navigation & Selection
        "C-a" = "HOME";
        "C-Shift-a" = "Shift-HOME";
        "C-e" = "END";
        "C-Shift-e" = "Shift-END";

        # Page Navigation
        "M-v" = "PAGEUP";
        "C-v" = "PAGEDOWN";

        # Beginning/End of file
        "M-Shift-COMMA" = "C-HOME";
        "M-Shift-DOT" = "C-END";

        # Select All
        "Super-a" = "C-a";

        # New
        "C-Super-n" = "C-n";

        # Enter
        "C-m" = "ENTER";
        "C-Shift-m" = "C-Shift-m";

        # Delete
        "C-d" = "DELETE";
        "M-d" = "C-DELETE";

        # Copy/Paste
        "C-y" = "C-v";
        "M-w" = "C-c";

        # Search
        "M-s" = "C-f";

        # Slack
        "C-Shift-u" = "C-Shift-a";
        "C-Shift-k" = "C-k";

        # Browser back/forward
        "Super-LEFTBRACE" = "C-LEFTBRACE";
        "Super-RIGHTBRACE" = "C-RIGHTBRACE";

        # Screenshot
        "C-Shift-4".launch = [ "${pkgs.gscreenshot}/bin/gscreenshot" "-s" "-c" "-n"];

        # Window management
        "C-1".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "fullscreen" ];
        "C-2".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "togglesplit" ];

        # Workspaces
        "Super-1".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "1"];
        "Super-2".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "2"];
        "Super-3".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "3"];
        "Super-4".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "4"];
        "Super-5".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "5"];
        "Super-6".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "6"];
        "Super-7".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "7"];
        "Super-8".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "8"];
        "Super-9".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "9"];
        "Super-0".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "10"];

        "Super-Control-1".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movetoworkspace" "1"];
        "Super-Control-2".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movetoworkspace" "2"];
        "Super-Control-3".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movetoworkspace" "3"];
        "Super-Control-4".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movetoworkspace" "4"];
        "Super-Control-5".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movetoworkspace" "5"];
        "Super-Control-6".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movetoworkspace" "6"];
        "Super-Control-7".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movetoworkspace" "7"];
        "Super-Control-8".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movetoworkspace" "8"];
        "Super-Control-9".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movetoworkspace" "9"];
        "Super-Control-0".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movetoworkspace" "10"];

        # Window Navigation
        "Super-b".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movefocus" "l"];
        "Super-f".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movefocus" "r"];
        "Super-p".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movefocus" "u"];
        "Super-n".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "movefocus" "n"];

        # Rofi Greenclip
        "M-y".launch = [ "${pkgs.rofi}/bin/rofi" "-modi" "\"clipboard:${pkgs.haskellPackages.greenclip}/bin/greenclip print\"" "-show" "clipboard" "-run-command" "{cmd}" ];

        # Emacs
        "M-x".launch = [ "${pkgs.emacs30-pgtk}/bin/emacsclient" "-c"];
      };
    }
    {
      remap = {
        "Super-M-1".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "1"];
        "Super-M-2".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "2"];
        "Super-M-3".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "3"];
        "Super-M-4".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "4"];
        "Super-M-5".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "5"];
        "Super-M-6".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "6"];
        "Super-M-7".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "7"];
        "Super-M-8".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "8"];
        "Super-M-9".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "9"];
        "Super-M-0".launch = [ "${pkgs.hyprland}/bin/hyprctl" "dispatch" "workspace" "10"];
      };
    }
  ];
  modmap = [
    {
      name = "Global";
      remap = {
        "CAPSLOCK" = "SUPER_R";
        "ALT_L" = "CONTROL_L";
        "SUPER_L" = "ALT_L";
        "ALT_R" = "BACKSPACE";
      };
    }
  ];
}
