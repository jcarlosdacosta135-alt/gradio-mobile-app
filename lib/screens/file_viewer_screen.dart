import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'dart:convert';
import '../models/saved_generated_file.dart';
import '../models/huggingface_space.dart';
import '../services/saved_files_database.dart';
import '../services/file_storage_service.dart';
import 'gradio_webview_screen.dart';

class FileViewerScreen extends StatefulWidget {
  final SavedGeneratedFile savedFile;

  const FileViewerScreen({super.key, required this.savedFile});

  @override
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  bool _isLoading = false;
  String? _description;

  @override
  void initState() {
    super.initState();
    _description = widget.savedFile.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.savedFile.originalFileName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editDescription,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareFile,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'open_externally',
                child: Row(
                  children: [
                    Icon(Icons.open_in_new),
                    SizedBox(width: 8),
                    Text('Abrir em outro aplicativo'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Excluir', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.savedFile.fileTypeIcon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.savedFile.originalFileName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.savedFile.fileTypeCategory} • ${widget.savedFile.formattedFileSize}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (widget.savedFile.spaceUrl.isNotEmpty) {
                                  final space = HuggingFaceSpace(
                                    id: widget.savedFile.spaceId,
                                    name: widget.savedFile.spaceName,
                                    author: widget.savedFile.spaceId.split('/').first,
                                    likes: 0,
                                    url: widget.savedFile.spaceUrl,
                                    thumbnailUrl: '',
                                  );
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => GradioWebViewScreen(space: space),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'Origem: ${widget.savedFile.spaceName}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.savedFile.spaceUrl.isNotEmpty ? Colors.blue[700] : Colors.grey[500],
                                  decoration: widget.savedFile.spaceUrl.isNotEmpty ? TextDecoration.underline : null,
                                ),
                              ),
                            ),
                            Text(
                              widget.savedFile.formattedTimestamp,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_description != null && _description!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      _description!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          ),

          Expanded(
            child: _buildFileContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFileContent() {
    if (!widget.savedFile.fileExists) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Arquivo não encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'O arquivo pode ter sido movido ou excluído',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    switch (widget.savedFile.fileType) {
      case 'image':
        return _buildImageViewer();
      case 'audio':
        return _buildAudioViewer();
      case 'video':
        return _buildVideoViewer();
      case 'document':
        return _buildDocumentViewer();
      case 'data':
        return _buildDataViewer();
      default:
        return _buildGenericFileViewer();
    }
  }

  Widget _buildImageViewer() {
    return InteractiveViewer(
      child: Center(
        child: Image.file(
          File(widget.savedFile.localFilePath),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('Não foi possível exibir a imagem'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAudioViewer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.audiotrack,
            size: 64,
            color: Colors.blue[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Arquivo de áudio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.savedFile.formattedFileSize} • ${widget.savedFile.fileExtension.toUpperCase()}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _openExternally,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Reproduzir em outro aplicativo'),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoViewer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam,
            size: 64,
            color: Colors.purple[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Arquivo de vídeo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.savedFile.formattedFileSize} • ${widget.savedFile.fileExtension.toUpperCase()}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _openExternally,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Reproduzir em outro aplicativo'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentViewer() {
    if (widget.savedFile.fileExtension == 'txt' ||
        widget.savedFile.fileExtension == 'md') {
      return FutureBuilder<String>(
        future: File(widget.savedFile.localFilePath).readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro ao carregar arquivo: ${snapshot.error}'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              snapshot.data ?? '',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          );
        },
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description,
            size: 64,
            color: Colors.orange[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Documento',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.savedFile.formattedFileSize} • ${widget.savedFile.fileExtension.toUpperCase()}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _openExternally,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Abrir em outro aplicativo'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataViewer() {
    if (widget.savedFile.fileExtension == 'json') {
      return FutureBuilder<String>(
        future: File(widget.savedFile.localFilePath).readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro ao carregar arquivo: ${snapshot.error}'),
                ],
              ),
            );
          }

          try {
            final jsonData = snapshot.data ?? '';
            final prettyJson = const JsonEncoder.withIndent('  ').convert(
              json.decode(jsonData),
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                prettyJson,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            );
          } catch (e) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                snapshot.data ?? '',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            );
          }
        },
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.data_object,
            size: 64,
            color: Colors.teal[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Arquivo de dados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.savedFile.formattedFileSize} • ${widget.savedFile.fileExtension.toUpperCase()}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _openExternally,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Abrir em outro aplicativo'),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericFileViewer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_drive_file,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            widget.savedFile.fileTypeCategory,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.savedFile.formattedFileSize} • ${widget.savedFile.fileExtension.toUpperCase()}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _openExternally,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Abrir em outro aplicativo'),
          ),
        ],
      ),
    );
  }

  void _editDescription() {
    final controller = TextEditingController(text: _description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar descrição'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Adicione uma descrição para este arquivo...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newDescription = controller.text.trim();
              final success = await SavedFilesDatabase.updateFileDescription(
                widget.savedFile.id!,
                newDescription.isEmpty ? '' : newDescription,
              );

              if (success && mounted) {
                setState(() {
                  _description = newDescription.isEmpty ? null : newDescription;
                });
              }

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _shareFile() async {
    try {
      final file = File(widget.savedFile.localFilePath);
      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Gerado em ${widget.savedFile.spaceName}: ${widget.savedFile.originalFileName}',
          subject: 'Compartilhado pelo Gradio Spaces',
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Arquivo não encontrado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao compartilhar arquivo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openExternally() async {
    try {
      final file = File(widget.savedFile.localFilePath);
      if (await file.exists()) {
        final result = await OpenFilex.open(file.path);

        if (result.type != ResultType.done && mounted) {
          String message;
          switch (result.type) {
            case ResultType.noAppToOpen:
              message = 'Nenhum aplicativo disponível para abrir este tipo de arquivo';
              break;
            case ResultType.fileNotFound:
              message = 'Arquivo não encontrado';
              break;
            case ResultType.permissionDenied:
              message = 'Permissão negada para abrir o arquivo';
              break;
            default:
              message = 'Não foi possível abrir o arquivo: ${result.message}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Arquivo não encontrado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir arquivo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'open_externally':
        _openExternally();
        break;
      case 'delete':
        _showDeleteDialog();
        break;
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir arquivo'),
        content: Text(
          'Deseja excluir "${widget.savedFile.originalFileName}"? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              setState(() {
                _isLoading = true;
              });

              if (widget.savedFile.id != null) {
                await SavedFilesDatabase.deleteFile(widget.savedFile.id!);
              }

              await FileStorageService.deleteFile(widget.savedFile);

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Arquivo excluído: ${widget.savedFile.originalFileName}'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}