import 'package:flickr_viewer/common/model/keyword.dart';
import 'package:flickr_viewer/data/sources/keyword_data_sources.dart';

class KeywordCacheDataSourceImpl implements KeywordCacheDataSource {
  @override
  Stream<List<Keyword>> getPredefinedKeywords() {
    return Stream.value(
      const [
        Keyword(
          'Animals',
          subKeywords: [
            Keyword(
              'Pets',
              subKeywords: [
                Keyword('Guppy'),
                Keyword('Parrot'),
                Keyword('GoldFish'),
                Keyword('Dog'),
                Keyword('Cat')
              ],
            ),
            Keyword(
              'Wild animals',
              subKeywords: [
                Keyword('Tiger'),
                Keyword('Ant'),
                Keyword('Tetra'),
                Keyword('Peafowl'),
                Keyword('Mongoose')
              ],
            ),
            Keyword(
              'Domestic animals',
              subKeywords: [
                Keyword('Cow'),
                Keyword('Pig'),
                Keyword('Goat'),
                Keyword('Horse'),
              ],
            ),
          ],
        ),
        Keyword(
          'Food',
          subKeywords: [
            Keyword(
              'Fastfood',
              subKeywords: [
                Keyword('Cheeseburger'),
                Keyword('Hamburger'),
              ],
            ),
            Keyword(
              'Dessert',
              subKeywords: [
                Keyword('Chocolate'),
                Keyword('Cookie'),
                Keyword('Cake'),
                Keyword('Pie'),
              ],
            ),
          ],
        ),
        Keyword(
          'Vehicle',
          subKeywords: [
            Keyword(
              'Motorcycle',
              subKeywords: [
                Keyword('Harley Davidson'),
              ],
            ),
            Keyword(
              'Car',
              subKeywords: [
                Keyword('Lamborghini'),
                Keyword('Ferrari'),
                Keyword('Bugatti'),
                Keyword('BMW'),
                Keyword('Mercedes'),
              ],
            ),
          ],
        ),
        Keyword(
          'Movie',
          subKeywords: [
            Keyword(
              'Science fiction',
              subKeywords: [
                Keyword('Sunshine'),
                Keyword('Interstellar'),
                Keyword('The Moon'),
                Keyword('Oblivion'),
                Keyword('Star Trek'),
                Keyword('Star Wars'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
