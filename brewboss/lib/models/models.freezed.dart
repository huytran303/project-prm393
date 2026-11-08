// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get id; String get name; String get email; String get phone; UserRole get role; bool get isActive; List<String> get fcmTokens;@TimestampConverter() DateTime? get createdAt;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&const DeepCollectionEquality().equals(other.fcmTokens, _this.fcmTokens)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppUser;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.phone,_this.role,_this.isActive,const DeepCollectionEquality().hash(_this.fcmTokens),_this.createdAt);
}

@override
String toString() {
  final _this = this as AppUser;
  return 'AppUser(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone}, role: ${_this.role}, isActive: ${_this.isActive}, fcmTokens: ${_this.fcmTokens}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String phone, UserRole role, bool isActive, List<String> fcmTokens,@TimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = null,Object? role = null,Object? isActive = null,Object? fcmTokens = null,Object? createdAt = freezed,}) {
  return _then(AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,fcmTokens: null == fcmTokens ? _self.fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String phone,  UserRole role,  bool isActive,  List<String> fcmTokens, @TimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.role,_that.isActive,_that.fcmTokens,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String phone,  UserRole role,  bool isActive,  List<String> fcmTokens, @TimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.role,_that.isActive,_that.fcmTokens,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String phone,  UserRole role,  bool isActive,  List<String> fcmTokens, @TimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.role,_that.isActive,_that.fcmTokens,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser implements AppUser {
  const _AppUser({required this.id, required this.name, required this.email, this.phone = '', required this.role, this.isActive = true,  List<String> fcmTokens = const [], @TimestampConverter() this.createdAt}): _fcmTokens = fcmTokens;
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override@JsonKey() final  String phone;
@override final  UserRole role;
@override@JsonKey() final  bool isActive;
 final  List<String> _fcmTokens;
@override@JsonKey() List<String> get fcmTokens {
  if (_fcmTokens is EqualUnmodifiableListView) return _fcmTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fcmTokens);
}

@override@TimestampConverter() final  DateTime? createdAt;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.fcmTokens, _fcmTokens)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,phone,role,isActive,const DeepCollectionEquality().hash(_fcmTokens),createdAt);
}

@override
String toString() {
    return 'AppUser(id: $id, name: $name, email: $email, phone: $phone, role: $role, isActive: $isActive, fcmTokens: $fcmTokens, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String phone, UserRole role, bool isActive, List<String> fcmTokens,@TimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = null,Object? role = null,Object? isActive = null,Object? fcmTokens = null,Object? createdAt = freezed,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,fcmTokens: null == fcmTokens ? _self._fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Shift {

 String get id; String get userId; String get userName; UserRole get userRole;@TimestampConverter() DateTime? get checkIn;@TimestampConverter() DateTime? get checkOut; int? get openingCash; int? get closingCash; int? get expectedCash; int? get cashDiff; int get cashSales; int get qrSales; String? get lastPaidOrderId; String? get handoverNote;
/// Create a copy of Shift
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftCopyWith<Shift> get copyWith => _$ShiftCopyWithImpl<Shift>(this as Shift, _$identity);

  /// Serializes this Shift to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Shift;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shift&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.userRole, _this.userRole) || other.userRole == _this.userRole)&&(identical(other.checkIn, _this.checkIn) || other.checkIn == _this.checkIn)&&(identical(other.checkOut, _this.checkOut) || other.checkOut == _this.checkOut)&&(identical(other.openingCash, _this.openingCash) || other.openingCash == _this.openingCash)&&(identical(other.closingCash, _this.closingCash) || other.closingCash == _this.closingCash)&&(identical(other.expectedCash, _this.expectedCash) || other.expectedCash == _this.expectedCash)&&(identical(other.cashDiff, _this.cashDiff) || other.cashDiff == _this.cashDiff)&&(identical(other.cashSales, _this.cashSales) || other.cashSales == _this.cashSales)&&(identical(other.qrSales, _this.qrSales) || other.qrSales == _this.qrSales)&&(identical(other.lastPaidOrderId, _this.lastPaidOrderId) || other.lastPaidOrderId == _this.lastPaidOrderId)&&(identical(other.handoverNote, _this.handoverNote) || other.handoverNote == _this.handoverNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Shift;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.userName,_this.userRole,_this.checkIn,_this.checkOut,_this.openingCash,_this.closingCash,_this.expectedCash,_this.cashDiff,_this.cashSales,_this.qrSales,_this.lastPaidOrderId,_this.handoverNote);
}

@override
String toString() {
  final _this = this as Shift;
  return 'Shift(id: ${_this.id}, userId: ${_this.userId}, userName: ${_this.userName}, userRole: ${_this.userRole}, checkIn: ${_this.checkIn}, checkOut: ${_this.checkOut}, openingCash: ${_this.openingCash}, closingCash: ${_this.closingCash}, expectedCash: ${_this.expectedCash}, cashDiff: ${_this.cashDiff}, cashSales: ${_this.cashSales}, qrSales: ${_this.qrSales}, lastPaidOrderId: ${_this.lastPaidOrderId}, handoverNote: ${_this.handoverNote})';
}


}

/// @nodoc
abstract mixin class $ShiftCopyWith<$Res>  {
  factory $ShiftCopyWith(Shift value, $Res Function(Shift) _then) = _$ShiftCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String userName, UserRole userRole,@TimestampConverter() DateTime? checkIn,@TimestampConverter() DateTime? checkOut, int? openingCash, int? closingCash, int? expectedCash, int? cashDiff, int cashSales, int qrSales, String? lastPaidOrderId, String? handoverNote
});




}
/// @nodoc
class _$ShiftCopyWithImpl<$Res>
    implements $ShiftCopyWith<$Res> {
  _$ShiftCopyWithImpl(this._self, this._then);

  final Shift _self;
  final $Res Function(Shift) _then;

/// Create a copy of Shift
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? userRole = null,Object? checkIn = freezed,Object? checkOut = freezed,Object? openingCash = freezed,Object? closingCash = freezed,Object? expectedCash = freezed,Object? cashDiff = freezed,Object? cashSales = null,Object? qrSales = null,Object? lastPaidOrderId = freezed,Object? handoverNote = freezed,}) {
  return _then(Shift(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as UserRole,checkIn: freezed == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOut: freezed == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as DateTime?,openingCash: freezed == openingCash ? _self.openingCash : openingCash // ignore: cast_nullable_to_non_nullable
as int?,closingCash: freezed == closingCash ? _self.closingCash : closingCash // ignore: cast_nullable_to_non_nullable
as int?,expectedCash: freezed == expectedCash ? _self.expectedCash : expectedCash // ignore: cast_nullable_to_non_nullable
as int?,cashDiff: freezed == cashDiff ? _self.cashDiff : cashDiff // ignore: cast_nullable_to_non_nullable
as int?,cashSales: null == cashSales ? _self.cashSales : cashSales // ignore: cast_nullable_to_non_nullable
as int,qrSales: null == qrSales ? _self.qrSales : qrSales // ignore: cast_nullable_to_non_nullable
as int,lastPaidOrderId: freezed == lastPaidOrderId ? _self.lastPaidOrderId : lastPaidOrderId // ignore: cast_nullable_to_non_nullable
as String?,handoverNote: freezed == handoverNote ? _self.handoverNote : handoverNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Shift].
extension ShiftPatterns on Shift {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shift value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shift() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shift value)  $default,){
final _that = this;
switch (_that) {
case _Shift():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shift value)?  $default,){
final _that = this;
switch (_that) {
case _Shift() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  UserRole userRole, @TimestampConverter()  DateTime? checkIn, @TimestampConverter()  DateTime? checkOut,  int? openingCash,  int? closingCash,  int? expectedCash,  int? cashDiff,  int cashSales,  int qrSales,  String? lastPaidOrderId,  String? handoverNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shift() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.userRole,_that.checkIn,_that.checkOut,_that.openingCash,_that.closingCash,_that.expectedCash,_that.cashDiff,_that.cashSales,_that.qrSales,_that.lastPaidOrderId,_that.handoverNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  UserRole userRole, @TimestampConverter()  DateTime? checkIn, @TimestampConverter()  DateTime? checkOut,  int? openingCash,  int? closingCash,  int? expectedCash,  int? cashDiff,  int cashSales,  int qrSales,  String? lastPaidOrderId,  String? handoverNote)  $default,) {final _that = this;
switch (_that) {
case _Shift():
return $default(_that.id,_that.userId,_that.userName,_that.userRole,_that.checkIn,_that.checkOut,_that.openingCash,_that.closingCash,_that.expectedCash,_that.cashDiff,_that.cashSales,_that.qrSales,_that.lastPaidOrderId,_that.handoverNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String userName,  UserRole userRole, @TimestampConverter()  DateTime? checkIn, @TimestampConverter()  DateTime? checkOut,  int? openingCash,  int? closingCash,  int? expectedCash,  int? cashDiff,  int cashSales,  int qrSales,  String? lastPaidOrderId,  String? handoverNote)?  $default,) {final _that = this;
switch (_that) {
case _Shift() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.userRole,_that.checkIn,_that.checkOut,_that.openingCash,_that.closingCash,_that.expectedCash,_that.cashDiff,_that.cashSales,_that.qrSales,_that.lastPaidOrderId,_that.handoverNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Shift implements Shift {
  const _Shift({required this.id, required this.userId, this.userName = '', this.userRole = UserRole.cashier, @TimestampConverter() this.checkIn, @TimestampConverter() this.checkOut, this.openingCash, this.closingCash, this.expectedCash, this.cashDiff, this.cashSales = 0, this.qrSales = 0, this.lastPaidOrderId, this.handoverNote});
  factory _Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);

@override final  String id;
@override final  String userId;
@override@JsonKey() final  String userName;
@override@JsonKey() final  UserRole userRole;
@override@TimestampConverter() final  DateTime? checkIn;
@override@TimestampConverter() final  DateTime? checkOut;
@override final  int? openingCash;
@override final  int? closingCash;
@override final  int? expectedCash;
@override final  int? cashDiff;
@override@JsonKey() final  int cashSales;
@override@JsonKey() final  int qrSales;
@override final  String? lastPaidOrderId;
@override final  String? handoverNote;

/// Create a copy of Shift
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftCopyWith<_Shift> get copyWith => __$ShiftCopyWithImpl<_Shift>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShiftToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shift&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.openingCash, openingCash) || other.openingCash == openingCash)&&(identical(other.closingCash, closingCash) || other.closingCash == closingCash)&&(identical(other.expectedCash, expectedCash) || other.expectedCash == expectedCash)&&(identical(other.cashDiff, cashDiff) || other.cashDiff == cashDiff)&&(identical(other.cashSales, cashSales) || other.cashSales == cashSales)&&(identical(other.qrSales, qrSales) || other.qrSales == qrSales)&&(identical(other.lastPaidOrderId, lastPaidOrderId) || other.lastPaidOrderId == lastPaidOrderId)&&(identical(other.handoverNote, handoverNote) || other.handoverNote == handoverNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,userName,userRole,checkIn,checkOut,openingCash,closingCash,expectedCash,cashDiff,cashSales,qrSales,lastPaidOrderId,handoverNote);
}

@override
String toString() {
    return 'Shift(id: $id, userId: $userId, userName: $userName, userRole: $userRole, checkIn: $checkIn, checkOut: $checkOut, openingCash: $openingCash, closingCash: $closingCash, expectedCash: $expectedCash, cashDiff: $cashDiff, cashSales: $cashSales, qrSales: $qrSales, lastPaidOrderId: $lastPaidOrderId, handoverNote: $handoverNote)';
}


}

