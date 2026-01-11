import 'package:flutter/material.dart';

class MarkdownSyntaxController extends TextEditingController {
  MarkdownSyntaxController({String? text}) : super(text: text);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> children = [];
    final String text = value.text;

    // Define styles
    final TextStyle baseStyle = style ?? const TextStyle();
    final TextStyle boldStyle = baseStyle.copyWith(fontWeight: FontWeight.bold);
    final TextStyle italicStyle = baseStyle.copyWith(fontStyle: FontStyle.italic);
    final TextStyle syntaxStyle = baseStyle.copyWith(color: Colors.grey); // For the ** or _ characters

    // This is a simplified parser. For production, a more robust parser is recommended.
    // It currently handles **bold** and _italic_ separately and doesn't nest deeply.
    
    // Regex explanation:
    // ((\*\*)(.*?)(\*\*)) -> Matches **text** (Group 1: full, 2: **, 3: content, 4: **)
    // ((_)(.*?)(_)) -> Matches _text_ (Group 5: full, 6: _, 7: content, 8: _)
    // We split by these patterns. 
    
    // Actually, split map is easier if we just iterate.
    // But for a quick "Apple Notes" feel with just these two, regex split is okay.
    // Since Flutter's TextEditingController expects a single TextSpan tree, 
    // we need to construct it carefully.

    // Better approach: Use pattern matching and loop
    // Note: This simple regex might conflict if nesting is attempted (e.g. **_text_**). 
    // We will prioritize Bold, then Italic.

    final RegExp pattern = RegExp(r'(\*\*.+?\*\*)|(__(?!_).+?__)|(_(?!_).+?_)'); 
    
    // Logic: 
    // **...** for Bold
    // __...__ or _..._ for Italic (Common markdown uses * or _ for italic, ** or __ for bold)
    // Here we support **bold**, __bold__?, and _italic_. 
    // Let's stick to **bold** and _italic_ as per our inserter.

    int currentIndex = 0;
    
    pattern.allMatches(text).forEach((match) {
      // Add text before match
      if (match.start > currentIndex) {
        children.add(TextSpan(text: text.substring(currentIndex, match.start), style: baseStyle));
      }

      final String fullMatch = match.group(0)!;
      
      if (fullMatch.startsWith('**') && fullMatch.endsWith('**') && fullMatch.length >= 4) {
        // Bold
        children.add(TextSpan(text: '**', style: syntaxStyle));
        children.add(TextSpan(text: fullMatch.substring(2, fullMatch.length - 2), style: boldStyle));
        children.add(TextSpan(text: '**', style: syntaxStyle));
      } else if (fullMatch.startsWith('_') && fullMatch.endsWith('_') && fullMatch.length >= 2) {
         // Italic
        children.add(TextSpan(text: '_', style: syntaxStyle));
        children.add(TextSpan(text: fullMatch.substring(1, fullMatch.length - 1), style: italicStyle));
        children.add(TextSpan(text: '_', style: syntaxStyle));
      } else {
        // Fallback
         children.add(TextSpan(text: fullMatch, style: baseStyle));
      }

      currentIndex = match.end;
    });

    // Add remaining text
    if (currentIndex < text.length) {
      children.add(TextSpan(text: text.substring(currentIndex), style: baseStyle));
    }

    return TextSpan(style: baseStyle, children: children);
  }
}
