import 'dart:async';

import 'package:chat_models/chat_models.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:rest_api_server/mongo_collection.dart';

/// Chats Collection
/// 
/// Implements basic operations with MongoDb chats collection
class ChatsCollection extends MongoCollection<Chat, ChatId> {
  ChatsCollection(mongo.DbCollection collection) : super(collection);

  @override
  Future<Chat> insert(Chat chat) async {
    final id = mongo.ObjectId();
    await collection.insert(_replaceObjectsWithIds(chat.json)
      ..addAll({'_id': id})
      ..remove('id'));
    return getObjectById(id);
  }

  @override
  Future<Chat> update(Chat chat) async {
    final mongoId = mongo.ObjectId.fromHexString(chat.id.json);
    await collection.update(mongo.where.eq('_id', mongoId),
        {r'$set': _replaceObjectsWithIds(chat.json)..remove('id')});
    return getObjectById(mongoId);
  }

  @override
  Future<Chat> replace(Chat chat) async {
    final mongoId = mongo.ObjectId.fromHexString(chat.id.json);
    await collection.update(mongo.where.eq('_id', mongoId),
        _replaceObjectsWithIds(chat.json)..remove('id'));
    return getObjectById(mongoId);
  }

  @override
  Chat createModel(Map<String, dynamic> data) => Chat.fromJson(data);

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
          'members': {
            r'$map': {
              'input': r'$members',
              'as': 'userid',
              'in': {r'$toObjectId': r'$$userid'}
            }
          }
        }
      },
      // Подставляем вместо идентификаторов данные пользователей
      {
        r'$lookup': {
          'from': 'users',
          'localField': 'members',
          'foreignField': '_id',
          'as': 'members'
        }
      },
      // Добавляем строковые значения id
      {
        r'$addFields': {
          'id': {r'$toString': r'$_id'},
          'members': {
            r'$map': {
              'input': r'$members',
              'as': 'user',
              'in': {
                r'$mergeObjects': [
                  r'$$user',
                  {
                    'id': {r'$toString': r'$$user._id'}
                  }
                ]
              }
            }
          }
        }
      },
      // Удаляем ненужные поля
      {
        r'$project': {r'_id': false, r'members._id': false}
      }
    ]);
    return pipeline;
  }

  Map<String, dynamic> _replaceObjectsWithIds(Map<String, dynamic> json) {
    final result = Map<String, dynamic>.from(json);
    if (result['members'] is List) {
      result.update('members', (objects) {
        return objects.map((object) => object['id']).toList();
      });
    }
    return result;
  }
}
