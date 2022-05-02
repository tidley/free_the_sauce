# Free the Sauce
Let data be free.

Short demo
https://www.youtube.com/shorts/g-22A-N6_I8

IMG_20220329_120715.jpg - bafkreictuxpjnldmh2dtay3eq4u5cwygbxqs2bjpset5l77ydfqxvx7qnm

## Flow
1. Home
    1. _Select file..._ / _Select files..._
        1. await SelectSauce().selectFiles(_multi, ref);
            - `ref.read(fileNameListProvider.notifier).add(_file);`
    1. _Upload 1-by-1_ / _Zip-upload_
        1.FilePrep().upload(bool, apiKey, ref, _uploadFail),



## Todo
1. Upload broken = https://stackoverflow.com/questions/51396769/flutter-bad-state-stream-has-already-been-listened-to
1. Upload multiple  
    1. Seperately
    1. As one (compress)
1. Remove files in app storage when clicking clean / remove
1. Qr scan for nft.storage key
1. Add 'Share all' buttons
1. Add dividers in layout https://www.woolha.com/tutorials/flutter-using-divider-and-verticaldivider-widgets-examples


1. https://riverpod.dev/docs/providers/future_provider

## Requirements
1. To remove warning on debug startup edit line 275 in\
 __/home/tom/.pub-cache/hosted/pub.dartlang.org/flutter_riverpod-1.0.3/lib/src/framework.dart__\
`if (SchedulerBinding.instance!.schedulerPhase ==`\
to\
`if (SchedulerBinding.instance.schedulerPhase ==`

## Resources
Share
https://www.digitalocean.com/community/tutorials/flutter-share-plugin
FutureBuilder
https://flutterigniter.com/build-widget-with-async-method-call/
Rebuilds
https://flutterigniter.com/future-async-called-multiple-times/