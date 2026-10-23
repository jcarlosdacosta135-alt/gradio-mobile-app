import 'package:flutter_test/flutter_test.dart';
import 'package:gradio_mobile_app/services/web_origin_policy.dart';

void main() {
  const selected = 'https://autor-modelo.hf.space';
  test('aceita o Space selecionado e o domínio principal', () {
    expect(isAllowedMediaOrigin(selected, selected), isTrue);
    expect(isAllowedMediaOrigin('https://huggingface.co', selected), isTrue);
  });
  test('nega outros Spaces, imitação de domínio e origens inseguras', () {
    for (final origin in [
      'https://outro.hf.space', 'https://evilhuggingface.co',
      'https://huggingface.co.evil.test', 'http://autor-modelo.hf.space',
      'https://autor-modelo.hf.space:444', 'https://u:p@autor-modelo.hf.space',
      'file:///tmp/page.html', 'null',
    ]) {
      expect(isAllowedMediaOrigin(origin, selected), isFalse, reason: origin);
    }
  });
}