/// @nodoc
abstract mixin class _$ShiftCopyWith<$Res> implements $ShiftCopyWith<$Res> {
  factory _$ShiftCopyWith(_Shift value, $Res Function(_Shift) _then) = __$ShiftCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String userName, UserRole userRole,@TimestampConverter() DateTime? checkIn,@TimestampConverter() DateTime? checkOut, int? openingCash, int? closingCash, int? expectedCash, int? cashDiff, int cashSales, int qrSales, String? lastPaidOrderId, String? handoverNote
});




}
/// @nodoc
class __$ShiftCopyWithImpl<$Res>
    implements _$ShiftCopyWith<$Res> {
  __$ShiftCopyWithImpl(this._self, this._then);

  final _Shift _self;
  final $Res Function(_Shift) _then;

/// Create a copy of Shift
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? userRole = null,Object? checkIn = freezed,Object? checkOut = freezed,Object? openingCash = freezed,Object? closingCash = freezed,Object? expectedCash = freezed,Object? cashDiff = freezed,Object? cashSales = null,Object? qrSales = null,Object? lastPaidOrderId = freezed,Object? handoverNote = freezed,}) {
  return _then(_Shift(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as UserRole,checkIn: freezed == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOut: freezed == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as DateTime?,openingCash: freezed == openingCash ? _self.openingCash : openingCash // ignore: cast_nullable_to_non_nullable
as int?,closingCash: freezed == closingCash ? _self.closingCash : closingCash // ignore: cast_nullable_to_non_nullable
as int?,expectedCash: freezed == expectedCash ? _self.expectedCash : expectedCash // ignore: cast_nullable_to_non_nullable
as int?,cashDiff: freezed == cashDiff ? _self.cashDiff : cashDiff // ignore: cast_nullable_to_non_nullable
as int?,cashSales: null == cashSales ? _self.cashSales : cashSales // ignore: cast_nullable_to_non_nullable
as int,qrSales: null == qrSales ? _self.qrSales : qrSales // ignore: cast_nullable_to_non_nullable
as int,lastPaidOrderId: freezed == lastPaidOrderId ? _self.lastPaidOrderId : lastPaidOrderId // ignore: cast_nullable_to_non_nullable
as String?,handoverNote: freezed == handoverNote ? _self.handoverNote : handoverNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Category {

 String get id; String get name; int get sortOrder;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Category;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Category;
  return Object.hash(runtimeType,_this.id,_this.name,_this.sortOrder);
}

@override
String toString() {
  final _this = this as Category;
  return 'Category(id: ${_this.id}, name: ${_this.name}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, int sortOrder
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? sortOrder = null,}) {
  return _then(Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.id,_that.name,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Category implements Category {
  const _Category({required this.id, required this.name, this.sortOrder = 0});
  factory _Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  int sortOrder;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,sortOrder);
}

@override
String toString() {
    return 'Category(id: $id, name: $name, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int sortOrder
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? sortOrder = null,}) {
  return _then(_Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProductSize {

 String get code; int get priceDelta;
/// Create a copy of ProductSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSizeCopyWith<ProductSize> get copyWith => _$ProductSizeCopyWithImpl<ProductSize>(this as ProductSize, _$identity);

  /// Serializes this ProductSize to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProductSize;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSize&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.priceDelta, _this.priceDelta) || other.priceDelta == _this.priceDelta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProductSize;
  return Object.hash(runtimeType,_this.code,_this.priceDelta);
}

@override
String toString() {
  final _this = this as ProductSize;
  return 'ProductSize(code: ${_this.code}, priceDelta: ${_this.priceDelta})';
}


}

/// @nodoc
abstract mixin class $ProductSizeCopyWith<$Res>  {
  factory $ProductSizeCopyWith(ProductSize value, $Res Function(ProductSize) _then) = _$ProductSizeCopyWithImpl;
@useResult
$Res call({
 String code, int priceDelta
});




}
/// @nodoc
class _$ProductSizeCopyWithImpl<$Res>
    implements $ProductSizeCopyWith<$Res> {
  _$ProductSizeCopyWithImpl(this._self, this._then);

  final ProductSize _self;
  final $Res Function(ProductSize) _then;

/// Create a copy of ProductSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? priceDelta = null,}) {
  return _then(ProductSize(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,priceDelta: null == priceDelta ? _self.priceDelta : priceDelta // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSize].
extension ProductSizePatterns on ProductSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSize() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSize value)  $default,){
final _that = this;
switch (_that) {
case _ProductSize():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSize value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSize() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int priceDelta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSize() when $default != null:
return $default(_that.code,_that.priceDelta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int priceDelta)  $default,) {final _that = this;
switch (_that) {
case _ProductSize():
return $default(_that.code,_that.priceDelta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int priceDelta)?  $default,) {final _that = this;
switch (_that) {
case _ProductSize() when $default != null:
return $default(_that.code,_that.priceDelta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductSize implements ProductSize {
  const _ProductSize({required this.code, this.priceDelta = 0});
  factory _ProductSize.fromJson(Map<String, dynamic> json) => _$ProductSizeFromJson(json);

@override final  String code;
@override@JsonKey() final  int priceDelta;

/// Create a copy of ProductSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSizeCopyWith<_ProductSize> get copyWith => __$ProductSizeCopyWithImpl<_ProductSize>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSizeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSize&&(identical(other.code, code) || other.code == code)&&(identical(other.priceDelta, priceDelta) || other.priceDelta == priceDelta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,priceDelta);
}

@override
String toString() {
    return 'ProductSize(code: $code, priceDelta: $priceDelta)';
}


}

/// @nodoc
abstract mixin class _$ProductSizeCopyWith<$Res> implements $ProductSizeCopyWith<$Res> {
  factory _$ProductSizeCopyWith(_ProductSize value, $Res Function(_ProductSize) _then) = __$ProductSizeCopyWithImpl;
@override @useResult
$Res call({
 String code, int priceDelta
});




}
/// @nodoc
class __$ProductSizeCopyWithImpl<$Res>
    implements _$ProductSizeCopyWith<$Res> {
  __$ProductSizeCopyWithImpl(this._self, this._then);

  final _ProductSize _self;
  final $Res Function(_ProductSize) _then;

/// Create a copy of ProductSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? priceDelta = null,}) {
  return _then(_ProductSize(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,priceDelta: null == priceDelta ? _self.priceDelta : priceDelta // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Topping {

 String get id; String get name; int get price;
/// Create a copy of Topping
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToppingCopyWith<Topping> get copyWith => _$ToppingCopyWithImpl<Topping>(this as Topping, _$identity);

  /// Serializes this Topping to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Topping;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Topping&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.price, _this.price) || other.price == _this.price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Topping;
  return Object.hash(runtimeType,_this.id,_this.name,_this.price);
}

@override
String toString() {
  final _this = this as Topping;
  return 'Topping(id: ${_this.id}, name: ${_this.name}, price: ${_this.price})';
}


}

/// @nodoc
abstract mixin class $ToppingCopyWith<$Res>  {
  factory $ToppingCopyWith(Topping value, $Res Function(Topping) _then) = _$ToppingCopyWithImpl;
@useResult
$Res call({
 String id, String name, int price
});




}
/// @nodoc
class _$ToppingCopyWithImpl<$Res>
    implements $ToppingCopyWith<$Res> {
  _$ToppingCopyWithImpl(this._self, this._then);

  final Topping _self;
  final $Res Function(Topping) _then;

/// Create a copy of Topping
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,}) {
  return _then(Topping(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Topping].
extension ToppingPatterns on Topping {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Topping value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Topping() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Topping value)  $default,){
final _that = this;
switch (_that) {
case _Topping():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Topping value)?  $default,){
final _that = this;
switch (_that) {
case _Topping() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Topping() when $default != null:
return $default(_that.id,_that.name,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int price)  $default,) {final _that = this;
switch (_that) {
case _Topping():
return $default(_that.id,_that.name,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int price)?  $default,) {final _that = this;
switch (_that) {
case _Topping() when $default != null:
return $default(_that.id,_that.name,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Topping implements Topping {
  const _Topping({required this.id, required this.name, this.price = 0});
  factory _Topping.fromJson(Map<String, dynamic> json) => _$ToppingFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  int price;

/// Create a copy of Topping
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToppingCopyWith<_Topping> get copyWith => __$ToppingCopyWithImpl<_Topping>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ToppingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Topping&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,price);
}

@override
String toString() {
    return 'Topping(id: $id, name: $name, price: $price)';
}


}

/// @nodoc
abstract mixin class _$ToppingCopyWith<$Res> implements $ToppingCopyWith<$Res> {
  factory _$ToppingCopyWith(_Topping value, $Res Function(_Topping) _then) = __$ToppingCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int price
});




}
/// @nodoc
class __$ToppingCopyWithImpl<$Res>
    implements _$ToppingCopyWith<$Res> {
  __$ToppingCopyWithImpl(this._self, this._then);

  final _Topping _self;
  final $Res Function(_Topping) _then;

/// Create a copy of Topping
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,}) {
  return _then(_Topping(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RecipeItem {

 String get ingredientId; num get qty;
/// Create a copy of RecipeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeItemCopyWith<RecipeItem> get copyWith => _$RecipeItemCopyWithImpl<RecipeItem>(this as RecipeItem, _$identity);

  /// Serializes this RecipeItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecipeItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeItem&&(identical(other.ingredientId, _this.ingredientId) || other.ingredientId == _this.ingredientId)&&(identical(other.qty, _this.qty) || other.qty == _this.qty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecipeItem;
  return Object.hash(runtimeType,_this.ingredientId,_this.qty);
}

@override
String toString() {
  final _this = this as RecipeItem;
  return 'RecipeItem(ingredientId: ${_this.ingredientId}, qty: ${_this.qty})';
}


}

/// @nodoc
abstract mixin class $RecipeItemCopyWith<$Res>  {
  factory $RecipeItemCopyWith(RecipeItem value, $Res Function(RecipeItem) _then) = _$RecipeItemCopyWithImpl;
@useResult
$Res call({
 String ingredientId, num qty
});




}
/// @nodoc
class _$RecipeItemCopyWithImpl<$Res>
    implements $RecipeItemCopyWith<$Res> {
  _$RecipeItemCopyWithImpl(this._self, this._then);

  final RecipeItem _self;
  final $Res Function(RecipeItem) _then;

/// Create a copy of RecipeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ingredientId = null,Object? qty = null,}) {
  return _then(RecipeItem(
ingredientId: null == ingredientId ? _self.ingredientId : ingredientId // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeItem].
extension RecipeItemPatterns on RecipeItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeItem value)  $default,){
final _that = this;
switch (_that) {
case _RecipeItem():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeItem value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ingredientId,  num qty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeItem() when $default != null:
return $default(_that.ingredientId,_that.qty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ingredientId,  num qty)  $default,) {final _that = this;
switch (_that) {
case _RecipeItem():
return $default(_that.ingredientId,_that.qty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ingredientId,  num qty)?  $default,) {final _that = this;
switch (_that) {
case _RecipeItem() when $default != null:
return $default(_that.ingredientId,_that.qty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeItem implements RecipeItem {
  const _RecipeItem({required this.ingredientId, required this.qty});
  factory _RecipeItem.fromJson(Map<String, dynamic> json) => _$RecipeItemFromJson(json);

@override final  String ingredientId;
@override final  num qty;

/// Create a copy of RecipeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeItemCopyWith<_RecipeItem> get copyWith => __$RecipeItemCopyWithImpl<_RecipeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeItem&&(identical(other.ingredientId, ingredientId) || other.ingredientId == ingredientId)&&(identical(other.qty, qty) || other.qty == qty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ingredientId,qty);
}

@override
String toString() {
    return 'RecipeItem(ingredientId: $ingredientId, qty: $qty)';
}


}

/// @nodoc
abstract mixin class _$RecipeItemCopyWith<$Res> implements $RecipeItemCopyWith<$Res> {
  factory _$RecipeItemCopyWith(_RecipeItem value, $Res Function(_RecipeItem) _then) = __$RecipeItemCopyWithImpl;
@override @useResult
$Res call({
 String ingredientId, num qty
});




}
/// @nodoc
class __$RecipeItemCopyWithImpl<$Res>
    implements _$RecipeItemCopyWith<$Res> {
  __$RecipeItemCopyWithImpl(this._self, this._then);

  final _RecipeItem _self;
  final $Res Function(_RecipeItem) _then;

/// Create a copy of RecipeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ingredientId = null,Object? qty = null,}) {
  return _then(_RecipeItem(
ingredientId: null == ingredientId ? _self.ingredientId : ingredientId // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}


/// @nodoc
mixin _$Product {

 String get id; String get categoryId; String get name; String get description; int get basePrice; String? get imageUrl; bool get isAvailable; List<ProductSize> get sizes; List<Topping> get toppings; Map<String, List<RecipeItem>> get recipe;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Product;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.basePrice, _this.basePrice) || other.basePrice == _this.basePrice)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable)&&const DeepCollectionEquality().equals(other.sizes, _this.sizes)&&const DeepCollectionEquality().equals(other.toppings, _this.toppings)&&const DeepCollectionEquality().equals(other.recipe, _this.recipe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Product;
  return Object.hash(runtimeType,_this.id,_this.categoryId,_this.name,_this.description,_this.basePrice,_this.imageUrl,_this.isAvailable,const DeepCollectionEquality().hash(_this.sizes),const DeepCollectionEquality().hash(_this.toppings),const DeepCollectionEquality().hash(_this.recipe));
}

@override
String toString() {
  final _this = this as Product;
  return 'Product(id: ${_this.id}, categoryId: ${_this.categoryId}, name: ${_this.name}, description: ${_this.description}, basePrice: ${_this.basePrice}, imageUrl: ${_this.imageUrl}, isAvailable: ${_this.isAvailable}, sizes: ${_this.sizes}, toppings: ${_this.toppings}, recipe: ${_this.recipe})';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String name, String description, int basePrice, String? imageUrl, bool isAvailable, List<ProductSize> sizes, List<Topping> toppings, Map<String, List<RecipeItem>> recipe
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? name = null,Object? description = null,Object? basePrice = null,Object? imageUrl = freezed,Object? isAvailable = null,Object? sizes = null,Object? toppings = null,Object? recipe = null,}) {
  return _then(Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,sizes: null == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<ProductSize>,toppings: null == toppings ? _self.toppings : toppings // ignore: cast_nullable_to_non_nullable
as List<Topping>,recipe: null == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as Map<String, List<RecipeItem>>,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String name,  String description,  int basePrice,  String? imageUrl,  bool isAvailable,  List<ProductSize> sizes,  List<Topping> toppings,  Map<String, List<RecipeItem>> recipe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.basePrice,_that.imageUrl,_that.isAvailable,_that.sizes,_that.toppings,_that.recipe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String name,  String description,  int basePrice,  String? imageUrl,  bool isAvailable,  List<ProductSize> sizes,  List<Topping> toppings,  Map<String, List<RecipeItem>> recipe)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.basePrice,_that.imageUrl,_that.isAvailable,_that.sizes,_that.toppings,_that.recipe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String name,  String description,  int basePrice,  String? imageUrl,  bool isAvailable,  List<ProductSize> sizes,  List<Topping> toppings,  Map<String, List<RecipeItem>> recipe)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.basePrice,_that.imageUrl,_that.isAvailable,_that.sizes,_that.toppings,_that.recipe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product extends Product {
  const _Product({required this.id, required this.categoryId, required this.name, this.description = '', this.basePrice = 0, this.imageUrl, this.isAvailable = true,  List<ProductSize> sizes = const [],  List<Topping> toppings = const [],  Map<String, List<RecipeItem>> recipe = const {}}): _sizes = sizes,_toppings = toppings,_recipe = recipe,super._();
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String categoryId;
@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  int basePrice;
@override final  String? imageUrl;
@override@JsonKey() final  bool isAvailable;
 final  List<ProductSize> _sizes;
@override@JsonKey() List<ProductSize> get sizes {
  if (_sizes is EqualUnmodifiableListView) return _sizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizes);
}

 final  List<Topping> _toppings;
@override@JsonKey() List<Topping> get toppings {
  if (_toppings is EqualUnmodifiableListView) return _toppings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toppings);
}

 final  Map<String, List<RecipeItem>> _recipe;
@override@JsonKey() Map<String, List<RecipeItem>> get recipe {
  if (_recipe is EqualUnmodifiableMapView) return _recipe;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_recipe);
}


/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&const DeepCollectionEquality().equals(other.sizes, _sizes)&&const DeepCollectionEquality().equals(other.toppings, _toppings)&&const DeepCollectionEquality().equals(other.recipe, _recipe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,categoryId,name,description,basePrice,imageUrl,isAvailable,const DeepCollectionEquality().hash(_sizes),const DeepCollectionEquality().hash(_toppings),const DeepCollectionEquality().hash(_recipe));
}

@override
String toString() {
    return 'Product(id: $id, categoryId: $categoryId, name: $name, description: $description, basePrice: $basePrice, imageUrl: $imageUrl, isAvailable: $isAvailable, sizes: $sizes, toppings: $toppings, recipe: $recipe)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String name, String description, int basePrice, String? imageUrl, bool isAvailable, List<ProductSize> sizes, List<Topping> toppings, Map<String, List<RecipeItem>> recipe
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? name = null,Object? description = null,Object? basePrice = null,Object? imageUrl = freezed,Object? isAvailable = null,Object? sizes = null,Object? toppings = null,Object? recipe = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,sizes: null == sizes ? _self._sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<ProductSize>,toppings: null == toppings ? _self._toppings : toppings // ignore: cast_nullable_to_non_nullable
as List<Topping>,recipe: null == recipe ? _self._recipe : recipe // ignore: cast_nullable_to_non_nullable
as Map<String, List<RecipeItem>>,
  ));
}


}


/// @nodoc
mixin _$Ingredient {

 String get id; String get name; String get unit; num get stock; num get minStock;
/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientCopyWith<Ingredient> get copyWith => _$IngredientCopyWithImpl<Ingredient>(this as Ingredient, _$identity);

  /// Serializes this Ingredient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Ingredient;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ingredient&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.stock, _this.stock) || other.stock == _this.stock)&&(identical(other.minStock, _this.minStock) || other.minStock == _this.minStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Ingredient;
  return Object.hash(runtimeType,_this.id,_this.name,_this.unit,_this.stock,_this.minStock);
}

@override
String toString() {
  final _this = this as Ingredient;
  return 'Ingredient(id: ${_this.id}, name: ${_this.name}, unit: ${_this.unit}, stock: ${_this.stock}, minStock: ${_this.minStock})';
}


}

/// @nodoc
abstract mixin class $IngredientCopyWith<$Res>  {
  factory $IngredientCopyWith(Ingredient value, $Res Function(Ingredient) _then) = _$IngredientCopyWithImpl;
@useResult
$Res call({
 String id, String name, String unit, num stock, num minStock
});




}
/// @nodoc
class _$IngredientCopyWithImpl<$Res>
    implements $IngredientCopyWith<$Res> {
  _$IngredientCopyWithImpl(this._self, this._then);

  final Ingredient _self;
  final $Res Function(Ingredient) _then;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? unit = null,Object? stock = null,Object? minStock = null,}) {
  return _then(Ingredient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as num,minStock: null == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [Ingredient].
extension IngredientPatterns on Ingredient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ingredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ingredient value)  $default,){
final _that = this;
switch (_that) {
case _Ingredient():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ingredient value)?  $default,){
final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String unit,  num stock,  num minStock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
return $default(_that.id,_that.name,_that.unit,_that.stock,_that.minStock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String unit,  num stock,  num minStock)  $default,) {final _that = this;
switch (_that) {
case _Ingredient():
return $default(_that.id,_that.name,_that.unit,_that.stock,_that.minStock);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String unit,  num stock,  num minStock)?  $default,) {final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
return $default(_that.id,_that.name,_that.unit,_that.stock,_that.minStock);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ingredient implements Ingredient {
  const _Ingredient({required this.id, required this.name, required this.unit, this.stock = 0, this.minStock = 0});
  factory _Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);

@override final  String id;
@override final  String name;
@override final  String unit;
@override@JsonKey() final  num stock;
@override@JsonKey() final  num minStock;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientCopyWith<_Ingredient> get copyWith => __$IngredientCopyWithImpl<_Ingredient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IngredientToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ingredient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.minStock, minStock) || other.minStock == minStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,unit,stock,minStock);
}

@override
String toString() {
    return 'Ingredient(id: $id, name: $name, unit: $unit, stock: $stock, minStock: $minStock)';
}


}

/// @nodoc
abstract mixin class _$IngredientCopyWith<$Res> implements $IngredientCopyWith<$Res> {
  factory _$IngredientCopyWith(_Ingredient value, $Res Function(_Ingredient) _then) = __$IngredientCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String unit, num stock, num minStock
});




}
/// @nodoc
class __$IngredientCopyWithImpl<$Res>
    implements _$IngredientCopyWith<$Res> {
  __$IngredientCopyWithImpl(this._self, this._then);

  final _Ingredient _self;
  final $Res Function(_Ingredient) _then;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? unit = null,Object? stock = null,Object? minStock = null,}) {
  return _then(_Ingredient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as num,minStock: null == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}


/// @nodoc
mixin _$StockMovement {

 String get id; MovementType get type; num get qty; String? get orderId; int? get cost; String? get reason; String get byUserId;@TimestampConverter() DateTime? get createdAt;
/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementCopyWith<StockMovement> get copyWith => _$StockMovementCopyWithImpl<StockMovement>(this as StockMovement, _$identity);

  /// Serializes this StockMovement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockMovement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.orderId, _this.orderId) || other.orderId == _this.orderId)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.byUserId, _this.byUserId) || other.byUserId == _this.byUserId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockMovement;
  return Object.hash(runtimeType,_this.id,_this.type,_this.qty,_this.orderId,_this.cost,_this.reason,_this.byUserId,_this.createdAt);
}

@override
String toString() {
  final _this = this as StockMovement;
  return 'StockMovement(id: ${_this.id}, type: ${_this.type}, qty: ${_this.qty}, orderId: ${_this.orderId}, cost: ${_this.cost}, reason: ${_this.reason}, byUserId: ${_this.byUserId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $StockMovementCopyWith<$Res>  {
  factory $StockMovementCopyWith(StockMovement value, $Res Function(StockMovement) _then) = _$StockMovementCopyWithImpl;
@useResult
$Res call({
 String id, MovementType type, num qty, String? orderId, int? cost, String? reason, String byUserId,@TimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class _$StockMovementCopyWithImpl<$Res>
    implements $StockMovementCopyWith<$Res> {
  _$StockMovementCopyWithImpl(this._self, this._then);

  final StockMovement _self;
  final $Res Function(StockMovement) _then;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? qty = null,Object? orderId = freezed,Object? cost = freezed,Object? reason = freezed,Object? byUserId = null,Object? createdAt = freezed,}) {
  return _then(StockMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MovementType,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as num,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as int?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,byUserId: null == byUserId ? _self.byUserId : byUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockMovement].
extension StockMovementPatterns on StockMovement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockMovement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockMovement value)  $default,){
final _that = this;
switch (_that) {
case _StockMovement():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockMovement value)?  $default,){
final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MovementType type,  num qty,  String? orderId,  int? cost,  String? reason,  String byUserId, @TimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that.id,_that.type,_that.qty,_that.orderId,_that.cost,_that.reason,_that.byUserId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MovementType type,  num qty,  String? orderId,  int? cost,  String? reason,  String byUserId, @TimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _StockMovement():
return $default(_that.id,_that.type,_that.qty,_that.orderId,_that.cost,_that.reason,_that.byUserId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MovementType type,  num qty,  String? orderId,  int? cost,  String? reason,  String byUserId, @TimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that.id,_that.type,_that.qty,_that.orderId,_that.cost,_that.reason,_that.byUserId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockMovement implements StockMovement {
  const _StockMovement({required this.id, required this.type, required this.qty, this.orderId, this.cost, this.reason, required this.byUserId, @TimestampConverter() this.createdAt});
  factory _StockMovement.fromJson(Map<String, dynamic> json) => _$StockMovementFromJson(json);

@override final  String id;
@override final  MovementType type;
@override final  num qty;
@override final  String? orderId;
@override final  int? cost;
@override final  String? reason;
@override final  String byUserId;
@override@TimestampConverter() final  DateTime? createdAt;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockMovementCopyWith<_StockMovement> get copyWith => __$StockMovementCopyWithImpl<_StockMovement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockMovementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.byUserId, byUserId) || other.byUserId == byUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,qty,orderId,cost,reason,byUserId,createdAt);
}

@override
String toString() {
    return 'StockMovement(id: $id, type: $type, qty: $qty, orderId: $orderId, cost: $cost, reason: $reason, byUserId: $byUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StockMovementCopyWith<$Res> implements $StockMovementCopyWith<$Res> {
  factory _$StockMovementCopyWith(_StockMovement value, $Res Function(_StockMovement) _then) = __$StockMovementCopyWithImpl;
@override @useResult
$Res call({
 String id, MovementType type, num qty, String? orderId, int? cost, String? reason, String byUserId,@TimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class __$StockMovementCopyWithImpl<$Res>
    implements _$StockMovementCopyWith<$Res> {
  __$StockMovementCopyWithImpl(this._self, this._then);

  final _StockMovement _self;
  final $Res Function(_StockMovement) _then;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? qty = null,Object? orderId = freezed,Object? cost = freezed,Object? reason = freezed,Object? byUserId = null,Object? createdAt = freezed,}) {
  return _then(_StockMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MovementType,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as num,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as int?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,byUserId: null == byUserId ? _self.byUserId : byUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CafeTable {

 String get id; String get name; String get area; int get capacity; String? get currentOrderId;
/// Create a copy of CafeTable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CafeTableCopyWith<CafeTable> get copyWith => _$CafeTableCopyWithImpl<CafeTable>(this as CafeTable, _$identity);

  /// Serializes this CafeTable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CafeTable;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CafeTable&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.currentOrderId, _this.currentOrderId) || other.currentOrderId == _this.currentOrderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CafeTable;
  return Object.hash(runtimeType,_this.id,_this.name,_this.area,_this.capacity,_this.currentOrderId);
}

@override
String toString() {
  final _this = this as CafeTable;
  return 'CafeTable(id: ${_this.id}, name: ${_this.name}, area: ${_this.area}, capacity: ${_this.capacity}, currentOrderId: ${_this.currentOrderId})';
}


}

/// @nodoc
abstract mixin class $CafeTableCopyWith<$Res>  {
  factory $CafeTableCopyWith(CafeTable value, $Res Function(CafeTable) _then) = _$CafeTableCopyWithImpl;
@useResult
$Res call({
 String id, String name, String area, int capacity, String? currentOrderId
});




}
/// @nodoc
class _$CafeTableCopyWithImpl<$Res>
    implements $CafeTableCopyWith<$Res> {
  _$CafeTableCopyWithImpl(this._self, this._then);

  final CafeTable _self;
  final $Res Function(CafeTable) _then;

/// Create a copy of CafeTable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? area = null,Object? capacity = null,Object? currentOrderId = freezed,}) {
  return _then(CafeTable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,currentOrderId: freezed == currentOrderId ? _self.currentOrderId : currentOrderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CafeTable].
extension CafeTablePatterns on CafeTable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CafeTable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CafeTable() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CafeTable value)  $default,){
final _that = this;
switch (_that) {
case _CafeTable():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CafeTable value)?  $default,){
final _that = this;
switch (_that) {
case _CafeTable() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String area,  int capacity,  String? currentOrderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CafeTable() when $default != null:
return $default(_that.id,_that.name,_that.area,_that.capacity,_that.currentOrderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String area,  int capacity,  String? currentOrderId)  $default,) {final _that = this;
switch (_that) {
case _CafeTable():
return $default(_that.id,_that.name,_that.area,_that.capacity,_that.currentOrderId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String area,  int capacity,  String? currentOrderId)?  $default,) {final _that = this;
switch (_that) {
case _CafeTable() when $default != null:
return $default(_that.id,_that.name,_that.area,_that.capacity,_that.currentOrderId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CafeTable implements CafeTable {
  const _CafeTable({required this.id, required this.name, required this.area, this.capacity = 2, this.currentOrderId});
  factory _CafeTable.fromJson(Map<String, dynamic> json) => _$CafeTableFromJson(json);

@override final  String id;
@override final  String name;
@override final  String area;
@override@JsonKey() final  int capacity;
@override final  String? currentOrderId;

/// Create a copy of CafeTable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CafeTableCopyWith<_CafeTable> get copyWith => __$CafeTableCopyWithImpl<_CafeTable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CafeTableToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CafeTable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.currentOrderId, currentOrderId) || other.currentOrderId == currentOrderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,area,capacity,currentOrderId);
}

@override
String toString() {
    return 'CafeTable(id: $id, name: $name, area: $area, capacity: $capacity, currentOrderId: $currentOrderId)';
}


}

/// @nodoc
abstract mixin class _$CafeTableCopyWith<$Res> implements $CafeTableCopyWith<$Res> {
  factory _$CafeTableCopyWith(_CafeTable value, $Res Function(_CafeTable) _then) = __$CafeTableCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String area, int capacity, String? currentOrderId
});




}
/// @nodoc
class __$CafeTableCopyWithImpl<$Res>
    implements _$CafeTableCopyWith<$Res> {
  __$CafeTableCopyWithImpl(this._self, this._then);

  final _CafeTable _self;
  final $Res Function(_CafeTable) _then;

/// Create a copy of CafeTable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? area = null,Object? capacity = null,Object? currentOrderId = freezed,}) {
  return _then(_CafeTable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,currentOrderId: freezed == currentOrderId ? _self.currentOrderId : currentOrderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ItemTopping {

 String get name; int get price;
/// Create a copy of ItemTopping
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemToppingCopyWith<ItemTopping> get copyWith => _$ItemToppingCopyWithImpl<ItemTopping>(this as ItemTopping, _$identity);

  /// Serializes this ItemTopping to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ItemTopping;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemTopping&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.price, _this.price) || other.price == _this.price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ItemTopping;
  return Object.hash(runtimeType,_this.name,_this.price);
}

@override
String toString() {
  final _this = this as ItemTopping;
  return 'ItemTopping(name: ${_this.name}, price: ${_this.price})';
}


}

/// @nodoc
abstract mixin class $ItemToppingCopyWith<$Res>  {
  factory $ItemToppingCopyWith(ItemTopping value, $Res Function(ItemTopping) _then) = _$ItemToppingCopyWithImpl;
@useResult
$Res call({
 String name, int price
});




}
/// @nodoc
class _$ItemToppingCopyWithImpl<$Res>
    implements $ItemToppingCopyWith<$Res> {
  _$ItemToppingCopyWithImpl(this._self, this._then);

  final ItemTopping _self;
  final $Res Function(ItemTopping) _then;

/// Create a copy of ItemTopping
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? price = null,}) {
  return _then(ItemTopping(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemTopping].
extension ItemToppingPatterns on ItemTopping {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemTopping value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemTopping() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemTopping value)  $default,){
final _that = this;
switch (_that) {
case _ItemTopping():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemTopping value)?  $default,){
final _that = this;
switch (_that) {
case _ItemTopping() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemTopping() when $default != null:
return $default(_that.name,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int price)  $default,) {final _that = this;
switch (_that) {
case _ItemTopping():
return $default(_that.name,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int price)?  $default,) {final _that = this;
switch (_that) {
case _ItemTopping() when $default != null:
return $default(_that.name,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemTopping implements ItemTopping {
  const _ItemTopping({required this.name, required this.price});
  factory _ItemTopping.fromJson(Map<String, dynamic> json) => _$ItemToppingFromJson(json);

@override final  String name;
@override final  int price;

/// Create a copy of ItemTopping
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemToppingCopyWith<_ItemTopping> get copyWith => __$ItemToppingCopyWithImpl<_ItemTopping>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemToppingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemTopping&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,price);
}

@override
String toString() {
    return 'ItemTopping(name: $name, price: $price)';
}


}

/// @nodoc
abstract mixin class _$ItemToppingCopyWith<$Res> implements $ItemToppingCopyWith<$Res> {
  factory _$ItemToppingCopyWith(_ItemTopping value, $Res Function(_ItemTopping) _then) = __$ItemToppingCopyWithImpl;
@override @useResult
$Res call({
 String name, int price
});




}
/// @nodoc
class __$ItemToppingCopyWithImpl<$Res>
    implements _$ItemToppingCopyWith<$Res> {
  __$ItemToppingCopyWithImpl(this._self, this._then);

  final _ItemTopping _self;
  final $Res Function(_ItemTopping) _then;

/// Create a copy of ItemTopping
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? price = null,}) {
  return _then(_ItemTopping(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OrderItem {

 String get productId; String get name; String get size; List<ItemTopping> get toppings; int get unitPrice; int get qty; String get note; int get batch;
/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemCopyWith<OrderItem> get copyWith => _$OrderItemCopyWithImpl<OrderItem>(this as OrderItem, _$identity);

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrderItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItem&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.size, _this.size) || other.size == _this.size)&&const DeepCollectionEquality().equals(other.toppings, _this.toppings)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.batch, _this.batch) || other.batch == _this.batch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrderItem;
  return Object.hash(runtimeType,_this.productId,_this.name,_this.size,const DeepCollectionEquality().hash(_this.toppings),_this.unitPrice,_this.qty,_this.note,_this.batch);
}

@override
String toString() {
  final _this = this as OrderItem;
  return 'OrderItem(productId: ${_this.productId}, name: ${_this.name}, size: ${_this.size}, toppings: ${_this.toppings}, unitPrice: ${_this.unitPrice}, qty: ${_this.qty}, note: ${_this.note}, batch: ${_this.batch})';
}


}

/// @nodoc
abstract mixin class $OrderItemCopyWith<$Res>  {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) _then) = _$OrderItemCopyWithImpl;
@useResult
$Res call({
 String productId, String name, String size, List<ItemTopping> toppings, int unitPrice, int qty, String note, int batch
});




}
/// @nodoc
class _$OrderItemCopyWithImpl<$Res>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._self, this._then);

  final OrderItem _self;
  final $Res Function(OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? size = null,Object? toppings = null,Object? unitPrice = null,Object? qty = null,Object? note = null,Object? batch = null,}) {
  return _then(OrderItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,toppings: null == toppings ? _self.toppings : toppings // ignore: cast_nullable_to_non_nullable
as List<ItemTopping>,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,batch: null == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItem].
extension OrderItemPatterns on OrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderItem():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String name,  String size,  List<ItemTopping> toppings,  int unitPrice,  int qty,  String note,  int batch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.productId,_that.name,_that.size,_that.toppings,_that.unitPrice,_that.qty,_that.note,_that.batch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String name,  String size,  List<ItemTopping> toppings,  int unitPrice,  int qty,  String note,  int batch)  $default,) {final _that = this;
switch (_that) {
case _OrderItem():
return $default(_that.productId,_that.name,_that.size,_that.toppings,_that.unitPrice,_that.qty,_that.note,_that.batch);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String name,  String size,  List<ItemTopping> toppings,  int unitPrice,  int qty,  String note,  int batch)?  $default,) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.productId,_that.name,_that.size,_that.toppings,_that.unitPrice,_that.qty,_that.note,_that.batch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItem extends OrderItem {
  const _OrderItem({required this.productId, required this.name, required this.size,  List<ItemTopping> toppings = const [], required this.unitPrice, this.qty = 1, this.note = '', this.batch = 1}): _toppings = toppings,super._();
  factory _OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

@override final  String productId;
@override final  String name;
@override final  String size;
 final  List<ItemTopping> _toppings;
@override@JsonKey() List<ItemTopping> get toppings {
  if (_toppings is EqualUnmodifiableListView) return _toppings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toppings);
}

@override final  int unitPrice;
@override@JsonKey() final  int qty;
@override@JsonKey() final  String note;
@override@JsonKey() final  int batch;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemCopyWith<_OrderItem> get copyWith => __$OrderItemCopyWithImpl<_OrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&const DeepCollectionEquality().equals(other.toppings, _toppings)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.note, note) || other.note == note)&&(identical(other.batch, batch) || other.batch == batch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,name,size,const DeepCollectionEquality().hash(_toppings),unitPrice,qty,note,batch);
}

@override
String toString() {
    return 'OrderItem(productId: $productId, name: $name, size: $size, toppings: $toppings, unitPrice: $unitPrice, qty: $qty, note: $note, batch: $batch)';
}


}

/// @nodoc
abstract mixin class _$OrderItemCopyWith<$Res> implements $OrderItemCopyWith<$Res> {
  factory _$OrderItemCopyWith(_OrderItem value, $Res Function(_OrderItem) _then) = __$OrderItemCopyWithImpl;
@override @useResult
$Res call({
 String productId, String name, String size, List<ItemTopping> toppings, int unitPrice, int qty, String note, int batch
});




}
/// @nodoc
class __$OrderItemCopyWithImpl<$Res>
    implements _$OrderItemCopyWith<$Res> {
  __$OrderItemCopyWithImpl(this._self, this._then);

  final _OrderItem _self;
  final $Res Function(_OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? size = null,Object? toppings = null,Object? unitPrice = null,Object? qty = null,Object? note = null,Object? batch = null,}) {
  return _then(_OrderItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,toppings: null == toppings ? _self._toppings : toppings // ignore: cast_nullable_to_non_nullable
as List<ItemTopping>,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,batch: null == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Order {

 String get id; String? get shortId; String? get tableId; OrderSource get source; OrderStatus get status; List<OrderItem> get items; int get subtotal; int get discount; String? get voucherCode; int get pointsRedeemed; int get total; int get cashAmount; int get qrAmount; String? get paidBy; String? get shiftId; String? get customerId; String get createdBy; String? get cancelReason; String? get cancelledBy; String? get confirmedBy;@TimestampConverter() DateTime? get confirmedAt; String? get mergedIntoId; List<String> get followerUids;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt; String? get updatedBy;@TimestampConverter() DateTime? get paidAt;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Order;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.shortId, _this.shortId) || other.shortId == _this.shortId)&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.voucherCode, _this.voucherCode) || other.voucherCode == _this.voucherCode)&&(identical(other.pointsRedeemed, _this.pointsRedeemed) || other.pointsRedeemed == _this.pointsRedeemed)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.cashAmount, _this.cashAmount) || other.cashAmount == _this.cashAmount)&&(identical(other.qrAmount, _this.qrAmount) || other.qrAmount == _this.qrAmount)&&(identical(other.paidBy, _this.paidBy) || other.paidBy == _this.paidBy)&&(identical(other.shiftId, _this.shiftId) || other.shiftId == _this.shiftId)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.cancelReason, _this.cancelReason) || other.cancelReason == _this.cancelReason)&&(identical(other.cancelledBy, _this.cancelledBy) || other.cancelledBy == _this.cancelledBy)&&(identical(other.confirmedBy, _this.confirmedBy) || other.confirmedBy == _this.confirmedBy)&&(identical(other.confirmedAt, _this.confirmedAt) || other.confirmedAt == _this.confirmedAt)&&(identical(other.mergedIntoId, _this.mergedIntoId) || other.mergedIntoId == _this.mergedIntoId)&&const DeepCollectionEquality().equals(other.followerUids, _this.followerUids)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.updatedBy, _this.updatedBy) || other.updatedBy == _this.updatedBy)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Order;
  return Object.hashAll([runtimeType,_this.id,_this.shortId,_this.tableId,_this.source,_this.status,const DeepCollectionEquality().hash(_this.items),_this.subtotal,_this.discount,_this.voucherCode,_this.pointsRedeemed,_this.total,_this.cashAmount,_this.qrAmount,_this.paidBy,_this.shiftId,_this.customerId,_this.createdBy,_this.cancelReason,_this.cancelledBy,_this.confirmedBy,_this.confirmedAt,_this.mergedIntoId,const DeepCollectionEquality().hash(_this.followerUids),_this.createdAt,_this.updatedAt,_this.updatedBy,_this.paidAt]);
}

