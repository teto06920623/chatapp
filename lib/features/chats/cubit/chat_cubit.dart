import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  String getChatId(String uId1, String uId2) {
    if (uId1.compareTo(uId2) > 0) {
      return '${uId1}_$uId2';
    } else {
      return '${uId2}_$uId1';
    }
  }
}
