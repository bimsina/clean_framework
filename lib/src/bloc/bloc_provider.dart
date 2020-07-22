import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension BlocProviderExtension on BuildContext {
  B bloc<B extends Bloc>() => Provider.of<B>(this, listen: false);
}

/// If provider of same type is found above [BlocProvider],
/// new instance won't be create. i.e. [create] will be ignored.
class BlocProvider<B extends Bloc> extends StatefulWidget {
  final B Function(BuildContext) create;
  final Widget child;

  const BlocProvider({
    Key key,
    this.create,
    @required this.child,
  }) : super(key: key);

  static of<B extends Bloc>(BuildContext context) =>
      Provider.of<B>(context, listen: false);

  @override
  _BlocProviderState createState() => _BlocProviderState<B>();
}

class _BlocProviderState<B extends Bloc> extends State<BlocProvider<B>> {
  B _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      try {
        _bloc = context.read<B>();
      } on ProviderNotFoundException catch (_) {
        if (widget.create == null) rethrow;
        _bloc = widget.create(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<B>.value(
      value: _bloc,
      child: widget.child,
      dispose: (_, __) => _bloc.dispose(),
    );
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }
}
