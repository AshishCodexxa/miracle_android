import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/audio.dart';
import 'package:miracle/src/features/learn/just.dart';
import 'package:miracle/src/utils/constant.dart';

class AudioPlayerScreen extends StatefulWidget {
  final Audio audio;

  const AudioPlayerScreen({super.key, required this.audio});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final player = AudioPlayer();
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool isLoading = false;

  String formatDuration(Duration? d) {
    if (d == null) return "00:00"; // Handle null case
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  void handlePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
    setState(() {}); // Update UI
  }

  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt()));
    setState(() {}); // Force UI update
  }

  Future<void> _setupAudio() async {
    try {
      if(mounted){
        setState(() {
          isLoading = true; // Show loader
        });
      }
      String url = "${kBaseUrl}audio-files/${widget.audio.audioFile}";
      print("Attempting to load audio from: $url");
      await player.setUrl(url);
      print("Audio loaded successfully.");
      if(mounted){
        setState(() {
          isLoading = false; // Show loader
        });
      }
      await player.play();
    } catch (e) {
      print("Error loading audio: $e");
    }

    player.positionStream.listen((p) {
      if(mounted) {
        setState(() {
        position = p;
      });
      }
    });

    player.durationStream.listen((d) {
      if(mounted) {
        setState(() {
        if (d != null) {
          duration = d;
        }
      });
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: primaryColor,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,
            color: Colors.white,),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              top: 50
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      '${kBaseUrl}img/audio/${widget.audio.image}',
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width * .7,
                      height: MediaQuery.of(context).size.width * .7,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    color: Colors.transparent,
                    child: Text(widget.audio.title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              /*Slider(
                min: 0,
                max: (duration.inSeconds > 0) ? duration.inSeconds.toDouble() : 1,
                value: (position.inSeconds > 0) ? position.inSeconds.toDouble() : 0,
                onChanged: (value) => handleSeek(value),
              ),*/
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: player.seek,
                  );
                },
              ),

              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 30,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      player.play();
                    },
                    icon: Icon(Icons.play_arrow,
                    size: 50,
                    color: player.playing ? primaryColor : Colors.grey,),
                  ),
                  IconButton(
                    onPressed: (){
                      player.pause();
                    },
                    icon: Icon(Icons.pause,
                      size: 50,
                      color: !player.playing ? primaryColor : Colors.grey,),
                  ),
                  IconButton(
                    onPressed: (){
                      player.seek(Duration.zero);
                    },
                    icon: const Icon(Icons.square,
                        size: 35,
                      color: primaryColor),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

            ],
          ),
          Visibility(
            visible: isLoading,
              child: const CircularProgressIndicator())
        ],
      ),
    );
  }
}
