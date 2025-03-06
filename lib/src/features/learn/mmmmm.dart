import 'package:audio_manager/audio_manager.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miracle/color.dart';

import 'package:miracle/src/data/model/audio.dart';
import 'package:miracle/src/features/learn/just.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:rxdart/rxdart.dart';

class MyApp extends StatefulWidget {
  final Audio audio;

  const MyApp({super.key, required this.audio});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isPlaying = false;
  final _player = AudioPlayer();
  late Duration _duration;
  late Duration _position;
  late double _slider;
  late double _sliderVolume;
  late String _error;
  int maxduration = 100;
  int currentpos = 0;
  String currentpostlabel = "00:00";
  String audioasset = "assets/audio/red-indian-music.mp3";
  bool isplaying = false;
  bool audioplayed = false;
  AudioPlayer player = AudioPlayer();
  num curIndex = 0;
  late Uint8List audiobytes;
  PlayMode playMode = AudioManager.instance.playMode;

  final list = [];

  @override
  void initState() {
    super.initState();
    list.add(
      {
        "title": widget.audio.title,
        "desc": "assets playback",
        "url": Uri.parse("${kBaseUrl}audio-files/${widget.audio.audioFile}"),
        "coverUrl": "assets/images/brand-logo.png"
      },
    );

    _init();
    //initPlatformState();
    setupAudio();
    // loadFile();

    _sliderVolume = 0.1;
    _position = AudioManager.instance.position;
    _error = "";
    _slider = 1.0;
    _duration = AudioManager.instance.duration;

    super.initState();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(AudioSource.uri(
          Uri.parse("${kBaseUrl}audio-files/${widget.audio.audioFile}")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void dispose() {
    if (mounted) {
      setState(() {});
    }
    //  AudioManager.instance.release();
    super.dispose();
  }

  void setupAudio() {
    List<AudioInfo> audioList = [];
    for (var item in list) {
      audioList.add(AudioInfo(item["url"].toString(),
          title: item["title"].toString(),
          desc: item["desc"].toString(),
          coverUrl: item["coverUrl"].toString()));
    }

    AudioManager.instance.audioList = audioList;
    AudioManager.instance.intercepter = true;
    AudioManager.instance.play(auto: false);

    AudioManager.instance.onEvents((events, args) {
      print("$events, $args");
      switch (events) {
        case AudioManagerEvents.start:
          print(
              "start load data callback, curIndex is ${AudioManager.instance.curIndex}");
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          _slider = 0;
          setState(() {});
          AudioManager.instance.updateLrc("audio resource loading....");
          break;
        case AudioManagerEvents.ready:
          print("ready to play");
          _error = "";
          _sliderVolume = AudioManager.instance.volume;
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          setState(() {});
          // if you need to seek times, must after AudioManagerEvents.ready event invoked
          // AudioManager.instance.seekTo(Duration(seconds: 10));
          break;
        case AudioManagerEvents.seekComplete:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          setState(() {});
          print("seek event is completed. position is [$args]/ms");
          break;
        case AudioManagerEvents.buffering:
          print("buffering $args");
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = AudioManager.instance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          setState(() {});
          AudioManager.instance.updateLrc(args["position"].toString());
          break;
        case AudioManagerEvents.error:
          _error = args;
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;
        case AudioManagerEvents.volumeChange:
          _sliderVolume = AudioManager.instance.volume;
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  /* void loadFile() async {
    // read bundle file to local path
    final audioFile = await rootBundle.load("assets/aLIEz.m4a");
    final audio = audioFile.buffer.asUint8List();

    final appDocDir = await getApplicationDocumentsDirectory();
    print(appDocDir);

    final file = File("${appDocDir.path}/aLIEz.m4a");
    file.writeAsBytesSync(audio);

    AudioInfo info = AudioInfo("file://${file.path}",
        title: "file", desc: "local file", coverUrl: "assets/aLIEz.jpg");

    list.add(info.toJson());
    AudioManager.instance.audioList.add(info);
    setState(() {});
  }*/

/*  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await AudioManager.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;


  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: primaryColor,
        title: Text(widget.audio.title,
        style: const TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${kBaseUrl}img/audio/${widget.audio.image}',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * .7,
                height: MediaQuery.of(context).size.width * .7,
              ),
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(list[index]["title"].toString(),
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                      subtitle: Center(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(list[index]["desc"].toString()),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: SizedBox(
                                    width: 300,
                                    child: Text(
                                      "Please keep your mobile silent to avoid other notification disturbance.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ],
                          )
                        ],
                      )),
                      onTap: () => AudioManager.instance.play(index: index),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: list.length),
            ),
            Center(child: Text(_error)),
            bottomPanel()
          ],
        ),
      ),
    );
  }

  Widget bottomPanel() {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            /*StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition:
              positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: _player.seek,
            );
          },
    ),*/
            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: songProgress(context),
        ),
        /* ControlButtons(player: _player),
          const Spacer(),*/
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    bool playing = await AudioManager.instance.playOrPause();
                    print("await -- $playing");
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 48.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
              child: volumeFrame(),
            )
          ],
        ),
      ),
    ]);
  }

  Widget getPlayModeIcon(PlayMode playMode) {
    switch (playMode) {
      case PlayMode.sequence:
      /* return Icon(
          Icons.repeat,
        );*/
      case PlayMode.shuffle:
      /*return Icon(
          Icons.shuffle,
        );*/
      case PlayMode.single:
      /* return Icon(
          Icons.repeat_one,
        );*/
    }
    return Container();
  }

  Widget songProgress(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          _formatDuration(_position),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbColor: Colors.blueAccent,
                  overlayColor: Colors.blue,
                  thumbShape: const RoundSliderThumbShape(
                    disabledThumbRadius: 5,
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                  activeTrackColor: Colors.blueAccent,
                  inactiveTrackColor: Colors.grey,
                ),
                child: Slider(
                  min: 0.0,
                  max: 1.0,

                  // tracks are 30 seconds
                  value: _slider,
                  onChanged: (value) {
                    setState(() {
                      _slider = value;
                    });
                  },
                  onChangeEnd: (value) {
                    Duration msec = Duration(
                        milliseconds:
                            (_duration.inMilliseconds * value).round());
                    AudioManager.instance.seekTo(msec);
                  },
                )),
          ),
        ),
        Text(
          _formatDuration(_duration),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format =
        "${(minute < 10) ? "0$minute" : "$minute"}:${(second < 10) ? "0$second" : "$second"}";
    return format;
  }

  Widget volumeFrame() {
    return Row(children: <Widget>[
      IconButton(
          icon: const Icon(
            Icons.volume_up,
          ),
          onPressed: () {
            AudioManager.instance.setVolume(0);
          }),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Slider(
                value: _sliderVolume,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  setState(() {
                    _sliderVolume = value;
                    AudioManager.instance.setVolume(value, showVolume: true);
                  });
                },
              )))
    ]);
  }
}
