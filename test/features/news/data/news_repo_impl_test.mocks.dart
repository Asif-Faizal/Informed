// Mocks generated by Mockito 5.4.5 from annotations
// in tdd_clean/test/features/news/data/news_repo_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:tdd_clean/core/connection/network_info.dart' as _i6;
import 'package:tdd_clean/features/news/data/news_local_datasource.dart' as _i5;
import 'package:tdd_clean/features/news/data/news_model.dart' as _i4;
import 'package:tdd_clean/features/news/data/news_remote_datasource.dart'
    as _i2;

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

/// A class which mocks [NewsRemoteDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockNewsRemoteDatasource extends _i1.Mock
    implements _i2.NewsRemoteDatasource {
  MockNewsRemoteDatasource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.NewsModel>> getQueryNews(String? query) =>
      (super.noSuchMethod(
            Invocation.method(#getQueryNews, [query]),
            returnValue: _i3.Future<List<_i4.NewsModel>>.value(
              <_i4.NewsModel>[],
            ),
          )
          as _i3.Future<List<_i4.NewsModel>>);

  @override
  _i3.Future<List<_i4.NewsModel>> getCountryNews(
    String? country,
    String? category,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getCountryNews, [country, category]),
            returnValue: _i3.Future<List<_i4.NewsModel>>.value(
              <_i4.NewsModel>[],
            ),
          )
          as _i3.Future<List<_i4.NewsModel>>);
}

/// A class which mocks [NewsLocalDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockNewsLocalDatasource extends _i1.Mock
    implements _i5.NewsLocalDatasource {
  MockNewsLocalDatasource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.NewsModel>> getLastNews() =>
      (super.noSuchMethod(
            Invocation.method(#getLastNews, []),
            returnValue: _i3.Future<List<_i4.NewsModel>>.value(
              <_i4.NewsModel>[],
            ),
          )
          as _i3.Future<List<_i4.NewsModel>>);

  @override
  _i3.Future<void> cacheNews(List<_i4.NewsModel>? newsToCache) =>
      (super.noSuchMethod(
            Invocation.method(#cacheNews, [newsToCache]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i6.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<bool> get isConnected =>
      (super.noSuchMethod(
            Invocation.getter(#isConnected),
            returnValue: _i3.Future<bool>.value(false),
          )
          as _i3.Future<bool>);
}
