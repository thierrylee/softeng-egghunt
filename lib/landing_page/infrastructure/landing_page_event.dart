part of 'landing_page_bloc.dart';

sealed class LandingPageEvent extends Equatable {}

class LandingPageInitEvent extends LandingPageEvent {
  @override
  List<Object?> get props => [];
}
