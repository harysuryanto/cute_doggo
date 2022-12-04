import 'package:flutter/material.dart';

typedef GetFuture<T> = Future<T> Function();

/// Avoids re-fetch when states change.
///
/// This widget fixes the problem that FutureBuilder has where FutureBuilder
/// will always re-fetch everytime states change.
class CachedFutureBuilder<T> extends StatefulWidget {
  final Future<T> future;
  final AsyncWidgetBuilder<T> builder;
  final T? initialData;

  const CachedFutureBuilder({
    super.key,
    this.initialData,
    required this.future,
    required this.builder,
  });

  @override
  State<CachedFutureBuilder<T>> createState() => _CachedFutureBuilderState<T>();
}

class _CachedFutureBuilderState<T> extends State<CachedFutureBuilder<T>> {
  late Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: widget.initialData,
      builder: widget.builder,
      future: _future,
    );
  }
}
