import 'dart:convert';

/*server side Post class */
class Post {
  int post_id;
  String title;
  String description;
  DateTime posted_at;
  DateTime last_edited;
  String user;
  String editor;
  int up_votes;
  int down_votes;
  int total_votes;
  String links_to;
  List<String> tags;
  
  Post.fromSQL(List sql_post) {
    this..post_id = sql_post[0]
        ..title = sql_post[1]
        ..description = sql_post[2]
        ..posted_at = sql_post[3]
        ..last_edited = sql_post[4]
        ..user = sql_post[5]
        ..editor = sql_post[6]
        ..up_votes = sql_post[7]
        ..down_votes = sql_post[8]
        ..links_to = sql_post[9];
    total_votes = up_votes - down_votes;
    sql_post.skip(10).forEach((tag) => tags = tag.split(", "));
  }
  
  Post.fromJSON(String json_post){
    Map post_from_json = JSON.decode(json_post);
    this..post_id = post_from_json['post_id']
        ..title = post_from_json['title']
        ..description = post_from_json['description']
        ..posted_at = post_from_json['posted_at']
        ..last_edited = post_from_json['last_eidited']
        ..user = post_from_json['user']
        ..editor = post_from_json['editor']
        ..up_votes = post_from_json['up_votes']
        ..down_votes = post_from_json['down_votes']
        ..total_votes = post_from_json['total_votes']
        ..links_to = post_from_json['links_to'];
  }
    
  toJson(){
    Map fromObject = {
      'post_id' : post_id,
      'title' : title,
      'description' : description,
      'posted_at' : posted_at,
      'last_edited' : last_edited,
      'user' : user,
      'editor' : editor,
      'up_votes' : up_votes,
      'dwon_votes' : down_votes,
      'total_votes' : total_votes,
      'links_to' : links_to,
      'tags' : tags
    };
    
    return JSON.encode(fromObject);
  }
}