#!/system/bin/sh
# Best-effort cleanup; this Android build may not support deleting fabricated overlays.
cmd overlay disable --user 0 com.android.shell:A2dpSinkFocus >/dev/null 2>&1 || true
