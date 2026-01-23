---
description: Rules and best practices for using DatabaseService for Supabase operations
---

# Database Service Usage Workflow

This workflow defines the rules and patterns for interacting with Supabase using the reusable `DatabaseService`.

## Core Rules

1. **Always Use DatabaseService**: Where possible, use the reusable methods in `lib/network/database_service.dart` instead of direct Supabase client calls.
2. **Network Checking**: All methods in `DatabaseService` already include `NetworkChecker` logic. Ensure you handle potential exceptions thrown by these methods.
3. **Type Safety**: Use generic type parameters `<T>` with `fromJson` and `toJson` for type-safe database operations.

## Reusable Methods

### 1. Fetching Records
- **Single Record**: Use `getRecord<T>(tableName: ..., fromJson: ..., id: ...)` for fetching by ID or `filter` for complex queries.
- **Multiple Records**: Use `getRecords<T>(tableName: ..., fromJson: ..., filter: ..., orderBy: ..., limit: ...)` for list views and search.
- **Custom Select**: Both methods support a `select` parameter for joins and selective column fetching (e.g., `select: '*, related_table(*)'`).

### 2. Creating Records
- **Single Record**: Use `addRecord<T>(tableName: ..., data: ..., toJson: ...)` for basic inserts.
- **Multiple Records**: Use `addRecords<T>(tableName: ..., dataList: ..., toJson: ...)` for batch inserts.
- **With Retry**: Use `addRecordWithRetry<T>(...)` for critical operations that might fail due to transient network issues.

### 3. Deleting Records
- **Delete**: Use `deleteRecord(tableName: ..., id: ...)` or provide a `filter`.

## Common Patterns

### Query Filtering
Use the `QueryFilter` typedef for modular filtering:
```dart
QueryFilter filter = (query) => query
  .eq('status', 'active')
  .order('created_at', ascending: false);
```

### Loading and Error Handling
Leverage the built-in callbacks:
```dart
await _databaseService.getRecords<Tour>(
  tableName: 'tour',
  fromJson: (json) => Tour.fromJson(json),
  onLoading: () => emit(StateLoading()),
  onError: (error) => emit(StateError(error)),
  onSuccess: (records) => emit(StateLoaded(records)),
);
```
## Backend (Supabase)

- Database tables are accessed via `DatabaseService`
- File uploads go to Supabase Storage
- Check network connectivity before API calls

### Supabase MCP Server
**IMPORTANT**: When performing any database/Supabase related operations (querying, schema changes, migrations, etc.), always use the Supabase MCP server with:
- **Project ID**: `lyhhgfoinekhndfkxbqj`

Use MCP tools like:
- `mcp_supabase-mcp-server_execute_sql` - For running queries
- `mcp_supabase-mcp-server_apply_migration` - For DDL operations
- `mcp_supabase-mcp-server_list_tables` - To view database schema
- `mcp_supabase-mcp-server_generate_typescript_types` - For type generation