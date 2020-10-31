import 'package:chat_models/chat_models.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:rest_api_server/mongo_collection.dart';

/// Users collection
/// 
/// Implements basic operations with MongoDb users collection
class UsersCollection extends MongoCollection<User, UserId> {
  UsersCollection(mongo.DbCollection collection) : super(collection);

  @override
  User createModel(Map<String, dynamic> data) => User.fromJson(data);

  @override
  List<Map<String, dynamic>> buildPipeline(mongo.SelectorBuilder query) {
    final pipeline = super.buildPipeline(query);
    pipeline
      ..firstWhere((stage) => stage.keys.first == r'$project')[r'$project']
          .addAll({'password': false});
    return pipeline;
  }
}
