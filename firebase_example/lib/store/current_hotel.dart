import 'package:redux/redux.dart';

import '../reducers/reducers.dart';

final Store<String> store = Store(reducer, initialState: '');
