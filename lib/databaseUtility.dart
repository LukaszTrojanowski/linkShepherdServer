import 'dart:async';
import 'package:postgresql/postgresql.dart';
import 'post.dart';


class DatabaseUtility {
  //Connection conn;
  String username;
  String passwd;
  String database;
  var uri;
  
  DatabaseUtility(this.username, this.passwd, this.database) {
    uri ='postgres://$username:$passwd@localhost:5432/$database';
    print(uri);
  }
  
  createUser(Map values){
    connect(uri)
    .then((conn){
      conn.execute('insert into users values(@login, @password, now(), now())', values)
        //.then((_) => conn.close())
        .catchError((err){
        print('Execute error in createUser: $err');
      })
      .whenComplete(() => conn.close());
    })
    .catchError((err) => print('Error in create user: $err'));
  }
  
  defineTag(Map values){
    connect(uri)
    .then((conn){
      conn.execute('insert into tags_definitions values(@tag, @description)', values)
        //.then((_) => conn.close())
        .catchError((err){
        print('Execute error in defineTag: $err');
      })
      .whenComplete(() => conn.close());
    })
    .catchError((err) => print('Error in defineTag: $err'));
  }
  
  addPost(Map post_values, [List<Map> tag_values]){
    Connection conn;
    connect(uri)
    .then((_conn){
      conn = _conn;
    })
    .then((_){
      conn.execute('''insert into posts(title, description, posted_at, last_edited, "user", editor, up_votes, down_votes, links_to)
                                  values(@title, @description, now(), now(), @user, @editor, 0, 0, @links_to)''', post_values)
      .catchError((err){
        print('Execute error in addPost: $err');
    })
    .then((_){if(tag_values != null){
      return _addTagToPost(conn, tag_values);
    }})
    .whenComplete(() => conn.close());
    })
    .catchError((err) => print('Error in addPost: $err'));
  }
  
  Future _addTagToPost(Connection conn, List<Map> values) =>
    Future.wait(values.map((value) => conn
        .execute(
            "insert into attached_tags values(currval('posts_post_id_seq'), @tag)",
            value)
        .catchError((err) => print('Execute error in addTagToPost: $err'))));
  
  voteOnPost(Map values) {
    connect(uri)
    .then((conn){
      conn.execute('insert into votes_log values(@post_id, @up_vote, @down_vote, @user, now())', values)
              .catchError((err){
            print('Execute error in addVoteToPost insert try update insted: $err');
            return conn.execute('''update votes_log up_vote = up_vote # @up_vote, down_vote = down_vote # @down_vote, @user, voted_at = now()
                      where user = @user
                      and post_id = @post_id''', values)
                            .catchError(()=>print('Error in update in addVoteToPost'));
          })
          .whenComplete(()=> conn.close());
    })
    .catchError((err) => print('Error in voteOnPost: $err'));
  }
  

  Future getPosts(int limit, int offset, String order_by){
    return connect(uri).then((conn){
      String query = """select * from posts 
                  order by $order_by desc
                  limit @limit offset @offset""";
      return conn.query(query, {'limit': limit, 'offset': offset})
              .map((row) => new Post.fromSQL(row.toList()))
              .toList()
      .whenComplete(() => conn.close());
    })
    .catchError((err) => print('Error in getPost: $err'));
  }
  
  getTagsForPost(List<Map> values) {
    connect(uri).then((conn){
      conn.query("""select tag from attached_tags
                    where post_id = @post_id""", values)
                    .toList()
                    .then((rows){
        print(rows);
      })
      .whenComplete(() => conn.close());
    })
    .catchError((err) => print('Error in getTagsForPosts'));
  }
  
  Future getPostsByTags(int limit, int offset, String order_by, List<String> _values){
    StringBuffer sbSubQuery = new StringBuffer();
    Map values = new Map();
    int index = 0;
    String prefix = '@';
    for (var tag in _values) {
      String key = 'tag' + index.toString();
      values.addAll({key : tag.toString()});
      sbSubQuery.write(prefix);
      sbSubQuery.write(key.toString());
      prefix = ', @';
      index++;
    }
    String subQuery = sbSubQuery.toString();
    String query = """select posts.*, string_agg(attached_tags.tag, ', ') from posts
                    inner join attached_tags
                    on posts.post_id = attached_tags.post_id
                    where posts.post_id in (select post_id
                                      from attached_tags
                                      where tag in ($subQuery))
                    group by posts.post_id
                    order by posts.posted_at desc""";
    return connect(uri).then((conn){
      return conn.query(query, values)
              .map((row) => new Post.fromSQL(row.toList()))
              .toList()
      .whenComplete(()=> conn.close());
    })
    .catchError((err) => print('Error in getPostsByTags'));
  }
  

}