
import 'package:postgresql/postgresql.dart';

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
        .then((_) => conn.close());
    })
    .catchError(print);
  }
}