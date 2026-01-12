import 'package:flutter/material.dart';
import 'package:hsh_app/core/theme/app_colors.dart';

class MarkdownSyntaxController extends TextEditingController {
  MarkdownSyntaxController({super.text});

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
    final TextStyle boldStyle = baseStyle.copyWith(fontWeight: FontWeight.w700);
    final TextStyle italicStyle = baseStyle.copyWith(fontStyle: FontStyle.italic);
    
    // Faint syntax style
    // Faint syntax style - Made darker for visibility
    final TextStyle syntaxStyle = baseStyle.copyWith(
      color: Colors.grey[400], 
      fontSize: (baseStyle.fontSize ?? 16) * 0.9,
    );

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

    // Regex for Bold, Italic, Headline, List, Quote
    // Note: Order matters.
    final RegExp pattern = RegExp(
      r'(^#{1,6}\s+.+$)|' // Headline 
      r'(^\s*>\s+.+$)|' // Blockquote
      r'(\*\*.+?\*\*)|' // Bold
      r'(__(?!_).+?__)|' // Bold alt
      r'(_(?!_).+?_)|' // Italic
      r'(~~.+?~~)|' // Strikethrough
      r'(<u>.+?</u>)|' // Underline
      r'(^\s*-\s+.*$)|' // List item (relaxed)
      r'(^\s*\d+\.\s+.*$)', // Numbered List item (relaxed)
      multiLine: true,
    ); 
    
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
      
      if (fullMatch.startsWith('#')) {
         // Headline
         // Style the hash marks faintly, content boldly
         final matchStr = fullMatch.trimRight();
         final spaceIndex = matchStr.indexOf(' ');
         
         if (spaceIndex != -1) {
            // Hashes
            children.add(TextSpan(text: matchStr.substring(0, spaceIndex), style: syntaxStyle));
            // Content
            double fontSize = 24.0;
            if (matchStr.startsWith('## ')) fontSize = 22.0;
            if (matchStr.startsWith('### ')) fontSize = 20.0;
            
            children.add(TextSpan(text: matchStr.substring(spaceIndex), style: baseStyle.copyWith(
               fontWeight: FontWeight.bold,
               fontSize: fontSize,
               color: Colors.black, 
               height: 1.3
            )));
         } else {
            children.add(TextSpan(text: fullMatch, style: baseStyle));
         }

      } else if (fullMatch.trim().startsWith('> ')) {
         // Blockquote
         children.add(TextSpan(text: '> ', style: syntaxStyle.copyWith(color: Colors.amber, fontWeight: FontWeight.bold)));
         children.add(TextSpan(text: fullMatch.substring(2), style: baseStyle.copyWith(
           color: Colors.grey[700],
           fontStyle: FontStyle.italic,
           backgroundColor: Colors.grey[50],
         )));

      } else if (fullMatch.trim().startsWith('- ')) {
         // List Item
         // Hide the dash, show a bullet point
         // We make the dash transparent/zero-width effectively by strictly controlling the TextSpan
         
         // Visual replacement: Render '• ' instead of '- '
         children.add(TextSpan(text: '• ', style: syntaxStyle.copyWith(
             fontWeight: FontWeight.bold, 
             color: AppColors.primary, 
             fontSize: baseStyle.fontSize
         )));
         children.add(TextSpan(text: fullMatch.substring(2), style: baseStyle.copyWith(
           height: 1.5,
         )));

      } else if (RegExp(r'^\s*\d+\.').hasMatch(fullMatch)) {
         // Numbered List
         final dotIndex = fullMatch.indexOf('.');
         children.add(TextSpan(text: fullMatch.substring(0, dotIndex + 1), style: syntaxStyle.copyWith(
             fontWeight: FontWeight.bold, 
             color: AppColors.primary, // Primary color for number
             fontSize: baseStyle.fontSize
         )));
         children.add(TextSpan(text: fullMatch.substring(dotIndex + 1), style: baseStyle.copyWith(
           height: 1.5,
         )));

      } else if (fullMatch.startsWith('**') && fullMatch.endsWith('**') && fullMatch.length >= 4) {
        // Bold
        children.add(TextSpan(text: '**', style: syntaxStyle));
        children.add(TextSpan(text: fullMatch.substring(2, fullMatch.length - 2), style: boldStyle));
        children.add(TextSpan(text: '**', style: syntaxStyle));
      } else if (fullMatch.startsWith('_') && fullMatch.endsWith('_') && fullMatch.length >= 2) {
         // Italic
        children.add(TextSpan(text: '_', style: syntaxStyle));
        children.add(TextSpan(text: fullMatch.substring(1, fullMatch.length - 1), style: italicStyle));
        children.add(TextSpan(text: '_', style: syntaxStyle));
      } else if (fullMatch.startsWith('~~') && fullMatch.endsWith('~~') && fullMatch.length >= 4) {
         // Strikethrough
        children.add(TextSpan(text: '~~', style: syntaxStyle));
        children.add(TextSpan(text: fullMatch.substring(2, fullMatch.length - 2), style: baseStyle.copyWith(decoration: TextDecoration.lineThrough)));
        children.add(TextSpan(text: '~~', style: syntaxStyle)); 
      } else if (fullMatch.startsWith('<u>') && fullMatch.endsWith('</u>') && fullMatch.length >= 7) {
         // Underline
        children.add(TextSpan(text: '<u>', style: syntaxStyle));
        children.add(TextSpan(text: fullMatch.substring(3, fullMatch.length - 4), style: baseStyle.copyWith(decoration: TextDecoration.underline)));
        children.add(TextSpan(text: '</u>', style: syntaxStyle));
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
