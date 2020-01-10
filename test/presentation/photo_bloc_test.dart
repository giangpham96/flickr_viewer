import 'package:fake_async/fake_async.dart';
import 'package:flickr_viewer/common/model/keyword.dart';
import 'package:flickr_viewer/common/model/page_of_photos.dart';
import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flickr_viewer/domain/get_keywords_use_case.dart';
import 'package:flickr_viewer/domain/get_photos_by_keyword_use_case.dart';
import 'package:flickr_viewer/presentation/photo_bloc.dart';
import 'package:flickr_viewer/presentation/photo_view_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import '../test_util.dart';

class MockedGetPhotosByResultUseCase extends Mock
    implements GetPhotosByKeywordUseCase {}

class MockedGetKeywordUseCase extends Mock implements GetKeywordUseCase {}

main() {
  GetPhotosByKeywordUseCase usecase;
  GetKeywordUseCase getKeywordUseCase;
  PhotoBloc photoBloc;

  group('about keywords rendering functionality', () {
    tearDown(() {
      photoBloc.dispose();
    });

    test(
      'should move to Idle state with keywords if state hasnt changed',
      () {
        fakeAsync((async) {
          usecase = MockedGetPhotosByResultUseCase();
          getKeywordUseCase = MockedGetKeywordUseCase();
          when(getKeywordUseCase.getKeywords()).thenAnswer(
            (_) => Stream.fromIterable(
              [
                LoadingKeywords(),
                KeywordsLoaded([Keyword('test')]),
              ],
            ).delay(Duration(milliseconds: 200)),
          );
          photoBloc = PhotoBloc(usecase, getKeywordUseCase);
          var events = <PhotoViewState>[];
          photoBloc.photoState.listen(events.add);
          async.elapse(Duration(milliseconds: 400));
          expect(
            events,
            [
              Idling(),
              Idling(keywords: [Keyword('test')]),
            ],
          );
        });
      },
    );

    test(
      'should not move to Idle state with keywords if state has changed',
      () {
        fakeAsync((async) {
          usecase = MockedGetPhotosByResultUseCase();
          getKeywordUseCase = MockedGetKeywordUseCase();
          when(getKeywordUseCase.getKeywords()).thenAnswer(
            (_) => Stream.fromIterable(
              [
                LoadingKeywords(),
                KeywordsLoaded([Keyword('test')]),
              ],
            ).delay(Duration(milliseconds: 200)),
          );

          when(usecase.getPhotos('batman', 1))
              .thenAnswer((_) => Stream.value(LoadingPhotos()));
          photoBloc = PhotoBloc(usecase, getKeywordUseCase);
          photoBloc.onKeywordChanged('batman');
          var events = <PhotoViewState>[];
          photoBloc.photoState.listen(events.add);
          async.elapse(Duration(milliseconds: 400));
          expect(
            events,
            [
              Idling(),
              Searching(),
            ],
          );
        });
      },
    );
  });

  group('about loading photos functionality', () {
    setUp(() {
      usecase = MockedGetPhotosByResultUseCase();
      getKeywordUseCase = MockedGetKeywordUseCase();
      when(getKeywordUseCase.getKeywords())
          .thenAnswer((_) => Stream.value(LoadingKeywords()));
      photoBloc = PhotoBloc(usecase, getKeywordUseCase);
    });

    tearDown(() {
      photoBloc.dispose();
    });

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
            .thenAnswer((_) => Stream.value(LoadingPhotos()));
        photoBloc.onKeywordChanged('batman');
        await photoBloc.photoState
            .expect(emitsInOrder([Idling(), Searching()]));
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
              LoadingPhotos(),
              PhotosLoaded(
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
            .thenAnswer((_) => Stream.value(LoadingPhotos()));
        photoBloc.onKeywordChanged('batman');

        final broadcastState = photoBloc.photoState.asBroadcastStream();

        await broadcastState.expect(emitsInOrder(
          [
            Idling(),
            Searching(),
            PhotosFetched('batman',
                [Photo(1, 'id', 'owner', 'secret', 'server', 'title')], true),
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
              LoadingPhotos(),
              PhotosLoaded(
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
              true,
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
              LoadingPhotos(),
              PhotosLoaded(
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
              LoadingPhotos(),
              PhotosLoaded(
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
              true,
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
              LoadingPhotos(),
              FailureLoadingPhotos(Exception()),
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
              LoadingPhotos(),
              FailureLoadingPhotos(Exception()),
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
              LoadingPhotos(),
              PhotosLoaded(
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
              true,
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
              LoadingPhotos(),
              PhotosLoaded(
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
            LoadingPhotos(),
            PhotosLoaded(
              PageOfPhotos(
                2,
                3,
                [Photo(2, 'id', 'owner', 'secret', 'server', 'title')],
              ),
            ),
          ]),
        );
        when(usecase.getPhotos('batman', 3))
            .thenAnswer((_) => Stream.value(LoadingPhotos()));
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
                true,
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
                false,
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
              LoadingPhotos(),
              PhotosLoaded(
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
            LoadingPhotos(),
            FailureLoadingPhotos(Exception()),
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
                true,
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
            .thenAnswer((_) => Stream.value(LoadingPhotos()));

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
