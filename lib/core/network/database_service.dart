import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ptg/core/utils/extensions/exception_extension.dart';
import 'package:ptg/core/network/network_checker.dart';

/// Type definition for query filter functions.
///
/// This allows flexible filtering using Supabase query builder methods.
///
/// **Example:**
/// ```dart
/// QueryFilter filter = (query) => query
///   .eq('city_id', 1)
///   .gte('visitors', 100);
/// ```
typedef QueryFilter =
    PostgrestFilterBuilder Function(PostgrestFilterBuilder query);

/// A service class that provides generic database operations for Supabase.
///
/// This service offers type-safe methods for inserting records into any table
/// with comprehensive error handling and callback support.
///
/// **Network Checking:**
/// All methods automatically check for internet connectivity before making API calls.
/// If no connection is available, a [NoInternetException] is thrown.
class DatabaseService {
  final SupabaseClient _supabase;
  final NetworkChecker _networkChecker;

  /// Creates a [DatabaseService] instance.
  ///
  /// If [supabaseClient] is not provided, it defaults to [Supabase.instance.client].
  /// If [networkChecker] is not provided, it defaults to [NetworkChecker()].
  DatabaseService({
    SupabaseClient? supabaseClient,
    NetworkChecker? networkChecker,
  }) : _supabase = supabaseClient ?? Supabase.instance.client,
       _networkChecker = networkChecker ?? NetworkChecker();

  /// Adds a single record to the specified table.
  ///
  /// **Type Parameters:**
  /// - [T]: The type of the data object being inserted
  ///
  /// **Parameters:**
  /// - [tableName]: The name of the database table to insert into
  /// - [data]: The object to insert
  /// - [toJson]: Function to convert the object to a JSON map
  /// - [onLoading]: Optional callback invoked when the operation starts
  /// - [onError]: Optional callback invoked with error message if operation fails
  /// - [onSuccess]: Optional callback invoked with the inserted record on success
  /// - [returnRecord]: If true, fetches and returns the inserted record (default: false)
  /// - [onValidate]: Optional validation callback, return error message if invalid, null if valid
  ///
  /// **Returns:**
  /// - The inserted record if [returnRecord] is true, otherwise null
  ///
  /// **Example:**
  /// ```dart
  /// final service = DatabaseService();
  /// final tour = Tour(title: 'My Tour', cityId: 1, ...);
  ///
  /// await service.addRecord<Tour>(
  ///   tableName: 'tour',
  ///   data: tour,
  ///   toJson: (t) => t.toJson(),
  ///   onLoading: () => print('Saving...'),
  ///   onSuccess: (record) => print('Saved: $record'),
  ///   onError: (error) => print('Error: $error'),
  ///   returnRecord: true,
  /// );
  /// ```
  Future<T?> addRecord<T>({
    required String tableName,
    required T data,
    required Map<String, dynamic> Function(T) toJson,
    void Function()? onLoading,
    void Function(String error)? onError,
    void Function(T? record)? onSuccess,
    bool returnRecord = false,
    String? Function(T data)? onValidate,
  }) async {
    try {
      // Check network connectivity before proceeding
      await _networkChecker.checkConnectivity();

      // Call loading callback
      onLoading?.call();

      // Validate data if validator is provided
      if (onValidate != null) {
        final validationError = onValidate(data);
        if (validationError != null) {
          onError?.call(validationError);
          return null;
        }
      }

      // Convert data to JSON
      final jsonData = toJson(data);

      // Insert into database
      if (returnRecord) {
        // Insert and return the record
        final response = await _supabase
            .from(tableName)
            .insert(jsonData)
            .select()
            .single();

        onSuccess?.call(response as T?);
        return response as T?;
      } else {
        // Insert without returning
        await _supabase.from(tableName).insert(jsonData);
        onSuccess?.call(null);
        return null;
      }
    } on Exception catch (e) {
      final errorMessage = e.exceptionToString();
      onError?.call(errorMessage);
      return null;
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      onError?.call(errorMessage);
      return null;
    }
  }

