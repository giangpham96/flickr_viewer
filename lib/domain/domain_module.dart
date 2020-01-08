import 'package:get_it/get_it.dart';

import 'get_photos_by_keyword_use_case.dart';

domainModule() {
  GetIt.instance.registerFactory<GetPhotosByKeywordUseCase>(
    () => GetPhotosByKeywordUseCaseImpl(GetIt.instance.get()),
  );
}
