# Flutter version

Flutter 3.29.0 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 35c388afb5 (5 недель назад) • 2025-02-10 12:48:41 -0800
Engine • revision f73bfc4522
Tools • Dart 3.7.0 • DevTools 2.42.2

## flutter doctor

Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.29.0, on macOS 14.3.1 23D60 darwin-arm64, locale ru-TJ)
[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 15.1)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2024.2)
[✓] Connected device (4 available)
! Error: Browsing on the local area network for Shohzoda. Ensure the device is unlocked and attached with a cable or associated with
the same local area network as this Mac.
The device must be opted into Developer Mode to connect wirelessly. (code -27)
[✓] Network resources

• No issues found!

## flutter error
D/nativeloader( 7639): Load /data/app/~~MMd2Lwh0mXl4Dv-Z-ScTow==/com.example.yandex_maps-Dis8lHIxXpNMXUBRIHr0iw==/base.apk!/lib/arm64-v8a/libmaps-mobile.so using ns clns-7 from class loader (caller=/data/app/~~MMd2Lwh0mXl4Dv-Z-ScTow==/com.example.yandex_maps-Dis8lHIxXpNMXUBRIHr0iw==/base.apk): ok
F/libc    ( 7639): Fatal signal 6 (SIGABRT), code -1 (SI_QUEUE) in tid 7639 (ple.yandex_maps), pid 7639 (ple.yandex_maps)
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Build fingerprint: 'google/sdk_gphone64_arm64/emu64a:15/AE3A.240806.005/12228598:userdebug/dev-keys'
Revision: '0'
ABI: 'arm64'
Timestamp: 2025-03-17 13:51:21.489227928+0300
Process uptime: 25s
Cmdline: com.example.yandex_maps
pid: 7639, tid: 7639, name: ple.yandex_maps  >>> com.example.yandex_maps <<<
uid: 10211
tagged_addr_ctrl: 0000000000000001 (PR_TAGGED_ADDR_ENABLE)
pac_enabled_keys: 000000000000000f (PR_PAC_APIAKEY, PR_PAC_APIBKEY, PR_PAC_APDAKEY, PR_PAC_APDBKEY)
signal 6 (SIGABRT), code -1 (SI_QUEUE), fault addr --------
x0  0000000000000000  x1  0000000000001dd7  x2  0000000000000006  x3  0000007ff0e94f40
x4  000000000000000a  x5  000000000000000a  x6  000000000000000a  x7  7f7f7f7f7f7f7f7f
x8  00000000000000f0  x9  0000007c9fd29468  x10 ffffff80fffffb9f  x11 0000000000000001
x12 0000000000000016  x13 000000786b05c54c  x14 0000000000000000  x15 0000000000000010
x16 0000007c9fdd8ff8  x17 0000007c9fdc31c0  x18 0000007cb24ec000  x19 0000000000001dd7
x20 0000000000001dd7  x21 00000000ffffffff  x22 0000007700008081  x23 b400007a6ce8a2f0
x24 0000007700008081  x25 0000007ff06ba000  x26 b400007b3ce7e330  x27 0000007700f26080
x28 0000000800000077  x29 0000007ff0e94fc0
lr  0000007c9fd616a4  sp  0000007ff0e94f20  pc  0000007c9fd616d4  pst 0000000000001000
5 total frames
backtrace:
#00 pc 000000000005b6d4  /apex/com.android.runtime/lib64/bionic/libc.so (abort+168) (BuildId: 1b9fecf834d610f77e641f026ca7269b)
#01 pc 0000000000a7c57c  /data/app/~~MMd2Lwh0mXl4Dv-Z-ScTow==/com.example.yandex_maps-Dis8lHIxXpNMXUBRIHr0iw==/base.apk!libmaps-mobile.so (offset 0x35bc000) (BuildId: 7ee77cae6b6ddc2b)
#02 pc 0000000000a89e54  /data/app/~~MMd2Lwh0mXl4Dv-Z-ScTow==/com.example.yandex_maps-Dis8lHIxXpNMXUBRIHr0iw==/base.apk!libmaps-mobile.so (offset 0x35bc000) (BuildId: 7ee77cae6b6ddc2b)
#03 pc 0000000000aa6348  /data/app/~~MMd2Lwh0mXl4Dv-Z-ScTow==/com.example.yandex_maps-Dis8lHIxXpNMXUBRIHr0iw==/base.apk!libmaps-mobile.so (offset 0x35bc000) (yandex_flutter_runtime_i18n_I18nManagerFactory_setLocale+52) (BuildId: 7ee77cae6b6ddc2b)
#04 pc 0000000000008184  [anon:dart-code]
