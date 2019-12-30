import 'dart:html';
import 'dart:ui' as ui;

void registerConsoleIframe(String nodeid) {
  // analyzer
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      'console-html',
      (int viewId) => IFrameElement()
        ..width = '640'
        ..height = '360'
        ..src =
            'http://localhost/?console=shell&node=$nodeid&resize=scale&xtermjs=1'
        ..style.border = 'none');
}