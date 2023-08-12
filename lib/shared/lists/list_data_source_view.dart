import 'package:flutter/cupertino.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/shared/lists/list_data_source.dart';

class FeedView<TItem> extends StatelessWidget with WatchItMixin {
  const FeedView({
    super.key,
    required this.listSource,
    required this.itemBuilder,
    this.gridDelegate,
    this.separatorBuilder,
    this.emptyListWidget,
    this.shrinkWrap = false,
    this.canRefresh = true,
    this.showInitialFetchSpinner = true,
    this.showFetchSpinner = true,
    this.leading,
    this.leadingSliver,
    this.trailing,
    this.trailingSliver,
    this.scrollController,
    this.reverse = false,
  })  : assert(trailing == null || trailingSliver == null,
            'You can only provide one of trailing or trailingSliver'),
        assert(leading == null || leadingSliver == null,
            'You can only provide one of leading or leadingSliver');

  final ScrollController? scrollController;
  final ListDataSource<TItem> listSource;
  final Widget Function(BuildContext, TItem) itemBuilder;
  final SliverGridDelegate? gridDelegate;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final bool canRefresh;
  final bool shrinkWrap;
  final Widget? leading;
  final Widget? leadingSliver;
  final Widget? trailing;
  final Widget? trailingSliver;
  final Widget? emptyListWidget;
  final bool reverse;

  /// Determines if the spinner be shown while fetching initial data.
  /// The spinner that is shown while fetching a new page will be shown regardless of this flag.
  final bool showInitialFetchSpinner;

  /// Determines if the spinner be shown while fetching a new page.
  final bool showFetchSpinner;

  @override
  Widget build(BuildContext context) {
    final int itemCount = watch(listSource.itemCount).value;

    final isLoading = watch(listSource.isFetchingNextPage).value;
    final isInitialLoading = isLoading && !listSource.updateWasCalled;
    final errors = watch(listSource.commandErrors).value;

    // If there are no items and there are errors, show the error widget.
    if (itemCount == 0 && errors != null) {
      return Center(child: Text('An Error has happend: ${errors.toString()}'));
    }

    // If we're loading the initial data and the flag for showing it is true,
    // show the spinner.
    if (showInitialFetchSpinner && isInitialLoading) {
      return const FeedViewSpinner();
    }
    // If there are no items and we're not loading the initial data, show the
    // empty list widget.
    else if (itemCount == 0 && !isInitialLoading) {
      return emptyListWidget ?? const SizedBox.shrink();
    }
    // If there are items, show the list.
    else {
      return CustomScrollView(
        controller: scrollController,
        shrinkWrap: shrinkWrap,
        reverse: reverse,
        slivers: [
          if (canRefresh) ...[
            CupertinoSliverRefreshControl(
              onRefresh: listSource.updateDataCommand.executeWithFuture,
            ),
            const SliverSpacer(size: 4.0),
          ],
          if (leading != null) SliverToBoxAdapter(child: leading),
          if (leadingSliver != null) leadingSliver!,
          SliverList.separated(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final item = listSource.getItemAtIndex(index);
              return itemBuilder(
                context,
                item,
              );
            },
            separatorBuilder:
                separatorBuilder ?? (context, index) => const SizedBox.shrink(),
          ),
          SliverToBoxAdapter(
            child: isLoading && showFetchSpinner
                ? const FeedViewInlineSpinner()
                : const SizedBox.shrink(),
          ),
          if (errors != null)
            SliverToBoxAdapter(
                child: Center(
              child: Center(
                  child: Text('An Error has happend: ${errors.toString()}')),
            )),
          if (trailing != null) SliverToBoxAdapter(child: trailing),
          if (trailingSliver != null) trailingSliver!,
        ],
      );
    }
  }
}

class FeedViewSpinner extends StatelessWidget {
  const FeedViewSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox.expand(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}

class SliverFeedViewSpinner extends StatelessWidget {
  const SliverFeedViewSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}

class FeedViewInlineSpinner extends StatelessWidget {
  const FeedViewInlineSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 48.0,
      child: Center(child: CupertinoActivityIndicator()),
    );
  }
}

class SliverSpacer extends StatelessWidget {
  const SliverSpacer({
    super.key,
    required this.size,
  });

  /// The size of the spacer.
  final double size;

  @override
  Widget build(BuildContext context) {
    // Get the scroll axis from the context
    final scrollable = Scrollable.of(context);
    final direction = scrollable.axisDirection;
    final axis = axisDirectionToAxis(direction);

    late final Widget child;

    if (axis == Axis.horizontal) {
      child = SizedBox(width: size);
    } else if (axis == Axis.vertical) {
      child = SizedBox(height: size);
    }

    return SliverToBoxAdapter(child: child);
  }
}