  /// Adds multiple records to the specified table in a single operation.
  ///
  /// **Type Parameters:**
  /// - [T]: The type of the data objects being inserted
  ///
  /// **Parameters:**
  /// - [tableName]: The name of the database table to insert into
  /// - [dataList]: List of objects to insert
  /// - [toJson]: Function to convert each object to a JSON map
  /// - [onLoading]: Optional callback invoked when the operation starts
  /// - [onError]: Optional callback invoked with error message if operation fails
  /// - [onSuccess]: Optional callback invoked with the list of inserted records on success
  /// - [returnRecords]: If true, fetches and returns the inserted records (default: false)
  /// - [onValidate]: Optional validation callback for each item
  ///
  /// **Returns:**
  /// - List of inserted records if [returnRecords] is true, otherwise null
  ///
  /// **Example:**
  /// ```dart
  /// final service = DatabaseService();
  /// final tours = [tour1, tour2, tour3];
  ///
  /// await service.addRecords<Tour>(
  ///   tableName: 'tour',
  ///   dataList: tours,
  ///   toJson: (t) => t.toJson(),
  ///   onLoading: () => print('Saving multiple tours...'),
  ///   onSuccess: (records) => print('Saved ${records?.length} tours'),
  ///   onError: (error) => print('Error: $error'),
  /// );
  /// ```
  Future<List<T>?> addRecords<T>({
    required String tableName,
    required List<T> dataList,
    required Map<String, dynamic> Function(T) toJson,
    void Function()? onLoading,
    void Function(String error)? onError,
    void Function(List<T>? records)? onSuccess,
    bool returnRecords = false,
    String? Function(T data)? onValidate,
  }) async {
    try {
      // Check network connectivity before proceeding
      await _networkChecker.checkConnectivity();

      // Call loading callback
      onLoading?.call();

      // Validate all items if validator is provided
      if (onValidate != null) {
        for (int i = 0; i < dataList.length; i++) {
          final validationError = onValidate(dataList[i]);
          if (validationError != null) {
            onError?.call('Item ${i + 1}: $validationError');
            return null;
          }
        }
      }

      // Convert all data to JSON
      final jsonDataList = dataList.map((item) => toJson(item)).toList();

      // Insert into database
      if (returnRecords) {
        // Insert and return the records
        final response = await _supabase
            .from(tableName)
            .insert(jsonDataList)
            .select();

        final records = (response as List).cast<T>();
        onSuccess?.call(records);
        return records;
      } else {
        // Insert without returning
        await _supabase.from(tableName).insert(jsonDataList);
        onSuccess?.call(null);
        return null;
      }
    } on Exception catch (e) {
      final errorMessage = e.exceptionToString();
      onError?.call(errorMessage);
      return null;
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      onError?.call(errorMessage);
      return null;
    }
  }

