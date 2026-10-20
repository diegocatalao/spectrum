import 'dart:async';

import 'package:flutter/material.dart';

/// Spectrum Image Coordinator: reveals every SpectrumImage below it together, once
/// all of them have loaded, so a gallery does not show its images one by one.
class SpectrumImageCoordinator extends StatefulWidget {
  /// Widgets with the images to coordinate, at any depth.
  final Widget child;

  /// Time after which the images are revealed even if some are still loading.
  final Duration timeout;

  const SpectrumImageCoordinator({super.key, required this.child, this.timeout = const Duration(seconds: 5)});

  /// Returns the coordinator above the image, or null when there is none.
  /// Used by SpectrumImage to tell when it starts and finishes loading.
  static SpectrumImageCoordinatorState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ImageCoordinatorScope>()?.coordinator;
  }

  /// Returns True when the images can be shown: when every image has loaded,
  /// when the timeout has passed, or when there is no coordinator.
  static bool isRevealedOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ImageCoordinatorScope>()?.isRevealed ?? true;
  }

  @override
  State<SpectrumImageCoordinator> createState() => SpectrumImageCoordinatorState();
}

/// Keeps which images are loaded and the timeout of the current batch.
class SpectrumImageCoordinatorState extends State<SpectrumImageCoordinator> {
  /// Addresses of the images below the coordinator, and whether each one has loaded.
  /// Images with the same address share one entry, as they share the same download.
  final Map<Uri, bool> _loaded = {};

  /// Whether the timeout of the current batch has passed.
  bool _isTimedOut = false;

  /// Timer that reveals the images when the batch takes longer than the timeout.
  Timer? _timer;

  /// Whether a rebuild is already scheduled, so many changes in a row rebuild once.
  bool _isRebuildScheduled = false;

  bool get _isLoadedAll => _loaded.values.every((isLoaded) => isLoaded);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Adds an image that started loading.
  void register(Uri uri) {
    if (_loaded[uri] == false) {
      return;
    }

    if (_isLoadedAll) {
      // When every image had loaded, this is the first image of a new batch,
      // so the timeout starts again from now.
      _isTimedOut = false;
      _timer?.cancel();
      _timer = Timer(widget.timeout, () {
        _isTimedOut = true;
        _rebuild();
      });
    }

    _loaded[uri] = false;
    _rebuild();
  }

  /// Removes an image that left the tree or failed to load.
  void unregister(Uri uri) {
    if (_loaded.remove(uri) != null) {
      _rebuild();
    }
  }

  /// Marks an image as loaded.
  void load(Uri uri) {
    if (_loaded[uri] == false) {
      _loaded[uri] = true;
      _rebuild();
    }
  }

  /// Rebuilds after the current frame, since the images call the coordinator while
  /// they are being built, when a setState is not allowed.
  void _rebuild() {
    if (_isLoadedAll) {
      _timer?.cancel();
    }

    if (!_isRebuildScheduled) {
      _isRebuildScheduled = true;
      scheduleMicrotask(() {
        _isRebuildScheduled = false;

        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // When this coordinator is inside another one, the outer coordinator
    // handles every image, so this one only passes its child through.
    if (SpectrumImageCoordinator.maybeOf(context) != null) {
      return widget.child;
    } else {
      return _ImageCoordinatorScope(coordinator: this, isRevealed: _isLoadedAll || _isTimedOut, child: widget.child);
    }
  }
}

/// Shares the coordinator and whether the images can be shown with the images below it.
class _ImageCoordinatorScope extends InheritedWidget {
  final SpectrumImageCoordinatorState coordinator;
  final bool isRevealed;

  const _ImageCoordinatorScope({required this.coordinator, required this.isRevealed, required super.child});

  @override
  bool updateShouldNotify(_ImageCoordinatorScope oldWidget) => oldWidget.isRevealed != isRevealed;
}
