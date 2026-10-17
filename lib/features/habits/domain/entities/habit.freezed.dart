// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Habit {
  String get id;
  String get name;
  String get description;
  int get points;
  List<String> get completedDates;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HabitCopyWith<Habit> get copyWith =>
      _$HabitCopyWithImpl<Habit>(this as Habit, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as Habit;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Habit &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.name, _this.name) || other.name == _this.name) &&
            (identical(other.description, _this.description) ||
                other.description == _this.description) &&
            (identical(other.points, _this.points) ||
                other.points == _this.points) &&
            const DeepCollectionEquality()
                .equals(other.completedDates, _this.completedDates));
  }

  @override
  int get hashCode {
    final _this = this as Habit;
    return Object.hash(
        runtimeType,
        _this.id,
        _this.name,
        _this.description,
        _this.points,
        const DeepCollectionEquality().hash(_this.completedDates));
  }

  @override
  String toString() {
    final _this = this as Habit;
    return 'Habit(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, points: ${_this.points}, completedDates: ${_this.completedDates})';
  }
}

/// @nodoc
abstract mixin class $HabitCopyWith<$Res> {
  factory $HabitCopyWith(Habit value, $Res Function(Habit) _then) =
      _$HabitCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int points,
      List<String> completedDates});
}

/// @nodoc
class _$HabitCopyWithImpl<$Res> implements $HabitCopyWith<$Res> {
  _$HabitCopyWithImpl(this._self, this._then);

  final Habit _self;
  final $Res Function(Habit) _then;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? points = null,
    Object? completedDates = null,
  }) {
    return _then(Habit(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      completedDates: null == completedDates
          ? _self.completedDates
          : completedDates // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [Habit].
extension HabitPatterns on Habit {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Habit value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Habit() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Habit value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Habit():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Habit value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Habit() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String name, String description, int points,
            List<String> completedDates)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Habit() when $default != null:
        return $default(_that.id, _that.name, _that.description, _that.points,
            _that.completedDates);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String name, String description, int points,
            List<String> completedDates)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Habit():
        return $default(_that.id, _that.name, _that.description, _that.points,
            _that.completedDates);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String name, String description, int points,
            List<String> completedDates)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Habit() when $default != null:
        return $default(_that.id, _that.name, _that.description, _that.points,
            _that.completedDates);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Habit extends Habit {
  const _Habit(
      {required this.id,
      required this.name,
      required this.description,
      required this.points,
      List<String> completedDates = const []})
      : _completedDates = completedDates,
        super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int points;
  final List<String> _completedDates;
  @override
  @JsonKey()
  List<String> get completedDates {
    if (_completedDates is EqualUnmodifiableListView) return _completedDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedDates);
  }

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HabitCopyWith<_Habit> get copyWith =>
      __$HabitCopyWithImpl<_Habit>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Habit &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.points, points) || other.points == points) &&
            const DeepCollectionEquality()
                .equals(other.completedDates, _completedDates));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, name, description, points,
        const DeepCollectionEquality().hash(_completedDates));
  }

  @override
  String toString() {
    return 'Habit(id: $id, name: $name, description: $description, points: $points, completedDates: $completedDates)';
  }
}

/// @nodoc
abstract mixin class _$HabitCopyWith<$Res> implements $HabitCopyWith<$Res> {
  factory _$HabitCopyWith(_Habit value, $Res Function(_Habit) _then) =
      __$HabitCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int points,
      List<String> completedDates});
}

/// @nodoc
class __$HabitCopyWithImpl<$Res> implements _$HabitCopyWith<$Res> {
  __$HabitCopyWithImpl(this._self, this._then);

  final _Habit _self;
  final $Res Function(_Habit) _then;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? points = null,
    Object? completedDates = null,
  }) {
    return _then(_Habit(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      completedDates: null == completedDates
          ? _self._completedDates
          : completedDates // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
