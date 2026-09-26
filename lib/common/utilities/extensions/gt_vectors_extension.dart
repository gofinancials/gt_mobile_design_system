import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show CacheManager, Config;
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    show encodeSvg;

/// A utility extension on [String] to streamline loading vector graphics.
///
/// This extension allows any string representing a URL or a local asset path
/// to be directly converted into a [BytesLoader] required by `vector_graphics`.
extension AppVectorsExtension on String {
  /// Converts this string into a [BytesLoader] for rendering vector graphics.
  ///
  /// If the string matches a URL pattern, it returns a loader that fetches the
  /// raw SVG and compiles it at runtime, since remote files never pass through
  /// the build-time `vector_graphics_compiler` transformer. Otherwise, it
  /// treats the string as a local asset path and returns an [AssetBytesLoader],
  /// which expects the asset to have been precompiled by that transformer. An
  /// optional [package] can be specified for local assets.
  BytesLoader vectorBytes([String? package]) {
    if (AppRegex.urlRegex.hasMatch(this)) {
      return _SvgNetworkBytesLoader(this);
    }
    return AssetBytesLoader(this, packageName: package);
  }
}

/// A [BytesLoader] that fetches an SVG from the network and compiles it into
/// the `vector_graphics` binary format.
///
/// `vector_graphics` only keeps a decoded graphic alive while a widget shows
/// it, so without caching every remount would refetch and recompile. Results
/// are therefore cached at two levels:
/// - compiled bytes in memory, keyed by URL, so remounts resolve at once and
///   concurrent requests for one URL share a single fetch and compile;
/// - raw SVG files on disk, reused even after their HTTP freshness lapses, so
///   a cold start skips the network.
class _SvgNetworkBytesLoader extends BytesLoader {
  /// Creates a loader for the SVG served at [url].
  const _SvgNetworkBytesLoader(this.url);

  /// The URL of the SVG to load.
  final String url;

  /// The most compiled graphics kept in memory before the least recently
  /// used one is evicted. Sized to hold a full country flag list.
  static const _maxCompiledEntries = 256;

  /// Pending and completed compilations, ordered from least to most recently
  /// used. Failed entries are removed so a later mount can retry.
  static final _compiled = <String, Future<ByteData>>{};

  /// A disk cache kept apart from the shared image cache, whose 200 entry
  /// limit a flag list alone would exhaust.
  static final _files = CacheManager(
    Config('gtSvgCache', maxNrOfCacheObjects: 500),
  );

  @override
  Future<ByteData> loadBytes(BuildContext? context) {
    final cached = _compiled.remove(url);
    if (cached != null) return _compiled[url] = cached;

    final pending = _fetchAndCompile();
    _compiled[url] = pending;
    if (_compiled.length > _maxCompiledEntries) {
      _compiled.remove(_compiled.keys.first);
    }

    return pending.catchError((Object error, StackTrace stackTrace) {
      if (identical(_compiled[url], pending)) _compiled.remove(url);
      Error.throwWithStackTrace(error, stackTrace);
    });
  }

  Future<ByteData> _fetchAndCompile() async {
    final xml = await _readSvg();
    return compute(_compileSvg, xml, debugLabel: 'Compile network SVG');
  }

  /// Reads the SVG from disk when cached, otherwise downloads it.
  ///
  /// A cached file is used even once its HTTP freshness has lapsed, since
  /// hosts often send short lifetimes (the circle flag set sends ten minutes)
  /// for graphics that rarely change, and waiting on the network would stall
  /// every graphic on each launch. An expired file is refreshed in the
  /// background for next time instead.
  Future<String> _readSvg() async {
    final cached = await _files.getFileFromCache(url);
    if (cached == null) {
      final file = await _files.getSingleFile(url);
      return file.readAsString();
    }

    if (cached.validTill.isBefore(DateTime.now())) {
      unawaited(_files.downloadFile(url).then<void>((_) {}, onError: (_) {}));
    }
    return cached.file.readAsString();
  }

  @override
  int get hashCode => Object.hash(runtimeType, url);

  @override
  bool operator ==(Object other) {
    return other is _SvgNetworkBytesLoader && other.url == url;
  }

  @override
  String toString() => 'GtSvgNetwork($url)';
}

/// Matches a `<mask>` whose only content is one shape filled solid white,
/// capturing the mask id and the shape.
final _solidMask = RegExp(
  r'''<mask\s+id=["']([^"']+)["']\s*>\s*(<(?:circle|ellipse|rect|path|polygon)\b[^>]*/>)\s*</mask>''',
);

/// Matches a solid white `fill` attribute on a shape.
final _whiteFill = RegExp(
  r'''\bfill=["'](?:#fff|#ffffff|white)["']''',
  caseSensitive: false,
);

/// Rewrites masks that only cut the graphic to one solid white shape, such as
/// the circle around every flag in a circle flag set, into equivalent clip
/// paths.
///
/// The build-time compiler does this through its masking optimizer, which is
/// unavailable at runtime. Left as masks, the whole graphic is drawn into an
/// offscreen layer, which Impeller renders visibly blocky at small sizes. A
/// clip draws directly and skips that layer. Masks with strokes, opacity or
/// inline styles are left untouched, since a clip would ignore those.
String _masksToClips(String xml) {
  final clipIds = <String>{};
  final rewritten = xml.replaceAllMapped(_solidMask, (match) {
    final id = match[1]!;
    final shape = match[2]!;
    final isSolidWhite =
        _whiteFill.hasMatch(shape) &&
        !shape.contains('opacity') &&
        !shape.contains('stroke') &&
        !shape.contains('style=');
    if (!isSolidWhite) return match[0]!;

    clipIds.add(id);
    return '<clipPath id="$id">$shape</clipPath>';
  });

  return clipIds.fold(rewritten, (svg, id) {
    return svg.replaceAll(
      RegExp('\\bmask=["\']url\\(#${RegExp.escape(id)}\\)["\']'),
      'clip-path="url(#$id)"',
    );
  });
}

/// Compiles SVG [xml] into `vector_graphics` binary data.
///
/// Simple masks are first rewritten as clips by [_masksToClips]. The
/// optimizers stay off, matching `flutter_svg`'s runtime loaders. They only
/// run once native path ops are initialised, which happens in the build-time
/// compiler but never inside the app.
ByteData _compileSvg(String xml) {
  return encodeSvg(
    xml: _masksToClips(xml),
    debugName: 'GtSvg network loader',
    enableClippingOptimizer: false,
    enableMaskingOptimizer: false,
    enableOverdrawOptimizer: false,
  ).buffer.asByteData();
}
