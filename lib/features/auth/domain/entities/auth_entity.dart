import 'package:equatable/equatable.dart';
import 'package:lost_and_found_mobile/features/batch/domain/entities/batch_entity.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String? batchId;
  final String username;
  final String? password;
  final BatchEntity? batch;
  final String? phoneNumber;
  final String? profiePicture;

  const AuthEntity({
    this.authId,
    this.batchId,
    required this.fullName,
    required this.email,
    required this.username,
    this.password,
    this.phoneNumber,
    this.profiePicture, 
    this.batch,
  });

  @override
  List<Object?> get props => [
    authId,
    batchId,
    fullName,
    email,
    username,
    password,
    phoneNumber,
    profiePicture,
  ];
}