  /// Adds a record with automatic retry logic on network failures.
  ///
  /// **Type Parameters:**
  /// - [T]: The type of the data object being inserted
  ///
  /// **Parameters:**
  /// - [tableName]: The name of the database table to insert into
  /// - [data]: The object to insert
  /// - [toJson]: Function to convert the object to a JSON map
  /// - [onLoading]: Optional callback invoked when the operation starts
  /// - [onError]: Optional callback invoked with error message if operation fails
  /// - [onSuccess]: Optional callback invoked with the inserted record on success
  /// - [returnRecord]: If true, fetches and returns the inserted record (default: false)
  /// - [maxRetries]: Maximum number of retry attempts (default: 3)
  /// - [retryDelay]: Delay between retry attempts in milliseconds (default: 1000)
  /// - [onValidate]: Optional validation callback
  ///
  /// **Returns:**
  /// - The inserted record if [returnRecord] is true, otherwise null
  ///
  /// **Example:**
  /// ```dart
  /// final service = DatabaseService();
  /// final tour = Tour(title: 'My Tour', cityId: 1, ...);
  ///
  /// await service.addRecordWithRetry<Tour>(
  ///   tableName: 'tour',
  ///   data: tour,
  ///   toJson: (t) => t.toJson(),
  ///   maxRetries: 5,
  ///   retryDelay: 2000,
  ///   onError: (error) => print('Error: $error'),
  /// );
  /// ```
  Future<T?> addRecordWithRetry<T>({
    required String tableName,
    required T data,
    required Map<String, dynamic> Function(T) toJson,
    void Function()? onLoading,
    void Function(String error)? onError,
    void Function(T? record)? onSuccess,
    bool returnRecord = false,
    int maxRetries = 3,
    int retryDelay = 1000,
    String? Function(T data)? onValidate,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      attempts++;

      try {
        // Check network connectivity before each attempt
        await _networkChecker.checkConnectivity();

        // Call loading callback on first attempt
        if (attempts == 1) {
          onLoading?.call();
        }

        // Validate data if validator is provided
        if (onValidate != null) {
          final validationError = onValidate(data);
          if (validationError != null) {
            onError?.call(validationError);
            return null;
          }
        }

        // Convert data to JSON
        final jsonData = toJson(data);

        // Insert into database
        if (returnRecord) {
          final response = await _supabase
              .from(tableName)
              .insert(jsonData)
              .select()
              .single();

          onSuccess?.call(response as T?);
          return response as T?;
        } else {
          await _supabase.from(tableName).insert(jsonData);
          onSuccess?.call(null);
          return null;
        }
      } on Exception catch (e) {
        // Check if it's a network-related error that should be retried
        final errorMessage = e.exceptionToString();
        final isNetworkError =
            errorMessage.contains('network') ||
            errorMessage.contains('connection') ||
            errorMessage.contains('timeout') ||
            errorMessage.contains('Socket');

        if (isNetworkError && attempts < maxRetries) {
          // Wait before retrying
          await Future.delayed(Duration(milliseconds: retryDelay));
          continue;
        } else {
          // Non-network error or max retries reached
          onError?.call(
            attempts >= maxRetries
                ? 'Failed after $maxRetries attempts: $errorMessage'
                : errorMessage,
          );
          return null;
        }
      } catch (e) {
        final errorMessage = 'An unexpected error occurred: ${e.toString()}';
        onError?.call(errorMessage);
        return null;
      }
    }

    return null;
  }

  /// Fetches a single record from the specified table.
  ///
  /// **Type Parameters:**
  /// - [T]: The type of the data object to retrieve
  ///
  /// **Parameters:**
  /// - [tableName]: The name of the database table to query
  /// - [fromJson]: Function to convert JSON map to object
  /// - [id]: Optional ID to fetch a specific record
  /// - [filter]: Optional custom filter function for complex queries
  /// - [onLoading]: Optional callback invoked when the operation starts
  /// - [onError]: Optional callback invoked with error message if operation fails
  /// - [onSuccess]: Optional callback invoked with the fetched record on success
  /// - [select]: Optional custom columns and joins (e.g., '*, join_table(column)')
  ///
  /// **Returns:**
  /// - The fetched record if found, otherwise null
  ///
  /// **Note:** Either [id] or [filter] should be provided, not both.
  /// If both are provided, [id] takes precedence.
  ///
  /// **Example:**
  /// ```dart
  /// // Get by ID
  /// final tour = await service.getRecord<Tour>(
  ///   tableName: 'tour',
  ///   fromJson: (json) => Tour.fromJson(json),
  ///   id: 'tour-id-123',
  ///   onSuccess: (tour) => print('Found: ${tour?.title}'),
  /// );
  ///
  ///   filter: (query) => query.eq('city_id', 1).limit(1),
  /// );
  ///
  /// // Get with joins
  /// final tour = await service.getRecord<Tour>(
  ///   tableName: 'tour',
  ///   fromJson: (json) => Tour.fromJson(json),
  ///   select: '*, tour_images(image_url), city(name, state(name))',
  ///   id: 'tour-id-123',
  /// );
  /// ```
  Future<T?> getRecord<T>({
    required String tableName,
    required T Function(Map<String, dynamic>) fromJson,
    String? id,
    QueryFilter? filter,
    void Function()? onLoading,
    void Function(String error)? onError,
    void Function(T? record)? onSuccess,
    String select = '*',
  }) async {
    try {
      // Check network connectivity before proceeding
      await _networkChecker.checkConnectivity();

      // Call loading callback
      onLoading?.call();

      // Build query
      dynamic query = _supabase.from(tableName).select(select);

      // Apply ID filter or custom filter
      if (id != null) {
        query = query.eq('id', id);
      } else if (filter != null) {
        query = filter(query);
      }

      // Execute query and get single result
      final response = await query.maybeSingle();

      if (response == null) {
        onSuccess?.call(null);
        return null;
      }

      // Convert to object
      final record = fromJson(response);
      onSuccess?.call(record);
      return record;
    } on Exception catch (e) {
      final errorMessage = e.exceptionToString();
      onError?.call(errorMessage);
      return null;
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      onError?.call(errorMessage);
      return null;
    }
  }

