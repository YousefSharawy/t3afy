import 'package:flutter_test/flutter_test.dart';
import 'package:t3afy/app/local_storage.dart';

import '../helpers/hive_test_helper.dart';

void main() {
  setUp(() async => setUpHive());
  tearDown(() async => tearDownHive());

  group('Cache invalidation', () {
    test('setCache then getCache returns data within TTL', () async {
      await LocalAppStorage.setCache('key1', {'value': 42});
      final result = LocalAppStorage.getCache('key1');
      expect(result, isNotNull);
      expect(result['value'], 42);
    });

    test('invalidateCache removes the cached entry', () async {
      await LocalAppStorage.setCache('campaigns_list', ['c1', 'c2']);
      expect(LocalAppStorage.getCache('campaigns_list'), isNotNull);

      await LocalAppStorage.invalidateCache('campaigns_list');
      expect(LocalAppStorage.getCache('campaigns_list'), isNull);
    });

    test('invalidateCacheByPrefix removes all matching keys', () async {
      await LocalAppStorage.setCache('campaigns_list', ['c1']);
      await LocalAppStorage.setCache('campaigns_stats', {'total': 5});
      await LocalAppStorage.setCache('volunteers_list', ['v1']);

      await LocalAppStorage.invalidateCacheByPrefix('campaigns_');

      expect(LocalAppStorage.getCache('campaigns_list'), isNull);
      expect(LocalAppStorage.getCache('campaigns_stats'), isNull);
      // Unrelated key should still be present
      expect(LocalAppStorage.getCache('volunteers_list'), isNotNull);
    });

    test('getCache returns null for expired entry', () async {
      // Set with a TTL already in the past by writing raw expired data
      await LocalAppStorage.setCache(
        'expired_key',
        'data',
        ttl: const Duration(milliseconds: 1),
      );
      // Wait past TTL
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(LocalAppStorage.getCache('expired_key'), isNull);
    });

    test('multiple invalidations are idempotent', () async {
      await LocalAppStorage.setCache('camp', 'data');
      await LocalAppStorage.invalidateCache('camp');
      // Second invalidation on already-absent key should not throw
      await expectLater(
        LocalAppStorage.invalidateCache('camp'),
        completes,
      );
    });

    test('after campaign delete — campaigns_list and campaigns_stats cleared',
        () async {
      await LocalAppStorage.setCache('campaigns_list', ['c1']);
      await LocalAppStorage.setCache('campaigns_stats', {'total': 3});

      // Simulate what CampaignDetailCubit.load(invalidateListCache: true) does
      await LocalAppStorage.invalidateCache('campaigns_list');
      await LocalAppStorage.invalidateCache('campaigns_stats');

      expect(LocalAppStorage.getCache('campaigns_list'), isNull);
      expect(LocalAppStorage.getCache('campaigns_stats'), isNull);
    });

    test('invalidating one key does not affect other keys', () async {
      await LocalAppStorage.setCache('key_a', 'aaa');
      await LocalAppStorage.setCache('key_b', 'bbb');

      await LocalAppStorage.invalidateCache('key_a');

      expect(LocalAppStorage.getCache('key_a'), isNull);
      expect(LocalAppStorage.getCache('key_b'), 'bbb');
    });
  });
}
