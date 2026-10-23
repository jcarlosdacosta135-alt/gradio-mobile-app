bool isAllowedMediaOrigin(String origin, String spaceUrl) {
  final source = Uri.tryParse(origin);
  final space = Uri.tryParse(spaceUrl);
  if (source == null || space == null ||
      source.scheme != 'https' || space.scheme != 'https' ||
      source.port != 443 || space.port != 443 ||
      source.userInfo.isNotEmpty || space.userInfo.isNotEmpty) return false;
  final host = source.host;
  final trusted = host == 'huggingface.co' ||
      (host.endsWith('.hf.space') && host == space.host);
  return trusted;
}
