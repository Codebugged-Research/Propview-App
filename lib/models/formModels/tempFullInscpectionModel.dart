class Room {
  String roomName;
  int roomId;
  Room({this.roomId, this.roomName});
}

class SubRoom {
  String subRoomName;
  int roomId;
  int subRoomId;
  SubRoom({this.roomId, this.subRoomId,this.subRoomName});
}
