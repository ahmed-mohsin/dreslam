import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'Decorations.dart';
import 'Rooms.dart';
import 'RoomsContent/RoomContentVideos.dart';

class YoutubePlayerPage extends StatefulWidget {
  String id;

  YoutubePlayerPage(this.id);

  @override
  _YoutubePlayerPageState createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _playercontroller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  final String id = 'wDVb99o0U2c';

  @override
  void initState() {
    super.initState();
    _playercontroller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: true,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_playercontroller.value.isFullScreen) {
      setState(() {
        _playerState = _playercontroller.value.playerState;
        _videoMetaData = _playercontroller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _playercontroller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _playercontroller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(image: decorationImage("bg/jpg")),
        child: Container(
          child: YoutubePlayer(
            controller: _playercontroller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            topActions: <Widget>[
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  _playercontroller.metadata.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(19.0),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withOpacity(.2)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 25.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ],
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (data) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => TheEnd()));
            },
          ),
        ),
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700];
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900];
      default:
        return Colors.blue;
    }
  }

  Widget get _space => SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  var id = YoutubePlayer.convertUrlToId(
                    _idController.text,
                  );
                  if (action == 'LOAD') _playercontroller.load(id);
                  if (action == 'CUE') _playercontroller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  _showSnackBar('Source can\'t be empty!');
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}

class TheEnd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: decorationImage("bg.png")),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(image: decorationImage("logo.png")),
                ),
              ),
              Text(
                "The End \n Thank you for watching",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(19.0),
                child: Container(
                  width: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: Colors.lightGreenAccent.withOpacity(.2)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "العودة للصفحه الرئيسية",
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Rooms()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
