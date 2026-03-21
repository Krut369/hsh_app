import '../entities/complaint_model.dart';
import '../repositories/complain_repository.dart';

class GetComplaintsUseCase {
  final ComplainRepository repository;
  GetComplaintsUseCase(this.repository);

  Future<List<Complaint>> execute() async {
    return await repository.getComplaints();
  }
}