@override
String toString() {
  final _this = this as Order;
  return 'Order(id: ${_this.id}, shortId: ${_this.shortId}, tableId: ${_this.tableId}, source: ${_this.source}, status: ${_this.status}, items: ${_this.items}, subtotal: ${_this.subtotal}, discount: ${_this.discount}, voucherCode: ${_this.voucherCode}, pointsRedeemed: ${_this.pointsRedeemed}, total: ${_this.total}, cashAmount: ${_this.cashAmount}, qrAmount: ${_this.qrAmount}, paidBy: ${_this.paidBy}, shiftId: ${_this.shiftId}, customerId: ${_this.customerId}, createdBy: ${_this.createdBy}, cancelReason: ${_this.cancelReason}, cancelledBy: ${_this.cancelledBy}, confirmedBy: ${_this.confirmedBy}, confirmedAt: ${_this.confirmedAt}, mergedIntoId: ${_this.mergedIntoId}, followerUids: ${_this.followerUids}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, updatedBy: ${_this.updatedBy}, paidAt: ${_this.paidAt})';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, String? shortId, String? tableId, OrderSource source, OrderStatus status, List<OrderItem> items, int subtotal, int discount, String? voucherCode, int pointsRedeemed, int total, int cashAmount, int qrAmount, String? paidBy, String? shiftId, String? customerId, String createdBy, String? cancelReason, String? cancelledBy, String? confirmedBy,@TimestampConverter() DateTime? confirmedAt, String? mergedIntoId, List<String> followerUids,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, String? updatedBy,@TimestampConverter() DateTime? paidAt
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shortId = freezed,Object? tableId = freezed,Object? source = null,Object? status = null,Object? items = null,Object? subtotal = null,Object? discount = null,Object? voucherCode = freezed,Object? pointsRedeemed = null,Object? total = null,Object? cashAmount = null,Object? qrAmount = null,Object? paidBy = freezed,Object? shiftId = freezed,Object? customerId = freezed,Object? createdBy = null,Object? cancelReason = freezed,Object? cancelledBy = freezed,Object? confirmedBy = freezed,Object? confirmedAt = freezed,Object? mergedIntoId = freezed,Object? followerUids = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? updatedBy = freezed,Object? paidAt = freezed,}) {
  return _then(Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shortId: freezed == shortId ? _self.shortId : shortId // ignore: cast_nullable_to_non_nullable
as String?,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as OrderSource,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,voucherCode: freezed == voucherCode ? _self.voucherCode : voucherCode // ignore: cast_nullable_to_non_nullable
as String?,pointsRedeemed: null == pointsRedeemed ? _self.pointsRedeemed : pointsRedeemed // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,cashAmount: null == cashAmount ? _self.cashAmount : cashAmount // ignore: cast_nullable_to_non_nullable
as int,qrAmount: null == qrAmount ? _self.qrAmount : qrAmount // ignore: cast_nullable_to_non_nullable
as int,paidBy: freezed == paidBy ? _self.paidBy : paidBy // ignore: cast_nullable_to_non_nullable
as String?,shiftId: freezed == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,cancelledBy: freezed == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as String?,confirmedBy: freezed == confirmedBy ? _self.confirmedBy : confirmedBy // ignore: cast_nullable_to_non_nullable
as String?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mergedIntoId: freezed == mergedIntoId ? _self.mergedIntoId : mergedIntoId // ignore: cast_nullable_to_non_nullable
as String?,followerUids: null == followerUids ? _self.followerUids : followerUids // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? shortId,  String? tableId,  OrderSource source,  OrderStatus status,  List<OrderItem> items,  int subtotal,  int discount,  String? voucherCode,  int pointsRedeemed,  int total,  int cashAmount,  int qrAmount,  String? paidBy,  String? shiftId,  String? customerId,  String createdBy,  String? cancelReason,  String? cancelledBy,  String? confirmedBy, @TimestampConverter()  DateTime? confirmedAt,  String? mergedIntoId,  List<String> followerUids, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  String? updatedBy, @TimestampConverter()  DateTime? paidAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.shortId,_that.tableId,_that.source,_that.status,_that.items,_that.subtotal,_that.discount,_that.voucherCode,_that.pointsRedeemed,_that.total,_that.cashAmount,_that.qrAmount,_that.paidBy,_that.shiftId,_that.customerId,_that.createdBy,_that.cancelReason,_that.cancelledBy,_that.confirmedBy,_that.confirmedAt,_that.mergedIntoId,_that.followerUids,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.paidAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? shortId,  String? tableId,  OrderSource source,  OrderStatus status,  List<OrderItem> items,  int subtotal,  int discount,  String? voucherCode,  int pointsRedeemed,  int total,  int cashAmount,  int qrAmount,  String? paidBy,  String? shiftId,  String? customerId,  String createdBy,  String? cancelReason,  String? cancelledBy,  String? confirmedBy, @TimestampConverter()  DateTime? confirmedAt,  String? mergedIntoId,  List<String> followerUids, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  String? updatedBy, @TimestampConverter()  DateTime? paidAt)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.shortId,_that.tableId,_that.source,_that.status,_that.items,_that.subtotal,_that.discount,_that.voucherCode,_that.pointsRedeemed,_that.total,_that.cashAmount,_that.qrAmount,_that.paidBy,_that.shiftId,_that.customerId,_that.createdBy,_that.cancelReason,_that.cancelledBy,_that.confirmedBy,_that.confirmedAt,_that.mergedIntoId,_that.followerUids,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.paidAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? shortId,  String? tableId,  OrderSource source,  OrderStatus status,  List<OrderItem> items,  int subtotal,  int discount,  String? voucherCode,  int pointsRedeemed,  int total,  int cashAmount,  int qrAmount,  String? paidBy,  String? shiftId,  String? customerId,  String createdBy,  String? cancelReason,  String? cancelledBy,  String? confirmedBy, @TimestampConverter()  DateTime? confirmedAt,  String? mergedIntoId,  List<String> followerUids, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  String? updatedBy, @TimestampConverter()  DateTime? paidAt)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.shortId,_that.tableId,_that.source,_that.status,_that.items,_that.subtotal,_that.discount,_that.voucherCode,_that.pointsRedeemed,_that.total,_that.cashAmount,_that.qrAmount,_that.paidBy,_that.shiftId,_that.customerId,_that.createdBy,_that.cancelReason,_that.cancelledBy,_that.confirmedBy,_that.confirmedAt,_that.mergedIntoId,_that.followerUids,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.paidAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order extends Order {
  const _Order({required this.id, this.shortId, this.tableId, this.source = OrderSource.staff, this.status = OrderStatus.pending,  List<OrderItem> items = const [], this.subtotal = 0, this.discount = 0, this.voucherCode, this.pointsRedeemed = 0, this.total = 0, this.cashAmount = 0, this.qrAmount = 0, this.paidBy, this.shiftId, this.customerId, required this.createdBy, this.cancelReason, this.cancelledBy, this.confirmedBy, @TimestampConverter() this.confirmedAt, this.mergedIntoId,  List<String> followerUids = const [], @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt, this.updatedBy, @TimestampConverter() this.paidAt}): _items = items,_followerUids = followerUids,super._();
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override final  String? shortId;
@override final  String? tableId;
@override@JsonKey() final  OrderSource source;
@override@JsonKey() final  OrderStatus status;
 final  List<OrderItem> _items;
@override@JsonKey() List<OrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int subtotal;
@override@JsonKey() final  int discount;
@override final  String? voucherCode;
@override@JsonKey() final  int pointsRedeemed;
@override@JsonKey() final  int total;
@override@JsonKey() final  int cashAmount;
@override@JsonKey() final  int qrAmount;
@override final  String? paidBy;
@override final  String? shiftId;
@override final  String? customerId;
@override final  String createdBy;
@override final  String? cancelReason;
@override final  String? cancelledBy;
@override final  String? confirmedBy;
@override@TimestampConverter() final  DateTime? confirmedAt;
@override final  String? mergedIntoId;
 final  List<String> _followerUids;
@override@JsonKey() List<String> get followerUids {
  if (_followerUids is EqualUnmodifiableListView) return _followerUids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followerUids);
}

@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;
@override final  String? updatedBy;
@override@TimestampConverter() final  DateTime? paidAt;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.shortId, shortId) || other.shortId == shortId)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.voucherCode, voucherCode) || other.voucherCode == voucherCode)&&(identical(other.pointsRedeemed, pointsRedeemed) || other.pointsRedeemed == pointsRedeemed)&&(identical(other.total, total) || other.total == total)&&(identical(other.cashAmount, cashAmount) || other.cashAmount == cashAmount)&&(identical(other.qrAmount, qrAmount) || other.qrAmount == qrAmount)&&(identical(other.paidBy, paidBy) || other.paidBy == paidBy)&&(identical(other.shiftId, shiftId) || other.shiftId == shiftId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy)&&(identical(other.confirmedBy, confirmedBy) || other.confirmedBy == confirmedBy)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.mergedIntoId, mergedIntoId) || other.mergedIntoId == mergedIntoId)&&const DeepCollectionEquality().equals(other.followerUids, _followerUids)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,shortId,tableId,source,status,const DeepCollectionEquality().hash(_items),subtotal,discount,voucherCode,pointsRedeemed,total,cashAmount,qrAmount,paidBy,shiftId,customerId,createdBy,cancelReason,cancelledBy,confirmedBy,confirmedAt,mergedIntoId,const DeepCollectionEquality().hash(_followerUids),createdAt,updatedAt,updatedBy,paidAt]);
}

