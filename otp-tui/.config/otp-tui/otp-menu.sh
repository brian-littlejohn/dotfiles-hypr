#!/bin/sh
# otp-menu.sh — the waybar module's click handler.
#
# Unlocks the otp-tui agent (prompting for the quick-unlock PIN via a
# fuzzel password prompt if needed), shows a fuzzel picker of accounts,
# and copies the selected account's current code to the clipboard.
#
# Requires: `otp-tui agent run` already running (see
# contrib/hyprland/otp-tui.conf), jq, fuzzel, wl-copy, notify-send.
#
# To use wofi instead of fuzzel, swap the two `fuzzel ...` invocations
# below for:
#   wofi --dmenu --password --prompt "Quick-unlock PIN: "
#   wofi --dmenu --prompt "Account: "
# (wofi has no with-nth/accept-nth equivalent, so pipe the id/label pairs
# through `cut -f2-` for display and `cut -f1` on the selection instead.)

set -eu

agent() {
	otp-tui agent "$@"
}

status=$(agent status)
unlocked=$(printf '%s' "$status" | jq -r '.unlocked')

if [ "$unlocked" != "true" ]; then
	pin=$(fuzzel --dmenu --password --prompt-only="Quick-unlock PIN: ") || exit 0
	if [ -z "$pin" ]; then
		exit 0
	fi
	if ! printf '%s\n' "$pin" | agent unlock >/dev/null; then
		notify-send "OTP-TUI" "Incorrect PIN"
		exit 1
	fi
	# Reflect the unlock in the bar immediately instead of waiting for
	# its next poll interval.
	pkill -RTMIN+8 waybar 2>/dev/null || true
fi

accounts=$(agent list)
if [ "$(printf '%s' "$accounts" | jq 'length')" -eq 0 ]; then
	notify-send "OTP-TUI" "No accounts in the vault"
	exit 0
fi

# id and a display label, tab-separated: fuzzel matches/shows the label
# (--with-nth=2) but prints the id back out on selection (--accept-nth=1),
# so nothing has to be cut back apart afterward. The folder is appended
# when set, so two accounts with the same name in different folders
# don't show up as identical, indistinguishable entries.
choice=$(printf '%s' "$accounts" |
	jq -r '.[] | [.id, (
		.name
		+ (if .folder != "" then " [\(.folder)]" else "" end)
	)] | @tsv' |
	fuzzel --dmenu --with-nth=2 --accept-nth=1 --prompt="Account: ") || exit 0

if [ -z "$choice" ]; then
	exit 0
fi

result=$(agent code "$choice")
code=$(printf '%s' "$result" | jq -r '.code')

printf '%s' "$code" | wl-copy
notify-send "OTP-TUI" "Code copied to clipboard"

# Best-effort: clear the clipboard after a while rather than leaving a
# live TOTP code sitting there indefinitely. Only clears it if nothing
# else has overwritten the clipboard in the meantime.
(
	sleep 20
	if [ "$(wl-paste 2>/dev/null)" = "$code" ]; then
		wl-copy --clear
	fi
) &
disown
