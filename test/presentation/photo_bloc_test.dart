import 'package:flickr_viewer/common/model/page_of_photos.dart';
import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flickr_viewer/domain/get_photos_by_keyword_use_case.dart';
import 'package:flickr_viewer/presentation/photo_bloc.dart';
import 'package:flickr_viewer/presentation/photo_view_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../test_util.dart';

class MockedGetPhotosByResultUseCase extends Mock
    implements GetPhotosByKeywordUseCase {}

main() {
  GetPhotosByKeywordUseCase usecase;
  PhotoBloc photoBloc;

  setUp(() {
    usecase = MockedGetPhotosByResultUseCase();
    photoBloc = PhotoBloc(usecase);
  });

  tearDown(() {
    photoBloc.dispose();
  });

  group('about loading photos functionality', () {
    test(
      'should start with Idling state and disallow loading next page',
      () async {
        await photoBloc.photoState.expect(emits(Idling()));
        photoBloc.loadNextPage();
        verifyZeroInteractions(usecase);
      },
    );

    test(
      'should move to Searching state and disallow loading next page',
      () async {
        when(usecase.getPhotos('batman', 1))
            .thenAnswer((_) => Stream.value(Loading()));
        photoBloc.onKeywordChanged('batman');
        await photoBloc.photoState.expect(emitsInOrder([Idling(), Searching()]));
        photoBloc.loadNextPage();
        verify(usecase.getPhotos('batman', 1));
        verifyNever(usecase.getPhotos('batman', 2));
      },
    );

    test(
      'should move to PhotosFetched state and be able to load next page',
      () async {
        when(usecase.getPhotos('batman', 1)).thenAnswer(
          (_) => Stream.fromIterable(
            [
              Loading(),
              Success(
                PageOfPhotos(
                  1,
                  2,
                  [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
                ),
              ),
            ],
          ),
        );
        when(usecase.getPhotos('batman', 2))
            .thenAnswer((_) => Stream.value(Loading()));
        photoBloc.onKeywordChanged('batman');

        final broadcastState = photoBloc.photoState.asBroadcastStream();

        await broadcastState.expect(emitsInOrder(
          [
            Idling(),
            Searching(),
            PhotosFetched(
              'batman',
              [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
            ),
          ],
        ));

        photoBloc.loadNextPage();

        await broadcastState.expect(
          emits(
            LoadingNextPage(
              [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
            ),
          ),
        );
      },
    );

    test(
      'should move to Idling again',
      () async {
        when(usecase.getPhotos('batman', 1)).thenAnswer(
          (_) => Stream.fromIterable(
            [
              Loading(),
              Success(
                PageOfPhotos(
                  1,
                  2,
                  [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
                ),
              ),
            ],
          ),
        );
        photoBloc.onKeywordChanged('batman');

        final broadcastState = photoBloc.photoState.asBroadcastStream();

        await broadcastState.expect(emitsInOrder(
          [
            Idling(),
            Searching(),
            PhotosFetched(
              'batman',
              [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
            ),
          ],
        ));

        photoBloc.resetSearch();
        await broadcastState.expect(emits(Idling()));
      },
    );

    test(
      'should move to NotFound state and not be able to load next page',
      () async {
        when(usecase.getPhotos('batman', 1)).thenAnswer(
          (_) => Stream.fromIterable(
            [
              Loading(),
              Success(
                PageOfPhotos(1, 1, []),
              ),
            ],
          ),
        );

        photoBloc.onKeywordChanged('batman');

        final broadcastState = photoBloc.photoState.asBroadcastStream();

        await broadcastState.expect(emitsInOrder(
          [
            Idling(),
            Searching(),
            NotFound('batman'),
          ],
        ));

        photoBloc.loadNextPage();

        verifyNever(usecase.getPhotos('batman', 2));
      },
    );

    test(
      'should not be able to load next page if last page is reached',
      () async {
        when(usecase.getPhotos('batman', 1)).thenAnswer(
          (_) => Stream.fromIterable(
            [
              Loading(),
              Success(
                PageOfPhotos(
                  1,
                  1, //only has 1 page and it is reached
                  [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
                ),
              ),
            ],
          ),
        );
        photoBloc.onKeywordChanged('batman');

        final broadcastState = photoBloc.photoState.asBroadcastStream();

        await broadcastState.expect(emitsInOrder(
          [
            Idling(),
            Searching(),
            PhotosFetched(
              'batman',
              [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
            ),
          ],
        ));

        photoBloc.loadNextPage();
        verifyNever(usecase.getPhotos('batman', 2));
      },
    );

    test(
      'should move to SearchFailed state and not be able to load next page',
      () async {
        when(usecase.getPhotos('batman', 1)).thenAnswer(
          (_) => Stream.fromIterable(
            [
              Loading(),
              Failure(Exception()),
            ],
          ),
        );
        photoBloc.onKeywordChanged('batman');

        final broadcastState = photoBloc.photoState.asBroadcastStream();

        await broadcastState.expect(emitsInOrder(
          [
            Idling(),
            Searching(),
            SearchFailed('batman'),
          ],
        ));

        photoBloc.loadNextPage();
        verify(usecase.getPhotos('batman', 1));
        verifyNever(usecase.getPhotos('batman', 2));
      },
    );

    test(
      'should retry query without any problem',
      () async {
        when(usecase.getPhotos('batman', 1)).thenAnswer(
          (_) => Stream.fromIterable(
            [
              Loading(),
              Failure(Exception()),
            ],
          ),
        );
        photoBloc.onKeywordChanged('batman');

        final broadcastState = photoBloc.photoState.asBroadcastStream();

        await broadcastState.expect(emitsInOrder(
          [
            Idling(),
            Searching(),
            SearchFailed('batman'),
          ],
        ));

        when(usecase.getPhotos('batman', 1)).thenAnswer(
          (_) => Stream.fromIterable(
            [
              Loading(),
              Success(
                PageOfPhotos(
                  1,
                  1, //only has 1 page and it is reached
                  [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
                ),
              ),
            ],
          ),
        );
        photoBloc.onRetryQuery('batman');

        await broadcastState.expect(emitsInOrder(
          [
            Searching(),
            PhotosFetched(
              'batman',
              [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
            ),
          ],
        ));
      },
    );

    test(
      'should move to PhotosFetched state after loading new page and be able to load next page',
      () async {
        when(usecase.getPhotos('batman', 1)).thenAnswer(
          (_) => Stream.fromIterable(
            [
              Loading(),
              Success(
                PageOfPhotos(
                  1,
                  3,
                  [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
                ),
              ),
            ],
          ),
        );
        when(usecase.getPhotos('batman', 2)).thenAnswer(
          (_) => Stream.fromIterable([
            Loading(),
            Success(
              PageOfPhotos(
                2,
                3,
                [Photo(2, 'id', 'owner', 'secret', 'server', 'title')],
              ),
            ),
          ]),
        );
        when(usecase.getPhotos('batman', 3))
            .thenAnswer((_) => Stream.value(Loading()));
        photoBloc.onKeywordChanged('batman');

        final broadcastState = photoBloc.photoState.asBroadcastStream();

        await broadcastState.expect(
          emitsInOrder(
            [
              Idling(),
              Searching(),
              PhotosFetched(
                'batman',
                [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
              ),
            ],
          ),
        );

        photoBloc.loadNextPage();

        await broadcastState.expect(
          emitsInOrder(
            [
              LoadingNextPage(
                [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
              ),
              PhotosFetched(
                'batman',
                [
                  Photo(1, 'id', 'owner', 'secret', 'server', 'title'),
                  Photo(2, 'id', 'owner', 'secret', 'server', 'title')
                ],
              ),
            ],
          ),
        );

        photoBloc.loadNextPage();

        await broadcastState.expect(
          emits(
            LoadingNextPage(
              [
                Photo(1, 'id', 'owner', 'secret', 'server', 'title'),
                Photo(2, 'id', 'owner', 'secret', 'server', 'title')
              ],
            ),
          ),
        );
      },
    );

    test(
      'should move to LoadPageFailed state and be able to retry',
      () async {
        when(usecase.getPhotos('batman', 1)).thenAnswer(
          (_) => Stream.fromIterable(
            [
              Loading(),
              Success(
                PageOfPhotos(
                  1,
                  3,
                  [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
                ),
              ),
            ],
          ),
        );
        when(usecase.getPhotos('batman', 2)).thenAnswer(
          (_) => Stream.fromIterable([
            Loading(),
            Failure(Exception()),
          ]),
        );

        final broadcastState = photoBloc.photoState.asBroadcastStream();

        photoBloc.onKeywordChanged('batman');

        await broadcastState.expect(
          emitsInOrder(
            [
              Idling(),
              Searching(),
              PhotosFetched(
                'batman',
                [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
              ),
            ],
          ),
        );

        photoBloc.loadNextPage();

        await broadcastState.expect(
          emitsInOrder(
            [
              LoadingNextPage(
                [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
              ),
              LoadPageFailed(
                'batman',
                [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
              ),
            ],
          ),
        );

        when(usecase.getPhotos('batman', 2))
            .thenAnswer((_) => Stream.value(Loading()));

        photoBloc.loadNextPage();

        await broadcastState.expect(
          emits(
            LoadingNextPage(
              [Photo(1, 'id', 'owner', 'secret', 'server', 'title')],
            ),
          ),
        );
      },
    );
  });
}
