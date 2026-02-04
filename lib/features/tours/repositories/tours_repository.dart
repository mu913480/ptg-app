import 'package:ptg/features/tours/models/tour_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ToursRepository {
  final SupabaseClient _supabaseClient;

  ToursRepository({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  Future<List<Tour>> getTours() async {
    final response = await _supabaseClient.from('tour').select();

    return (response as List).map((data) => Tour.fromJson(data)).toList();
  }
}
