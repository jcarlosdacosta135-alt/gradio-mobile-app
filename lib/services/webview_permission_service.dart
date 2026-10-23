import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'web_origin_policy.dart';

Future<PermissionResponse> requestWebMediaPermission(
  BuildContext context, PermissionRequest request, String spaceUrl,
) async {
  PermissionResponse denied() => PermissionResponse(
    resources: request.resources, action: PermissionResponseAction.DENY,
  );
  if (!isAllowedMediaOrigin(request.origin.toString(), spaceUrl)) return denied();
  final permissions = <Permission>{};
  for (final resource in request.resources) {
    if (resource == PermissionResourceType.CAMERA) {
      permissions.add(Permission.camera);
    } else if (resource == PermissionResourceType.MICROPHONE) {
      permissions.add(Permission.microphone);
    } else if (resource == PermissionResourceType.CAMERA_AND_MICROPHONE) {
      permissions.addAll([Permission.camera, Permission.microphone]);
    } else {
      return denied();
    }
  }
  if (permissions.isEmpty || !context.mounted) return denied();
  final names = [
    if (permissions.contains(Permission.camera)) 'câmera',
    if (permissions.contains(Permission.microphone)) 'microfone',
  ].join(' e ');
  final allowed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Permitir acesso?'),
      content: Text('${request.origin.host} deseja usar $names.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false),
          child: const Text('Negar')),
        TextButton(onPressed: () => Navigator.pop(context, true),
          child: const Text('Permitir')),
      ],
    ),
  );
  if (allowed != true || !context.mounted) return denied();
  for (final permission in permissions) {
    if (!(await permission.request()).isGranted) return denied();
  }
  if (!context.mounted) return denied();
  return PermissionResponse(
    resources: request.resources, action: PermissionResponseAction.GRANT,
  );
}
