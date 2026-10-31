# Android A2DP Sink Magisk Module

Experimental Magisk module that lets a supported Android phone act as a Bluetooth A2DP audio receiver.

> **Tested device:** Nothing Phone (1), stock Nothing OS based on Android 15, rooted with Magisk.
>
> This is not a universal module. Vendor Bluetooth stacks and audio policies differ.

## What it does

At early boot it enables:

```text
bluetooth.profile.a2dp.sink.enabled=true
bluetooth.profile.avrcp.controller.enabled=true
```

The Magisk **Action** button then:

1. Fabricates and enables an overlay setting `a2dp_sink_automatically_request_audio_focus=true`.
2. Restarts Bluetooth so it reloads the resource.
3. Prints the A2DP Sink and SDP status.

It intentionally does not restart Bluetooth automatically during boot, avoiding a boot-time race observed on the tested device.

## Installation

1. Download the ZIP from Releases or GitHub Actions artifacts.
2. Open **Magisk > Modules > Install from storage**.
3. Select the ZIP and reboot.
4. Open **Magisk > Modules** and press this module's **Action** button.
5. Wait for `Done`, then pair/connect from the source phone and enable **Media audio**.

If the phones were paired before enabling the sink profile, forget the pairing on both phones and pair again.

## Expected output

```text
[x] com.android.shell:A2dpSinkFocus
A2DP Sink State: Enabled
SDP A2DP sink handle: 65541
```

The handle only needs to be nonzero; its exact value can differ.

## Compatibility test

Before installing, a rooted user can test:

```sh
su
resetprop bluetooth.profile.a2dp.sink.enabled true
resetprop bluetooth.profile.avrcp.controller.enabled true
svc bluetooth disable
sleep 3
svc bluetooth enable
sleep 8
dumpsys bluetooth_manager | grep -iE 'A2DP Sink State|SDP A2DP sink'
```

Promising output is `A2DP Sink State: Enabled` with a nonzero SDP handle.

The Action script additionally requires this resource in `com.android.bluetooth`:

```text
bool/a2dp_sink_automatically_request_audio_focus
```

## Recovery

If Bluetooth becomes unstable, disable the module from Magisk and reboot. From a root shell:

```sh
touch /data/adb/modules/a2dpsink_android15/disable
cmd overlay disable --user 0 com.android.shell:A2dpSinkFocus
reboot
```

## Known limitations

- Tested only on the Nothing Phone (1) configuration above.
- Some ROMs remove A2DP Sink, use different properties/resources, or lack an audio route.
- Changing Bluetooth profiles can invalidate cached pairings.
- The Action button temporarily disconnects Bluetooth while restarting the service.
- OTAs may change Bluetooth APEX behavior.

## Build

Requires `zip`:

```sh
./build.sh
```

Output:

```text
release/A2DP-Sink-Android15-Magisk.zip
```

## License

MIT
