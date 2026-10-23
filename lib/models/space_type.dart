import 'package:flutter/material.dart';

class SpaceType {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final List<String> matchingTags;
  final String color;
  final String? semanticCategory;

  const SpaceType({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.matchingTags,
    required this.color,
    this.semanticCategory,
  });

  static const List<SpaceType> spaceTypes = [
    SpaceType(
      id: 'image-generation',
      name: 'Geração de imagens',
      description: 'Crie imagens a partir de descrições',
      icon: Icons.image,
      matchingTags: [],
      color: '#FF6B6B',
      semanticCategory: 'image-generation',
    ),
    SpaceType(
      id: 'video-generation',
      name: 'Geração de vídeos',
      description: 'Crie e edite vídeos com IA',
      icon: Icons.videocam,
      matchingTags: [],
      color: '#9B59B6',
      semanticCategory: 'video-generation',
    ),
    SpaceType(
      id: 'text-generation',
      name: 'Geração de texto',
      description: 'Gere textos com modelos de linguagem',
      icon: Icons.text_fields,
      matchingTags: [],
      color: '#3498DB',
      semanticCategory: 'text-generation',
    ),
    SpaceType(
      id: 'language-translation',
      name: 'Tradução de idiomas',
      description: 'Traduza entre idiomas',
      icon: Icons.translate,
      matchingTags: [],
      color: '#27AE60',
      semanticCategory: 'language-translation',
    ),
    SpaceType(
      id: 'speech-synthesis',
      name: 'Síntese de voz',
      description: 'Converta texto em fala e gere vozes',
      icon: Icons.record_voice_over,
      matchingTags: [],
      color: '#E74C3C',
      semanticCategory: 'speech-synthesis',
    ),
    SpaceType(
      id: '3d-modeling',
      name: 'Modelagem 3D',
      description: 'Gere e manipule modelos 3D',
      icon: Icons.view_in_ar,
      matchingTags: [],
      color: '#F39C12',
      semanticCategory: '3d-modeling',
    ),
    SpaceType(
      id: 'object-detection',
      name: 'Detecção de objetos',
      description: 'Detecte e identifique objetos em imagens',
      icon: Icons.search,
      matchingTags: [],
      color: '#16A085',
      semanticCategory: 'object-detection',
    ),
    SpaceType(
      id: 'text-analysis',
      name: 'Análise de texto',
      description: 'Analise e compreenda textos',
      icon: Icons.analytics,
      matchingTags: [],
      color: '#8E44AD',
      semanticCategory: 'text-analysis',
    ),
    SpaceType(
      id: 'image-editing',
      name: 'Edição de imagens',
      description: 'Edite e manipule imagens',
      icon: Icons.edit,
      matchingTags: [],
      color: '#E67E22',
      semanticCategory: 'image-editing',
    ),
    SpaceType(
      id: 'code-generation',
      name: 'Geração de código',
      description: 'Gere código e obtenha ajuda para programar',
      icon: Icons.code,
      matchingTags: [],
      color: '#2C3E50',
      semanticCategory: 'code-generation',
    ),
    SpaceType(
      id: 'question-answering',
      name: 'Perguntas e respostas',
      description: 'Responda a perguntas a partir de textos',
      icon: Icons.help_outline,
      matchingTags: [],
      color: '#34495E',
      semanticCategory: 'question-answering',
    ),
    SpaceType(
      id: 'data-visualization',
      name: 'Visualização de dados',
      description: 'Visualize e explore dados',
      icon: Icons.bar_chart,
      matchingTags: [],
      color: '#1ABC9C',
      semanticCategory: 'data-visualization',
    ),
    SpaceType(
      id: 'voice-cloning',
      name: 'Clonagem de voz',
      description: 'Clone e sintetize vozes',
      icon: Icons.mic,
      matchingTags: [],
      color: '#F1C40F',
      semanticCategory: 'voice-cloning',
    ),
    SpaceType(
      id: 'background-removal',
      name: 'Remoção de fundo',
      description: 'Remova o fundo de imagens',
      icon: Icons.layers,
      matchingTags: [],
      color: '#95A5A6',
      semanticCategory: 'background-removal',
    ),
    SpaceType(
      id: 'image-upscaling',
      name: 'Ampliação de imagens',
      description: 'Melhore e amplie imagens',
      icon: Icons.zoom_in,
      matchingTags: [],
      color: '#D35400',
      semanticCategory: 'image-upscaling',
    ),
    SpaceType(
      id: 'ocr',
      name: 'OCR',
      description: 'Extraia texto de imagens',
      icon: Icons.text_snippet,
      matchingTags: [],
      color: '#7F8C8D',
      semanticCategory: 'ocr',
    ),
    SpaceType(
      id: 'chatbots',
      name: 'Assistentes de conversa',
      description: 'Converse com assistentes de IA',
      icon: Icons.chat,
      matchingTags: [],
      color: '#E91E63',
      semanticCategory: 'chatbots',
    ),
    SpaceType(
      id: 'music-generation',
      name: 'Geração de música',
      description: 'Gere e componha músicas',
      icon: Icons.music_note,
      matchingTags: [],
      color: '#9C27B0',
      semanticCategory: 'music-generation',
    ),
    SpaceType(
      id: 'style-transfer',
      name: 'Transferência de estilo',
      description: 'Aplique estilos artísticos a imagens',
      icon: Icons.palette,
      matchingTags: [],
      color: '#673AB7',
      semanticCategory: 'style-transfer',
    ),
    SpaceType(
      id: 'face-recognition',
      name: 'Reconhecimento facial',
      description: 'Reconheça e analise rostos',
      icon: Icons.face,
      matchingTags: [],
      color: '#FF5722',
      semanticCategory: 'face-recognition',
    ),
    SpaceType(
      id: 'audio-processing',
      name: 'Processamento de áudio',
      description: 'Processe e manipule áudio',
      icon: Icons.audio_file,
      matchingTags: [],
      color: '#00BCD4',
      semanticCategory: 'music-generation',
    ),
    SpaceType(
      id: 'image-classification',
      name: 'Classificação de imagens',
      description: 'Classifique e categorize imagens',
      icon: Icons.category,
      matchingTags: [],
      color: '#4CAF50',
      semanticCategory: 'image',
    ),
    SpaceType(
      id: 'summarization',
      name: 'Resumo',
      description: 'Resuma textos e documentos',
      icon: Icons.summarize,
      matchingTags: [],
      color: '#FF9800',
      semanticCategory: 'text-summarization',
    ),
    SpaceType(
      id: 'speech-recognition',
      name: 'Reconhecimento de fala',
      description: 'Converta fala em texto',
      icon: Icons.keyboard_voice,
      matchingTags: [],
      color: '#03A9F4',
      semanticCategory: 'speech-synthesis',
    ),
    SpaceType(
      id: 'video-editing',
      name: 'Edição de vídeos',
      description: 'Edite e melhore vídeos',
      icon: Icons.movie_edit,
      matchingTags: [],
      color: '#673AB7',
      semanticCategory: 'video-generation',
    ),
    SpaceType(
      id: 'depth-estimation',
      name: 'Estimativa de profundidade',
      description: 'Estime a profundidade em imagens',
      icon: Icons.layers_outlined,
      matchingTags: [],
      color: '#607D8B',
      semanticCategory: 'image',
    ),
    SpaceType(
      id: 'pose-estimation',
      name: 'Estimativa de pose',
      description: 'Detecte poses e pontos do corpo humano',
      icon: Icons.accessibility_new,
      matchingTags: [],
      color: '#009688',
      semanticCategory: 'pose-estimation',
    ),
    SpaceType(
      id: 'segmentation',
      name: 'Segmentação de imagens',
      description: 'Segmente e crie máscaras em imagens',
      icon: Icons.auto_awesome_mosaic,
      matchingTags: [],
      color: '#795548',
      semanticCategory: 'image',
    ),
    SpaceType(
      id: 'image-to-text',
      name: 'Imagem para texto',
      description: 'Gere descrições de imagens',
      icon: Icons.image_search,
      matchingTags: [],
      color: '#FF4081',
      semanticCategory: 'image-captioning',
    ),
    SpaceType(
      id: 'text-to-3d',
      name: 'Texto para 3D',
      description: 'Gere modelos 3D a partir de textos',
      icon: Icons.threed_rotation,
      matchingTags: [],
      color: '#CDDC39',
      semanticCategory: '3d-modeling',
    ),
    SpaceType(
      id: 'image-to-video',
      name: 'Imagem para vídeo',
      description: 'Anime imagens para criar vídeos',
      icon: Icons.play_circle_outline,
      matchingTags: [],
      color: '#FFC107',
      semanticCategory: 'video-generation',
    ),
    SpaceType(
      id: 'document-qa',
      name: 'Perguntas sobre documentos',
      description: 'Responda a perguntas sobre documentos',
      icon: Icons.description,
      matchingTags: [],
      color: '#5C6BC0',
      semanticCategory: 'document-analysis',
    ),
    SpaceType(
      id: 'gaming',
      name: 'Jogos e aprendizado por reforço',
      description: 'Explore jogos e aprendizado por reforço',
      icon: Icons.sports_esports,
      matchingTags: [],
      color: '#EC407A',
      semanticCategory: 'game-ai',
    ),
    SpaceType(
      id: 'restoration',
      name: 'Restauração de imagens',
      description: 'Restaure e repare imagens danificadas',
      icon: Icons.auto_fix_high,
      matchingTags: [],
      color: '#AB47BC',
      semanticCategory: 'image',
    ),
    SpaceType(
      id: 'motion-capture',
      name: 'Captura de movimento',
      description: 'Capture e analise movimentos',
      icon: Icons.directions_run,
      matchingTags: [],
      color: '#26A69A',
      semanticCategory: 'character-animation',
    ),
    SpaceType(
      id: 'avatar-generation',
      name: 'Geração de avatares',
      description: 'Gere e personalize avatares',
      icon: Icons.person_outline,
      matchingTags: [],
      color: '#EF5350',
      semanticCategory: 'character-animation',
    ),
  ];

  static SpaceType? getSpaceTypeForTags(List<String> tags, {String? title, String? description}) {
    final allText = [
      ...tags,
      if (title != null) title,
      if (description != null) description,
    ].join(' ').toLowerCase();

    Map<SpaceType, int> scores = {};

    for (final spaceType in spaceTypes) {
      int score = 0;

      for (final tag in tags) {
        for (final matchingTag in spaceType.matchingTags) {
          if (tag.toLowerCase().contains(matchingTag.toLowerCase()) ||
              matchingTag.toLowerCase().contains(tag.toLowerCase())) {
            score += 3;
          }
        }
      }

      for (final matchingTag in spaceType.matchingTags) {
        if (allText.contains(matchingTag.toLowerCase())) {
          score += 1;
        }
      }

      if (score > 0) {
        scores[spaceType] = score;
      }
    }

    if (scores.isEmpty) return null;

    final sortedEntries = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.first.key;
  }
}