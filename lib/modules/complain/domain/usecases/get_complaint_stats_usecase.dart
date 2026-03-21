import '../entities/complaint_stats_model.dart';
import '../repositories/complain_repository.dart';

class GetComplaintStatsUseCase {
  final ComplainRepository repository;
  GetComplaintStatsUseCase(this.repository);

  Future<ComplaintStats> execute() async {
    return await repository.getComplaintStats();
  }
}