@override
String toString() {
    return 'Order(id: $id, shortId: $shortId, tableId: $tableId, source: $source, status: $status, items: $items, subtotal: $subtotal, discount: $discount, voucherCode: $voucherCode, pointsRedeemed: $pointsRedeemed, total: $total, cashAmount: $cashAmount, qrAmount: $qrAmount, paidBy: $paidBy, shiftId: $shiftId, customerId: $customerId, createdBy: $createdBy, cancelReason: $cancelReason, cancelledBy: $cancelledBy, confirmedBy: $confirmedBy, confirmedAt: $confirmedAt, mergedIntoId: $mergedIntoId, followerUids: $followerUids, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String? shortId, String? tableId, OrderSource source, OrderStatus status, List<OrderItem> items, int subtotal, int discount, String? voucherCode, int pointsRedeemed, int total, int cashAmount, int qrAmount, String? paidBy, String? shiftId, String? customerId, String createdBy, String? cancelReason, String? cancelledBy, String? confirmedBy,@TimestampConverter() DateTime? confirmedAt, String? mergedIntoId, List<String> followerUids,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, String? updatedBy,@TimestampConverter() DateTime? paidAt
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shortId = freezed,Object? tableId = freezed,Object? source = null,Object? status = null,Object? items = null,Object? subtotal = null,Object? discount = null,Object? voucherCode = freezed,Object? pointsRedeemed = null,Object? total = null,Object? cashAmount = null,Object? qrAmount = null,Object? paidBy = freezed,Object? shiftId = freezed,Object? customerId = freezed,Object? createdBy = null,Object? cancelReason = freezed,Object? cancelledBy = freezed,Object? confirmedBy = freezed,Object? confirmedAt = freezed,Object? mergedIntoId = freezed,Object? followerUids = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? updatedBy = freezed,Object? paidAt = freezed,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shortId: freezed == shortId ? _self.shortId : shortId // ignore: cast_nullable_to_non_nullable
as String?,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as OrderSource,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,voucherCode: freezed == voucherCode ? _self.voucherCode : voucherCode // ignore: cast_nullable_to_non_nullable
as String?,pointsRedeemed: null == pointsRedeemed ? _self.pointsRedeemed : pointsRedeemed // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,cashAmount: null == cashAmount ? _self.cashAmount : cashAmount // ignore: cast_nullable_to_non_nullable
as int,qrAmount: null == qrAmount ? _self.qrAmount : qrAmount // ignore: cast_nullable_to_non_nullable
as int,paidBy: freezed == paidBy ? _self.paidBy : paidBy // ignore: cast_nullable_to_non_nullable
as String?,shiftId: freezed == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,cancelledBy: freezed == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as String?,confirmedBy: freezed == confirmedBy ? _self.confirmedBy : confirmedBy // ignore: cast_nullable_to_non_nullable
as String?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mergedIntoId: freezed == mergedIntoId ? _self.mergedIntoId : mergedIntoId // ignore: cast_nullable_to_non_nullable
as String?,followerUids: null == followerUids ? _self._followerUids : followerUids // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Customer {

 String get id; String? get name; String get phone; int get points; int get visitCount;
/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCopyWith<Customer> get copyWith => _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Customer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Customer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.visitCount, _this.visitCount) || other.visitCount == _this.visitCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Customer;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone,_this.points,_this.visitCount);
}

