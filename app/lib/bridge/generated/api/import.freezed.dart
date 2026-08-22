// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImportEvent {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportEvent&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'ImportEvent(field0: $field0)';
}


}

/// @nodoc
class $ImportEventCopyWith<$Res>  {
$ImportEventCopyWith(ImportEvent _, $Res Function(ImportEvent) __);
}


/// Adds pattern-matching-related methods to [ImportEvent].
extension ImportEventPatterns on ImportEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ImportEvent_Progress value)?  progress,TResult Function( ImportEvent_Chunk value)?  chunk,TResult Function( ImportEvent_Finished value)?  finished,TResult Function( ImportEvent_Failed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ImportEvent_Progress() when progress != null:
return progress(_that);case ImportEvent_Chunk() when chunk != null:
return chunk(_that);case ImportEvent_Finished() when finished != null:
return finished(_that);case ImportEvent_Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ImportEvent_Progress value)  progress,required TResult Function( ImportEvent_Chunk value)  chunk,required TResult Function( ImportEvent_Finished value)  finished,required TResult Function( ImportEvent_Failed value)  failed,}){
final _that = this;
switch (_that) {
case ImportEvent_Progress():
return progress(_that);case ImportEvent_Chunk():
return chunk(_that);case ImportEvent_Finished():
return finished(_that);case ImportEvent_Failed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ImportEvent_Progress value)?  progress,TResult? Function( ImportEvent_Chunk value)?  chunk,TResult? Function( ImportEvent_Finished value)?  finished,TResult? Function( ImportEvent_Failed value)?  failed,}){
final _that = this;
switch (_that) {
case ImportEvent_Progress() when progress != null:
return progress(_that);case ImportEvent_Chunk() when chunk != null:
return chunk(_that);case ImportEvent_Finished() when finished != null:
return finished(_that);case ImportEvent_Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ImportProgress field0)?  progress,TResult Function( ImportChunk field0)?  chunk,TResult Function( ImportSummaryOutput field0)?  finished,TResult Function( ImportErrorKind field0)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ImportEvent_Progress() when progress != null:
return progress(_that.field0);case ImportEvent_Chunk() when chunk != null:
return chunk(_that.field0);case ImportEvent_Finished() when finished != null:
return finished(_that.field0);case ImportEvent_Failed() when failed != null:
return failed(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ImportProgress field0)  progress,required TResult Function( ImportChunk field0)  chunk,required TResult Function( ImportSummaryOutput field0)  finished,required TResult Function( ImportErrorKind field0)  failed,}) {final _that = this;
switch (_that) {
case ImportEvent_Progress():
return progress(_that.field0);case ImportEvent_Chunk():
return chunk(_that.field0);case ImportEvent_Finished():
return finished(_that.field0);case ImportEvent_Failed():
return failed(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ImportProgress field0)?  progress,TResult? Function( ImportChunk field0)?  chunk,TResult? Function( ImportSummaryOutput field0)?  finished,TResult? Function( ImportErrorKind field0)?  failed,}) {final _that = this;
switch (_that) {
case ImportEvent_Progress() when progress != null:
return progress(_that.field0);case ImportEvent_Chunk() when chunk != null:
return chunk(_that.field0);case ImportEvent_Finished() when finished != null:
return finished(_that.field0);case ImportEvent_Failed() when failed != null:
return failed(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ImportEvent_Progress extends ImportEvent {
  const ImportEvent_Progress(this.field0): super._();
  

@override final  ImportProgress field0;

/// Create a copy of ImportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportEvent_ProgressCopyWith<ImportEvent_Progress> get copyWith => _$ImportEvent_ProgressCopyWithImpl<ImportEvent_Progress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportEvent_Progress&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ImportEvent.progress(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ImportEvent_ProgressCopyWith<$Res> implements $ImportEventCopyWith<$Res> {
  factory $ImportEvent_ProgressCopyWith(ImportEvent_Progress value, $Res Function(ImportEvent_Progress) _then) = _$ImportEvent_ProgressCopyWithImpl;
@useResult
$Res call({
 ImportProgress field0
});




}
/// @nodoc
class _$ImportEvent_ProgressCopyWithImpl<$Res>
    implements $ImportEvent_ProgressCopyWith<$Res> {
  _$ImportEvent_ProgressCopyWithImpl(this._self, this._then);

  final ImportEvent_Progress _self;
  final $Res Function(ImportEvent_Progress) _then;

/// Create a copy of ImportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ImportEvent_Progress(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as ImportProgress,
  ));
}


}

