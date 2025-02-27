import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetNews extends UseCase<List<NewsItem>, GetNewsParams> {
  final NewsRepository newsRepository;

  GetNews(this.newsRepository);

  @override
  Future<Either<Failure, List<NewsItem>>> call(GetNewsParams params) async {
    return await newsRepository.getNews(
        params.offset, params.limit, params.tag ?? 'все');
  }
}

class GetNewsParams extends Equatable {
  final int offset;
  final int limit;
  final String? tag;

  GetNewsParams({required this.offset, required this.limit, this.tag});

  @override
  List<Object?> get props => [offset, limit, tag];
}
