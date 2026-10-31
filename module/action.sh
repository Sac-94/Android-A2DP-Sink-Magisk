#!/system/bin/sh

echo "Enabling A2DP Sink profiles..."
resetprop bluetooth.profile.a2dp.sink.enabled true
resetprop bluetooth.profile.avrcp.controller.enabled true

echo "Applying A2DP Sink audio-focus overlay..."
cmd overlay fabricate \
  --target com.android.bluetooth \
  --name A2dpSinkFocus \
  com.android.bluetooth:bool/a2dp_sink_automatically_request_audio_focus \
  0x12 0x1
cmd overlay enable --user 0 com.android.shell:A2dpSinkFocus

echo "Restarting Bluetooth..."
svc bluetooth disable
sleep 3
svc bluetooth enable
sleep 8

echo
echo "Overlay status:"
cmd overlay list --user 0 | grep -i A2dpSinkFocus

echo
echo "A2DP Sink status:"
dumpsys bluetooth_manager | grep -iE 'A2DP Sink State|SDP A2DP sink'

echo
echo "Done. Connect the source phone now."
