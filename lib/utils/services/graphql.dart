import 'package:graphql/client.dart';
import 'package:messenger/env.dart';
import 'package:messenger/models/gql.dart';
import 'package:messenger/models/user.dart';

enum QueryMode { mutate, query }

class GqlClient {
  static final _httpLink = HttpLink(Env.API_URL);

  // static final _authLink = AuthLink(
  //   getToken: () async => 'Bearer $_accessToken',
  // );

  static GraphQLClient get _client => GraphQLClient(
        cache: GraphQLCache(),
        link: /* _authLink.concat( */ _httpLink /* ) */,
      );

  static Future<Map<String, dynamic>> fetch({
    required String document,
    Map<String, dynamic>? variables,
    required QueryMode queryMode,
  }) async {
    final result = await (queryMode == QueryMode.query
        ? _client.query(QueryOptions(
            document: gql(document),
            variables: variables ?? {},
          ))
        : _client.mutate(MutationOptions(
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

    return User.fromJson(result);
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
      login(data: $data) {
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

    return LoginOutput.fromJson(result);
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

    return LoginOutput.fromJson(result);
  }
}