  /// Fetches multiple records from the specified table.
  ///
  /// **Type Parameters:**
  /// - [T]: The type of the data objects to retrieve
  ///
  /// **Parameters:**
  /// - [tableName]: The name of the database table to query
  /// - [fromJson]: Function to convert JSON map to object
  /// - [filter]: Optional custom filter function (eq, gt, lt, in, etc.)
  /// - [orderBy]: Optional column name to sort by
  /// - [ascending]: Sort direction (default: true)
  /// - [limit]: Maximum number of records to fetch
  /// - [offset]: Number of records to skip (for pagination)
  /// - [onLoading]: Optional callback invoked when the operation starts
  /// - [onError]: Optional callback invoked with error message if operation fails
  /// - [onSuccess]: Optional callback invoked with the list of fetched records on success
  /// - [select]: Optional custom columns and joins (e.g., '*, join_table(column)')
  ///
  /// **Returns:**
  /// - List of fetched records (empty list if none found)
  ///
  /// **Example:**
  /// ```dart
  /// // Get all tours for a city, sorted by title
  /// final tours = await service.getRecords<Tour>(
  ///   tableName: 'tour',
  ///   fromJson: (json) => Tour.fromJson(json),
  ///   filter: (query) => query.eq('city_id', 1),
  ///   orderBy: 'title',
  ///   ascending: true,
  ///   limit: 10,
  /// );
  ///
  /// // Get all cities with pagination
  /// final cities = await service.getRecords<City>(
  ///   tableName: 'city',
  ///   fromJson: (json) => City.fromJson(json),
  ///   orderBy: 'name',
  ///   limit: 20,
  ///   offset: 0,
  /// );
  ///
  ///   orderBy: 'visitors',
  ///   ascending: false,
  /// );
  ///
  /// // Get all tours with complex joins
  /// final tours = await service.getRecords<Tour>(
  ///   tableName: 'tour',
  ///   fromJson: (json) => Tour.fromJson(json),
  ///   select: '*, tour_images(image_url), city(name, state(name)), stop(count)',
  /// );
  /// ```
  Future<List<T>> getRecords<T>({
    required String tableName,
    required T Function(Map<String, dynamic>) fromJson,
    QueryFilter? filter,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
    void Function()? onLoading,
    void Function(String error)? onError,
    void Function(List<T> records)? onSuccess,
    String select = '*',
  }) async {
    try {
      // Check network connectivity before proceeding
      await _networkChecker.checkConnectivity();

      // Call loading callback
      onLoading?.call();

      // Build query
      dynamic query = _supabase.from(tableName).select(select);

      // Apply custom filter if provided
      if (filter != null) {
        query = filter(query);
      }

      // Apply ordering if provided
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      // Apply limit if provided
      if (limit != null) {
        query = query.limit(limit);
      }

      // Apply offset if provided
      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 1000) - 1);
      }

      // Execute query
      final response = await query;

      // Convert to list of objects
      final records = (response as List)
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();

      onSuccess?.call(records);
      return records;
    } on Exception catch (e) {
      final errorMessage = e.exceptionToString();
      onError?.call(errorMessage);
      return [];
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      onError?.call(errorMessage);
      return [];
    }
  }

  /// Deletes a record from the specified table.
  ///
  /// **Parameters:**
  /// - [tableName]: The name of the database table to delete from
  /// - [id]: Optional ID of the record to delete
  /// - [filter]: Optional custom filter function for complex queries
  /// - [onLoading]: Optional callback invoked when the operation starts
  /// - [onError]: Optional callback invoked with error message if operation fails
  /// - [onSuccess]: Optional callback invoked on successful deletion
  ///
  /// **Note:** Either [id] or [filter] should be provided, not both.
  /// If both are provided, [id] takes precedence.
  ///
  /// **Example:**
  /// ```dart
  /// // Delete by ID
  /// await service.deleteRecord(
  ///   tableName: 'tour_images',
  ///   id: 123,
  ///   onSuccess: () => print('Deleted successfully'),
  /// );
  ///
  /// // Delete with custom filter
  /// await service.deleteRecord(
  ///   tableName: 'tour_images',
  ///   filter: (query) => query.eq('image_url', imageUrl),
  /// );
  /// ```
  Future<bool> deleteRecord({
    required String tableName,
    dynamic id,
    QueryFilter? filter,
    void Function()? onLoading,
    void Function(String error)? onError,
    void Function()? onSuccess,
  }) async {
    try {
      // Check network connectivity before proceeding
      await _networkChecker.checkConnectivity();

      // Call loading callback
      onLoading?.call();

      // Build query
      dynamic query = _supabase.from(tableName).delete();

      // Apply ID filter or custom filter
      if (id != null) {
        query = query.eq('id', id);
      } else if (filter != null) {
        query = filter(query);
      } else {
        throw Exception('Either id or filter must be provided');
      }

      // Execute delete
      await query;

      onSuccess?.call();
      return true;
    } on Exception catch (e) {
      final errorMessage = e.exceptionToString();
      onError?.call(errorMessage);
      return false;
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      onError?.call(errorMessage);
      return false;
    }
  }

  /// Updates a record in the specified table.
  Future<T?> updateRecord<T>({
    required String tableName,
    required T data,
    required Map<String, dynamic> Function(T) toJson,
    required String id,
    void Function()? onLoading,
    void Function(String error)? onError,
    void Function(T? record)? onSuccess,
    bool returnRecord = false,
    String? Function(T data)? onValidate,
  }) async {
    try {
      // Check network connectivity before proceeding
      await _networkChecker.checkConnectivity();

      // Call loading callback
      onLoading?.call();

      // Validate data if validator is provided
      if (onValidate != null) {
        final validationError = onValidate(data);
        if (validationError != null) {
          onError?.call(validationError);
          return null;
        }
      }

      // Convert data to JSON
      final jsonData = toJson(data);

      // Remove ID from JSON if strictly required by Supabase update policies,
      // generally good practice to not update ID unless intentional.
      // But typically we update by ID matching.

      // Update in database
      if (returnRecord) {
        final response = await _supabase
            .from(tableName)
            .update(jsonData)
            .eq('id', id)
            .select()
            .single();

        onSuccess?.call(response as T?);
        return response as T?;
      } else {
        await _supabase.from(tableName).update(jsonData).eq('id', id);
        onSuccess?.call(null);
        return null;
      }
    } on Exception catch (e) {
      final errorMessage = e.exceptionToString();
      onError?.call(errorMessage);
      return null;
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      onError?.call(errorMessage);
      return null;
    }
  }
}
