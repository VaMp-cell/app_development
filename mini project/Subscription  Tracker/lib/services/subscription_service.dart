import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subscription_model.dart';
import 'auth_service.dart';   // <-- needed to get current user

class SubscriptionService {
  final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection('subscriptions');

  /// Add a new subscription
  Future<void> addSubscription(SubscriptionModel sub) async {
    final user = await AuthService().getUserData();
    if (user == null) return;

    final docRef = await subsCollection.add({
      ...sub.toMap(),
      'userId': user['uid'],   // store userId to separate subscriptions
    });

    // Update document to include its own ID
    await docRef.update({'id': docRef.id});
  }

  /// Get all subscriptions of the logged-in user as a stream
 Stream<List<SubscriptionModel>> getSubscriptions() async* {
  final user = await AuthService().getUserData();
  if (user == null || user['uid'] == null) {
    yield [];
    return;
  }

  yield* subsCollection
      .where("userId", isEqualTo: user['uid'])
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => SubscriptionModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList());
}


  /// Delete a subscription
  Future<void> deleteSubscription(String id) async {
    await subsCollection.doc(id).delete();
  }

  /// Update a subscription (Edit feature)
  Future<void> updateSubscription(SubscriptionModel sub) async {
    await subsCollection.doc(sub.id).update({
      'name': sub.name,
      'price': sub.price,
      'date': sub.date,
      'category': sub.category,
    });
  }

  /// ⭐ Count total subscriptions of the logged-in user
  Future<int> getSubscriptionCount() async {
    final user = await AuthService().getUserData();
    if (user == null) return 0;

    final querySnapshot =
        await subsCollection.where('userId', isEqualTo: user['uid']).get();

    return querySnapshot.docs.length;
  }
}
