import '../actions/actions.dart';

String reducer(String state, dynamic action) {
  if (action is SetCurrentHotel) {
    return action.hotel;
  } else {
    return state;
  }
}