@override
String toString() {
  final _this = this as Customer;
  return 'Customer(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone}, points: ${_this.points}, visitCount: ${_this.visitCount})';
}


}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res>  {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) = _$CustomerCopyWithImpl;
@useResult
$Res call({
 String id, String? name, String phone, int points, int visitCount
});




}
/// @nodoc
class _$CustomerCopyWithImpl<$Res>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._self, this._then);

  final Customer _self;
  final $Res Function(Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? phone = null,Object? points = null,Object? visitCount = null,}) {
  return _then(Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,visitCount: null == visitCount ? _self.visitCount : visitCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Customer].
extension CustomerPatterns on Customer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Customer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Customer value)  $default,){
final _that = this;
switch (_that) {
case _Customer():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Customer value)?  $default,){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  String phone,  int points,  int visitCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.points,_that.visitCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  String phone,  int points,  int visitCount)  $default,) {final _that = this;
switch (_that) {
case _Customer():
return $default(_that.id,_that.name,_that.phone,_that.points,_that.visitCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  String phone,  int points,  int visitCount)?  $default,) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.points,_that.visitCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Customer implements Customer {
  const _Customer({required this.id, this.name, required this.phone, this.points = 0, this.visitCount = 0});
  factory _Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

@override final  String id;
@override final  String? name;
@override final  String phone;
@override@JsonKey() final  int points;
@override@JsonKey() final  int visitCount;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCopyWith<_Customer> get copyWith => __$CustomerCopyWithImpl<_Customer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.points, points) || other.points == points)&&(identical(other.visitCount, visitCount) || other.visitCount == visitCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone,points,visitCount);
}

