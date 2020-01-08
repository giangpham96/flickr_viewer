import 'package:flickr_viewer/common/model/keyword.dart';
import 'package:flickr_viewer/domain/repositories/keyword_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class GetKeywordUseCase {
  Stream<GetKeywordResult> getKeywords();
}

abstract class GetKeywordResult {}

class LoadingKeywords extends GetKeywordResult {}

class FailureLoadingKeywords extends GetKeywordResult {
  final Exception error;

  FailureLoadingKeywords(this.error);
}

class KeywordsLoaded extends GetKeywordResult {
  final List<Keyword> keywords;

  KeywordsLoaded(this.keywords);
}

class GetKeywordUseCaseImpl implements GetKeywordUseCase {
  final KeywordRepository _keywordRepository;

  GetKeywordUseCaseImpl(this._keywordRepository);

  @override
  Stream<GetKeywordResult> getKeywords() {
    return _keywordRepository
        .getKeywords()
        .map<GetKeywordResult>((k) => KeywordsLoaded(k))
        .onErrorResume((e) => Stream.value(FailureLoadingKeywords(e)))
        .startWith(LoadingKeywords());
  }
}
