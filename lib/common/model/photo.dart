class Photo {
  final int farm;
  final String id;
  final String owner;
  final String secret;
  final String server;
  final String title;

  Photo(this.farm, this.id, this.owner, this.secret, this.server, this.title);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Photo &&
              runtimeType == other.runtimeType &&
              farm == other.farm &&
              id == other.id &&
              owner == other.owner &&
              secret == other.secret &&
              server == other.server &&
              title == other.title;

  @override
  int get hashCode =>
      farm.hashCode ^
      id.hashCode ^
      owner.hashCode ^
      secret.hashCode ^
      server.hashCode ^
      title.hashCode;
}
