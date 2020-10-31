import 'dart:async';
import 'package:chat_models/chat_models.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:rest_api_server/mongo_collection.dart';

/// Messages Collection
/// 
/// Implements basic operations with MongoDB messages collection
class MessagesCollection extends MongoCollection<Message, MessageId> {
  MessagesCollection(mongo.DbCollection collection) : super(collection);

  @override
  Future<Message> insert(Message message) async {
    final id = mongo.ObjectId();
    await collection.insert(_replaceObjectsWithIds(message.json)
      ..addAll({'_id': id})
      ..remove('id'));
    return getObjectById(id);
  }

  @override
  Message createModel(Map<String, dynamic> data) => Message.fromJson(data);

  @override
  List<Map<String, dynamic>> buildPipeline(mongo.SelectorBuilder query) {
    final pipeline = <Map<String, dynamic>>[];
    if (query.map.containsKey(r'$query')) {
      pipeline.add({r'$match': query.map[r'$query']});
    }
    pipeline.addAll([
      // Преобразование строковых идентификаторов в ObjectId для выполнения связывания
      {
        r'$addFields': {
          'author': {r'$toObjectId': r'$author'}
        }
      },
      // Подставляем вместо идентификаторов данные пользователей
      {
        r'$lookup': {
          'from': 'users',
          'localField': 'author',
          'foreignField': '_id',
          'as': 'author'
        }
      },
      {r'$unwind': r'$author'},
      // Добавляем строковые значения id
      {
        r'$addFields': {
          'id': {r'$toString': r'$_id'},
          'author.id': {r'$toString': r'$author._id'}
        }
      },
      // Удаляем ненужные поля
      {
        r'$project': {
          '_id': false,
          'author': {'_id': false, 'password': false}
        }
      }
    ]);
    return pipeline;
  }

  Map<String, dynamic> _replaceObjectsWithIds(Map<String, dynamic> json) {
    final result = Map<String, dynamic>.from(json);
    if (result['author'] is Map) {
      result.update('author', (object) => object['id']);
    }
    return result;
  }
}
