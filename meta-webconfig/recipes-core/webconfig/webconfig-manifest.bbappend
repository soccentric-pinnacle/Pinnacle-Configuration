# webconfig-manifest.bbappend — Pinnacle board manifest selection (spec §3).
#
# This repo is Pinnacle-only; board-specific data lives solely in the board
# manifest. `webconfig-manifest.bb` already defaults WEBCONFIG_BOARD_FILE to
# the real "pinnacle.json", so no override is required to get a correct image.
# This bbappend exists for the one case that still needs a MACHINE-specific
# override: a future Pinnacle board revision that ships a distinct manifest
# file under a different MACHINE name.
#
# Real NXP i.MX 8M/9 MACHINE name (Pinnacle-OS default board, per its own docs):
WEBCONFIG_BOARD_FILE:imx93-11x11-lpddr4x-frdm = "pinnacle.json"

# Mirror the platform id into the daemon environment so the embedded
# compiled-in fallback manifest agrees with the installed one if the BSP file
# is ever missing (spec §3). This lives in a webconfigd.bbappend per machine:
#   WEBCONFIG_PLATFORM:imx93-11x11-lpddr4x-frdm = "pinnacle"