@override
String toString() {
    return 'Customer(id: $id, name: $name, phone: $phone, points: $points, visitCount: $visitCount)';
}


}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) = __$CustomerCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, String phone, int points, int visitCount
});




}
/// @nodoc
class __$CustomerCopyWithImpl<$Res>
    implements _$CustomerCopyWith<$Res> {
  __$CustomerCopyWithImpl(this._self, this._then);

  final _Customer _self;
  final $Res Function(_Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? phone = null,Object? points = null,Object? visitCount = null,}) {
  return _then(_Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,visitCount: null == visitCount ? _self.visitCount : visitCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Voucher {

 String get code; VoucherType get type; int get value; int get minOrder; int? get maxDiscount;@TimestampConverter() DateTime? get expiresAt; int get usageLimit; int get usedCount; bool get isActive;
/// Create a copy of Voucher
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoucherCopyWith<Voucher> get copyWith => _$VoucherCopyWithImpl<Voucher>(this as Voucher, _$identity);

  /// Serializes this Voucher to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Voucher;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Voucher&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.minOrder, _this.minOrder) || other.minOrder == _this.minOrder)&&(identical(other.maxDiscount, _this.maxDiscount) || other.maxDiscount == _this.maxDiscount)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.usageLimit, _this.usageLimit) || other.usageLimit == _this.usageLimit)&&(identical(other.usedCount, _this.usedCount) || other.usedCount == _this.usedCount)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Voucher;
  return Object.hash(runtimeType,_this.code,_this.type,_this.value,_this.minOrder,_this.maxDiscount,_this.expiresAt,_this.usageLimit,_this.usedCount,_this.isActive);
}

@override
String toString() {
  final _this = this as Voucher;
  return 'Voucher(code: ${_this.code}, type: ${_this.type}, value: ${_this.value}, minOrder: ${_this.minOrder}, maxDiscount: ${_this.maxDiscount}, expiresAt: ${_this.expiresAt}, usageLimit: ${_this.usageLimit}, usedCount: ${_this.usedCount}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $VoucherCopyWith<$Res>  {
  factory $VoucherCopyWith(Voucher value, $Res Function(Voucher) _then) = _$VoucherCopyWithImpl;
@useResult
$Res call({
 String code, VoucherType type, int value, int minOrder, int? maxDiscount,@TimestampConverter() DateTime? expiresAt, int usageLimit, int usedCount, bool isActive
});




}
/// @nodoc
class _$VoucherCopyWithImpl<$Res>
    implements $VoucherCopyWith<$Res> {
  _$VoucherCopyWithImpl(this._self, this._then);

  final Voucher _self;
  final $Res Function(Voucher) _then;

/// Create a copy of Voucher
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? type = null,Object? value = null,Object? minOrder = null,Object? maxDiscount = freezed,Object? expiresAt = freezed,Object? usageLimit = null,Object? usedCount = null,Object? isActive = null,}) {
  return _then(Voucher(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as VoucherType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,minOrder: null == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as int,maxDiscount: freezed == maxDiscount ? _self.maxDiscount : maxDiscount // ignore: cast_nullable_to_non_nullable
as int?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,usageLimit: null == usageLimit ? _self.usageLimit : usageLimit // ignore: cast_nullable_to_non_nullable
as int,usedCount: null == usedCount ? _self.usedCount : usedCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Voucher].
extension VoucherPatterns on Voucher {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Voucher value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Voucher() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Voucher value)  $default,){
final _that = this;
switch (_that) {
case _Voucher():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Voucher value)?  $default,){
final _that = this;
switch (_that) {
case _Voucher() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  VoucherType type,  int value,  int minOrder,  int? maxDiscount, @TimestampConverter()  DateTime? expiresAt,  int usageLimit,  int usedCount,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Voucher() when $default != null:
return $default(_that.code,_that.type,_that.value,_that.minOrder,_that.maxDiscount,_that.expiresAt,_that.usageLimit,_that.usedCount,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  VoucherType type,  int value,  int minOrder,  int? maxDiscount, @TimestampConverter()  DateTime? expiresAt,  int usageLimit,  int usedCount,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Voucher():
return $default(_that.code,_that.type,_that.value,_that.minOrder,_that.maxDiscount,_that.expiresAt,_that.usageLimit,_that.usedCount,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  VoucherType type,  int value,  int minOrder,  int? maxDiscount, @TimestampConverter()  DateTime? expiresAt,  int usageLimit,  int usedCount,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Voucher() when $default != null:
return $default(_that.code,_that.type,_that.value,_that.minOrder,_that.maxDiscount,_that.expiresAt,_that.usageLimit,_that.usedCount,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Voucher implements Voucher {
  const _Voucher({required this.code, required this.type, required this.value, this.minOrder = 0, this.maxDiscount, @TimestampConverter() this.expiresAt, this.usageLimit = 1, this.usedCount = 0, this.isActive = true});
  factory _Voucher.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);

@override final  String code;
@override final  VoucherType type;
@override final  int value;
@override@JsonKey() final  int minOrder;
@override final  int? maxDiscount;
@override@TimestampConverter() final  DateTime? expiresAt;
@override@JsonKey() final  int usageLimit;
@override@JsonKey() final  int usedCount;
@override@JsonKey() final  bool isActive;

/// Create a copy of Voucher
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoucherCopyWith<_Voucher> get copyWith => __$VoucherCopyWithImpl<_Voucher>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoucherToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Voucher&&(identical(other.code, code) || other.code == code)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.minOrder, minOrder) || other.minOrder == minOrder)&&(identical(other.maxDiscount, maxDiscount) || other.maxDiscount == maxDiscount)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.usageLimit, usageLimit) || other.usageLimit == usageLimit)&&(identical(other.usedCount, usedCount) || other.usedCount == usedCount)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,type,value,minOrder,maxDiscount,expiresAt,usageLimit,usedCount,isActive);
}

@override
String toString() {
    return 'Voucher(code: $code, type: $type, value: $value, minOrder: $minOrder, maxDiscount: $maxDiscount, expiresAt: $expiresAt, usageLimit: $usageLimit, usedCount: $usedCount, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$VoucherCopyWith<$Res> implements $VoucherCopyWith<$Res> {
  factory _$VoucherCopyWith(_Voucher value, $Res Function(_Voucher) _then) = __$VoucherCopyWithImpl;
@override @useResult
$Res call({
 String code, VoucherType type, int value, int minOrder, int? maxDiscount,@TimestampConverter() DateTime? expiresAt, int usageLimit, int usedCount, bool isActive
});




}
/// @nodoc
class __$VoucherCopyWithImpl<$Res>
    implements _$VoucherCopyWith<$Res> {
  __$VoucherCopyWithImpl(this._self, this._then);

  final _Voucher _self;
  final $Res Function(_Voucher) _then;

/// Create a copy of Voucher
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? type = null,Object? value = null,Object? minOrder = null,Object? maxDiscount = freezed,Object? expiresAt = freezed,Object? usageLimit = null,Object? usedCount = null,Object? isActive = null,}) {
  return _then(_Voucher(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as VoucherType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,minOrder: null == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as int,maxDiscount: freezed == maxDiscount ? _self.maxDiscount : maxDiscount // ignore: cast_nullable_to_non_nullable
as int?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,usageLimit: null == usageLimit ? _self.usageLimit : usageLimit // ignore: cast_nullable_to_non_nullable
as int,usedCount: null == usedCount ? _self.usedCount : usedCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ShopSettings {

 String get name; String get address; String get bankBin; String get bankAccountNo; String get bankAccountName; int get lateOrderMinutes; int get pointsPerVnd; int get vndPerPoint;
/// Create a copy of ShopSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopSettingsCopyWith<ShopSettings> get copyWith => _$ShopSettingsCopyWithImpl<ShopSettings>(this as ShopSettings, _$identity);

  /// Serializes this ShopSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ShopSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopSettings&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.bankBin, _this.bankBin) || other.bankBin == _this.bankBin)&&(identical(other.bankAccountNo, _this.bankAccountNo) || other.bankAccountNo == _this.bankAccountNo)&&(identical(other.bankAccountName, _this.bankAccountName) || other.bankAccountName == _this.bankAccountName)&&(identical(other.lateOrderMinutes, _this.lateOrderMinutes) || other.lateOrderMinutes == _this.lateOrderMinutes)&&(identical(other.pointsPerVnd, _this.pointsPerVnd) || other.pointsPerVnd == _this.pointsPerVnd)&&(identical(other.vndPerPoint, _this.vndPerPoint) || other.vndPerPoint == _this.vndPerPoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ShopSettings;
  return Object.hash(runtimeType,_this.name,_this.address,_this.bankBin,_this.bankAccountNo,_this.bankAccountName,_this.lateOrderMinutes,_this.pointsPerVnd,_this.vndPerPoint);
}

@override
String toString() {
  final _this = this as ShopSettings;
  return 'ShopSettings(name: ${_this.name}, address: ${_this.address}, bankBin: ${_this.bankBin}, bankAccountNo: ${_this.bankAccountNo}, bankAccountName: ${_this.bankAccountName}, lateOrderMinutes: ${_this.lateOrderMinutes}, pointsPerVnd: ${_this.pointsPerVnd}, vndPerPoint: ${_this.vndPerPoint})';
}


}

/// @nodoc
abstract mixin class $ShopSettingsCopyWith<$Res>  {
  factory $ShopSettingsCopyWith(ShopSettings value, $Res Function(ShopSettings) _then) = _$ShopSettingsCopyWithImpl;
@useResult
$Res call({
 String name, String address, String bankBin, String bankAccountNo, String bankAccountName, int lateOrderMinutes, int pointsPerVnd, int vndPerPoint
});




}
/// @nodoc
class _$ShopSettingsCopyWithImpl<$Res>
    implements $ShopSettingsCopyWith<$Res> {
  _$ShopSettingsCopyWithImpl(this._self, this._then);

  final ShopSettings _self;
  final $Res Function(ShopSettings) _then;

/// Create a copy of ShopSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = null,Object? bankBin = null,Object? bankAccountNo = null,Object? bankAccountName = null,Object? lateOrderMinutes = null,Object? pointsPerVnd = null,Object? vndPerPoint = null,}) {
  return _then(ShopSettings(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,bankBin: null == bankBin ? _self.bankBin : bankBin // ignore: cast_nullable_to_non_nullable
as String,bankAccountNo: null == bankAccountNo ? _self.bankAccountNo : bankAccountNo // ignore: cast_nullable_to_non_nullable
as String,bankAccountName: null == bankAccountName ? _self.bankAccountName : bankAccountName // ignore: cast_nullable_to_non_nullable
as String,lateOrderMinutes: null == lateOrderMinutes ? _self.lateOrderMinutes : lateOrderMinutes // ignore: cast_nullable_to_non_nullable
as int,pointsPerVnd: null == pointsPerVnd ? _self.pointsPerVnd : pointsPerVnd // ignore: cast_nullable_to_non_nullable
as int,vndPerPoint: null == vndPerPoint ? _self.vndPerPoint : vndPerPoint // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ShopSettings].
extension ShopSettingsPatterns on ShopSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShopSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShopSettings() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShopSettings value)  $default,){
final _that = this;
switch (_that) {
case _ShopSettings():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShopSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ShopSettings() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String address,  String bankBin,  String bankAccountNo,  String bankAccountName,  int lateOrderMinutes,  int pointsPerVnd,  int vndPerPoint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShopSettings() when $default != null:
return $default(_that.name,_that.address,_that.bankBin,_that.bankAccountNo,_that.bankAccountName,_that.lateOrderMinutes,_that.pointsPerVnd,_that.vndPerPoint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String address,  String bankBin,  String bankAccountNo,  String bankAccountName,  int lateOrderMinutes,  int pointsPerVnd,  int vndPerPoint)  $default,) {final _that = this;
switch (_that) {
case _ShopSettings():
return $default(_that.name,_that.address,_that.bankBin,_that.bankAccountNo,_that.bankAccountName,_that.lateOrderMinutes,_that.pointsPerVnd,_that.vndPerPoint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String address,  String bankBin,  String bankAccountNo,  String bankAccountName,  int lateOrderMinutes,  int pointsPerVnd,  int vndPerPoint)?  $default,) {final _that = this;
switch (_that) {
case _ShopSettings() when $default != null:
return $default(_that.name,_that.address,_that.bankBin,_that.bankAccountNo,_that.bankAccountName,_that.lateOrderMinutes,_that.pointsPerVnd,_that.vndPerPoint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShopSettings extends ShopSettings {
  const _ShopSettings({this.name = 'BrewBoss', this.address = '', this.bankBin = '', this.bankAccountNo = '', this.bankAccountName = '', this.lateOrderMinutes = 10, this.pointsPerVnd = 10000, this.vndPerPoint = 1000}): super._();
  factory _ShopSettings.fromJson(Map<String, dynamic> json) => _$ShopSettingsFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String address;
@override@JsonKey() final  String bankBin;
@override@JsonKey() final  String bankAccountNo;
@override@JsonKey() final  String bankAccountName;
@override@JsonKey() final  int lateOrderMinutes;
@override@JsonKey() final  int pointsPerVnd;
@override@JsonKey() final  int vndPerPoint;

/// Create a copy of ShopSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopSettingsCopyWith<_ShopSettings> get copyWith => __$ShopSettingsCopyWithImpl<_ShopSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShopSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShopSettings&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.bankBin, bankBin) || other.bankBin == bankBin)&&(identical(other.bankAccountNo, bankAccountNo) || other.bankAccountNo == bankAccountNo)&&(identical(other.bankAccountName, bankAccountName) || other.bankAccountName == bankAccountName)&&(identical(other.lateOrderMinutes, lateOrderMinutes) || other.lateOrderMinutes == lateOrderMinutes)&&(identical(other.pointsPerVnd, pointsPerVnd) || other.pointsPerVnd == pointsPerVnd)&&(identical(other.vndPerPoint, vndPerPoint) || other.vndPerPoint == vndPerPoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,address,bankBin,bankAccountNo,bankAccountName,lateOrderMinutes,pointsPerVnd,vndPerPoint);
}

@override
String toString() {
    return 'ShopSettings(name: $name, address: $address, bankBin: $bankBin, bankAccountNo: $bankAccountNo, bankAccountName: $bankAccountName, lateOrderMinutes: $lateOrderMinutes, pointsPerVnd: $pointsPerVnd, vndPerPoint: $vndPerPoint)';
}


}

/// @nodoc
abstract mixin class _$ShopSettingsCopyWith<$Res> implements $ShopSettingsCopyWith<$Res> {
  factory _$ShopSettingsCopyWith(_ShopSettings value, $Res Function(_ShopSettings) _then) = __$ShopSettingsCopyWithImpl;
@override @useResult
$Res call({
 String name, String address, String bankBin, String bankAccountNo, String bankAccountName, int lateOrderMinutes, int pointsPerVnd, int vndPerPoint
});




}
/// @nodoc
class __$ShopSettingsCopyWithImpl<$Res>
    implements _$ShopSettingsCopyWith<$Res> {
  __$ShopSettingsCopyWithImpl(this._self, this._then);

  final _ShopSettings _self;
  final $Res Function(_ShopSettings) _then;

/// Create a copy of ShopSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = null,Object? bankBin = null,Object? bankAccountNo = null,Object? bankAccountName = null,Object? lateOrderMinutes = null,Object? pointsPerVnd = null,Object? vndPerPoint = null,}) {
  return _then(_ShopSettings(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,bankBin: null == bankBin ? _self.bankBin : bankBin // ignore: cast_nullable_to_non_nullable
as String,bankAccountNo: null == bankAccountNo ? _self.bankAccountNo : bankAccountNo // ignore: cast_nullable_to_non_nullable
as String,bankAccountName: null == bankAccountName ? _self.bankAccountName : bankAccountName // ignore: cast_nullable_to_non_nullable
as String,lateOrderMinutes: null == lateOrderMinutes ? _self.lateOrderMinutes : lateOrderMinutes // ignore: cast_nullable_to_non_nullable
as int,pointsPerVnd: null == pointsPerVnd ? _self.pointsPerVnd : pointsPerVnd // ignore: cast_nullable_to_non_nullable
as int,vndPerPoint: null == vndPerPoint ? _self.vndPerPoint : vndPerPoint // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
