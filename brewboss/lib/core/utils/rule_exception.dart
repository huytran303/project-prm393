/// Business rule violation carrying its SRS message code.
class RuleException implements Exception {
  const RuleException(this.code, [this.args = const {}]);
  final String code;
  final Map<String, Object> args;

  @override
  String toString() => 'RuleException($code)';
}
