import 'package:http/http.dart' as http;
import 'package:tooflix_nomader/models/webtoon_detail_model.dart';
import 'package:tooflix_nomader/models/webtoon_episode_model.dart';
import 'dart:convert';
import 'package:tooflix_nomader/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  // API에서 오늘의 웹툰을 가져오는 메서드
  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');

    try {
      final response = await http.get(url);

      // 상태 코드가 200인 경우에만 JSON 처리
      if (response.statusCode == 200) {
        final List<dynamic> webtoons = jsonDecode(response.body);
        for (var webtoon in webtoons) {
          webtoonInstances.add(WebtoonModel.fromJson(webtoon));
        }
        return webtoonInstances;
      } else {
        // 상태 코드가 200이 아닐 때 예외 처리
        throw Exception('Failed to load webtoons: ${response.statusCode}');
      }
    } catch (e) {
      // 에러 핸들링 및 디버깅을 위한 로그 출력
      print('Error fetching webtoons: $e');
      throw Exception('Error fetching webtoons');
    }
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