/// @nodoc


class ImportEvent_Chunk extends ImportEvent {
  const ImportEvent_Chunk(this.field0): super._();
  

@override final  ImportChunk field0;

/// Create a copy of ImportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportEvent_ChunkCopyWith<ImportEvent_Chunk> get copyWith => _$ImportEvent_ChunkCopyWithImpl<ImportEvent_Chunk>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportEvent_Chunk&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ImportEvent.chunk(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ImportEvent_ChunkCopyWith<$Res> implements $ImportEventCopyWith<$Res> {
  factory $ImportEvent_ChunkCopyWith(ImportEvent_Chunk value, $Res Function(ImportEvent_Chunk) _then) = _$ImportEvent_ChunkCopyWithImpl;
@useResult
$Res call({
 ImportChunk field0
});




}
/// @nodoc
class _$ImportEvent_ChunkCopyWithImpl<$Res>
    implements $ImportEvent_ChunkCopyWith<$Res> {
  _$ImportEvent_ChunkCopyWithImpl(this._self, this._then);

  final ImportEvent_Chunk _self;
  final $Res Function(ImportEvent_Chunk) _then;

/// Create a copy of ImportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ImportEvent_Chunk(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as ImportChunk,
  ));
}


}

/// @nodoc


class ImportEvent_Finished extends ImportEvent {
  const ImportEvent_Finished(this.field0): super._();
  

@override final  ImportSummaryOutput field0;

/// Create a copy of ImportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportEvent_FinishedCopyWith<ImportEvent_Finished> get copyWith => _$ImportEvent_FinishedCopyWithImpl<ImportEvent_Finished>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportEvent_Finished&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ImportEvent.finished(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ImportEvent_FinishedCopyWith<$Res> implements $ImportEventCopyWith<$Res> {
  factory $ImportEvent_FinishedCopyWith(ImportEvent_Finished value, $Res Function(ImportEvent_Finished) _then) = _$ImportEvent_FinishedCopyWithImpl;
@useResult
$Res call({
 ImportSummaryOutput field0
});




}
/// @nodoc
class _$ImportEvent_FinishedCopyWithImpl<$Res>
    implements $ImportEvent_FinishedCopyWith<$Res> {
  _$ImportEvent_FinishedCopyWithImpl(this._self, this._then);

  final ImportEvent_Finished _self;
  final $Res Function(ImportEvent_Finished) _then;

/// Create a copy of ImportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ImportEvent_Finished(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as ImportSummaryOutput,
  ));
}


}

/// @nodoc


class ImportEvent_Failed extends ImportEvent {
  const ImportEvent_Failed(this.field0): super._();
  

@override final  ImportErrorKind field0;

/// Create a copy of ImportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportEvent_FailedCopyWith<ImportEvent_Failed> get copyWith => _$ImportEvent_FailedCopyWithImpl<ImportEvent_Failed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportEvent_Failed&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ImportEvent.failed(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ImportEvent_FailedCopyWith<$Res> implements $ImportEventCopyWith<$Res> {
  factory $ImportEvent_FailedCopyWith(ImportEvent_Failed value, $Res Function(ImportEvent_Failed) _then) = _$ImportEvent_FailedCopyWithImpl;
@useResult
$Res call({
 ImportErrorKind field0
});




}
/// @nodoc
class _$ImportEvent_FailedCopyWithImpl<$Res>
    implements $ImportEvent_FailedCopyWith<$Res> {
  _$ImportEvent_FailedCopyWithImpl(this._self, this._then);

  final ImportEvent_Failed _self;
  final $Res Function(ImportEvent_Failed) _then;

/// Create a copy of ImportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ImportEvent_Failed(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as ImportErrorKind,
  ));
}


}

// dart format on
