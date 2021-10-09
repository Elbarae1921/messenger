import 'package:graphql/client.dart';
import 'package:messenger/utils/env.dart';
import 'package:messenger/models/gql.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/utils/services/shared_preferences.dart';

enum QueryMode { mutate, query }

class GqlClient {
  static final _httpLink = HttpLink(Env.API_URL);

  static Future<GraphQLClient> get _client async {
    final token = await Prefs.getToken();

    if (token == null)
      return GraphQLClient(
        cache: GraphQLCache(),
        link: _httpLink,
      );
    else
      return GraphQLClient(
        cache: GraphQLCache(),
        link: AuthLink(
          getToken: () => 'Bearer $token',
        ).concat(_httpLink),
      );
  }

  static Future<Map<String, dynamic>> fetch({
    required String document,
    Map<String, dynamic>? variables,
    required QueryMode queryMode,
  }) async {
    final result = await (queryMode == QueryMode.query
        ? (await _client).query(QueryOptions(
            document: gql(document),
            variables: variables ?? {},
          ))
        : (await _client).mutate(MutationOptions(
            document: gql(document),
            variables: variables ?? {},
          )));

    if (result.hasException) {
      print(result.exception.toString());
    }

    return result.data!;
  }
}

class Queries {
  static Future<User> me() async {
    const String document = r'''
    query {
      me { id, firstName, lastName, fullName, email }
    }
    ''';

    final result = await GqlClient.fetch(
      document: document,
      queryMode: QueryMode.query,
    );

    return User.fromJson(result['me']);
  }

  static Future<User> getPosts({
    required int cursor,
    required int limit,
  }) async {
    const String document = r'''
    query {
      getPosts(data: { cursor: $cursor, limit: $limit }) {
        results {
          id
          content
          image
          isPrivate
          user {
            fullName
          }
          likers {
            fullName
          }
          comments {
            content
          }
          likes
        }
        hasMore
      }
    }
    ''';

    final variables = <String, dynamic>{
      'cursor': cursor,
      'limit': limit,
    };

    final result = await GqlClient.fetch(
      document: document,
      variables: variables,
      queryMode: QueryMode.query,
    );

    return User.fromJson(result['getPosts']);
  }
}

class Mutations {
  static Future<LoginOutput> register({
    required String password,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    const String document = r'''
    mutation Register($data: RegisterInput!) {
      register(data: $data) {
        user { id, firstName, lastName, fullName, email },
        jwt
      }
    }
    ''';

    final variables = <String, dynamic>{
      'data': {
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      },
    };

    final result = await GqlClient.fetch(
      document: document,
      variables: variables,
      queryMode: QueryMode.mutate,
    );

    return LoginOutput.fromJson(result['register']);
  }

  static Future<LoginOutput> login({
    required String password,
    required String email,
  }) async {
    const document = r'''
    mutation Login($data: LoginInput!) {
      login(data: $data) {
        user { id, firstName, lastName, fullName, email },
        jwt
      }
    }
    ''';

    final variables = <String, dynamic>{
      'data': {
        'password': password,
        'email': email,
      },
    };

    final result = await GqlClient.fetch(
      document: document,
      variables: variables,
      queryMode: QueryMode.mutate,
    );

    return LoginOutput.fromJson(result['login']);
  }

  static Future<LoginOutput> like({
    required bool like,
  }) async {
    const document = r'''
    mutation LikePost($data: IdInput!) {
      like(data: $data)
    }
    ''';

    final variables = <String, dynamic>{
      'data': {
        'like': like,
      },
    };

    final result = await GqlClient.fetch(
      document: document,
      variables: variables,
      queryMode: QueryMode.mutate,
    );

    return LoginOutput.fromJson(result['like']);
  }
}
