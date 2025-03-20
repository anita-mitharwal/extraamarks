// Mocks generated by Mockito 5.4.5 from annotations
// in extraaedge_task/test/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:extraaedge_task/data/local/db_helper.dart' as _i3;
import 'package:extraaedge_task/data/models/rocket_model.dart' as _i4;
import 'package:extraaedge_task/data/services/api_services.dart' as _i2;
import 'package:extraaedge_task/repository/rocket_repository.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeApiService_0 extends _i1.SmartFake implements _i2.ApiService {
  _FakeApiService_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeDBHelper_1 extends _i1.SmartFake implements _i3.DBHelper {
  _FakeDBHelper_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeRocket_2 extends _i1.SmartFake implements _i4.Rocket {
  _FakeRocket_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [RocketRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockRocketRepository extends _i1.Mock implements _i5.RocketRepository {
  MockRocketRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ApiService get apiService =>
      (super.noSuchMethod(
            Invocation.getter(#apiService),
            returnValue: _FakeApiService_0(
              this,
              Invocation.getter(#apiService),
            ),
          )
          as _i2.ApiService);

  @override
  _i3.DBHelper get dbHelper =>
      (super.noSuchMethod(
            Invocation.getter(#dbHelper),
            returnValue: _FakeDBHelper_1(this, Invocation.getter(#dbHelper)),
          )
          as _i3.DBHelper);

  @override
  _i6.Future<List<_i4.Rocket>> getRockets({int? limit = 10, int? offset = 0}) =>
      (super.noSuchMethod(
            Invocation.method(#getRockets, [], {
              #limit: limit,
              #offset: offset,
            }),
            returnValue: _i6.Future<List<_i4.Rocket>>.value(<_i4.Rocket>[]),
          )
          as _i6.Future<List<_i4.Rocket>>);

  @override
  _i6.Future<_i4.Rocket> getRocketDetails(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#getRocketDetails, [id]),
            returnValue: _i6.Future<_i4.Rocket>.value(
              _FakeRocket_2(this, Invocation.method(#getRocketDetails, [id])),
            ),
          )
          as _i6.Future<_i4.Rocket>);
}
