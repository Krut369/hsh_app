import 'package:flutter/material.dart';

class NoteFormattingLogic {
  
  static TextEditingValue applyFormat(String type, TextEditingValue currentValue, {TextSelection? fallbackSelection}) {
    final text = currentValue.text;
    final selection = currentValue.selection.isValid && currentValue.selection.start >= 0
        ? currentValue.selection
        : (fallbackSelection ?? TextSelection.collapsed(offset: text.length));

    final start = selection.start;
    final end = selection.end;

    String newText = text;
    int newSelectionOffset = start;

    switch (type) {
      case 'bold':
        if (start == end) {
          newText = text.replaceRange(start, end, '****');
          newSelectionOffset = start + 2;
        } else {
          final selectedText = text.substring(start, end);
          newText = text.replaceRange(start, end, '**$selectedText**');
          newSelectionOffset = end + 4;
        }
        break;
      case 'italic':
        if (start == end) {
          newText = text.replaceRange(start, end, '__');
          newSelectionOffset = start + 1;
        } else {
          final selectedText = text.substring(start, end);
          newText = text.replaceRange(start, end, '_${selectedText}_');
          newSelectionOffset = end + 2;
        }
        break;
      case 'list':
        return _applyLinePrefix(currentValue, '- ');
      case 'numbered':
        int number = 1;

        // Smart calculation logic remains, but we want to apply it as a prefix replacement
        
        final text = currentValue.text;
        final selection = currentValue.selection.isValid && currentValue.selection.start >= 0
            ? currentValue.selection
            : (fallbackSelection ?? TextSelection.collapsed(offset: text.length));
        final start = selection.start;

        int searchEnd = start;
        if (start > 0 && text[start - 1] == '\n') {
            searchEnd = start - 1;
        }
        
        if (searchEnd > 0) {
            int prevLineEnd = searchEnd;
            int prevLineStart = text.lastIndexOf('\n', prevLineEnd - 1);
            if (prevLineStart == -1) {
                prevLineStart = 0;
            } else {
                prevLineStart += 1; 
            }
            
            String prevLine = text.substring(prevLineStart, prevLineEnd);
            final match = RegExp(r'^\s*(\d+)\.').firstMatch(prevLine);
            if (match != null) {
                number = int.parse(match.group(1)!) + 1;
            }
        }

        return _applyLinePrefix(currentValue, '$number. ');

      case 'quote':
        return _applyLinePrefix(currentValue, '> ');
      case 'checkbox':
        return _applyLinePrefix(currentValue, '- [ ] ');
      
      case 'title':
        return _applyLinePrefix(currentValue, '# ');
      case 'heading':
        return _applyLinePrefix(currentValue, '## ');
      case 'subheading':
        return _applyLinePrefix(currentValue, '### ');
      case 'body':
        return _removeLinePrefix(currentValue);
      
      case 'strikethrough':
        if (start == end) {
           newText = text.replaceRange(start, end, '~~~~');
           newSelectionOffset = start + 2;
        } else {
           final selected = text.substring(start, end);
           newText = text.replaceRange(start, end, '~~$selected~~');
           newSelectionOffset = end + 4;
        }
        break;
      
      case 'underline':
        if (start == end) {
           newText = text.replaceRange(start, end, '<u></u>');
           newSelectionOffset = start + 3;
        } else {
           final selected = text.substring(start, end);
           newText = text.replaceRange(start, end, '<u>$selected</u>');
           newSelectionOffset = end + 4;
        }
        break;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionOffset),
    );
  }

  static TextEditingValue _applyLinePrefix(TextEditingValue currentValue, String prefix) {
     // First remove any existing prefix to avoid conflicts (like ## - [ ])
     final cleanValue = _removeLinePrefix(currentValue);
     
     final text = cleanValue.text;
     final selection = cleanValue.selection;
     final cursorPosition = selection.baseOffset;

     // Find start of line
     int lineStart = text.lastIndexOf('\n', cursorPosition < text.length ? cursorPosition : cursorPosition - 1);
     if (lineStart == -1) {
       lineStart = 0;
     } else {
       lineStart += 1;
     }

     final newText = text.replaceRange(lineStart, lineStart, prefix);
     
     return TextEditingValue(
       text: newText,
       selection: TextSelection.collapsed(offset: cursorPosition + prefix.length),
     );
  }

  static TextEditingValue _removeLinePrefix(TextEditingValue currentValue) {
     final text = currentValue.text;
     final selection = currentValue.selection;
     final cursorPosition = selection.baseOffset;

     int lineStart = text.lastIndexOf('\n', cursorPosition < text.length ? cursorPosition : cursorPosition - 1);
     if (lineStart == -1) {
       lineStart = 0;
     } else {
       lineStart += 1;
     }

     // Regex to identify what to remove. 
     // Order matters: Checkbox is more specific than List, so checking it first or ensuring List doesn't eat Checkbox incorrectly
     // Actually, if we just want to clear *any* prefix, we can check for them.
     
     final RegExp headerPattern = RegExp(r'^#{1,6}\s+');
     final RegExp checkboxPattern = RegExp(r'^-\s\[( |x)\]\s+');
     final RegExp listPattern = RegExp(r'^-\s+');
     final RegExp numListPattern = RegExp(r'^\d+\.\s+');
     final RegExp quotePattern = RegExp(r'^>\s+');
     
     int lineEnd = text.indexOf('\n', lineStart);
     if (lineEnd == -1) lineEnd = text.length;
     
     final lineText = text.substring(lineStart, lineEnd);
     
     String newText = text;
     int newCursor = cursorPosition;

     // Check regexes
     Match? match;
     if ((match = headerPattern.firstMatch(lineText)) != null) {
       // match found
     } else if ((match = checkboxPattern.firstMatch(lineText)) != null) {
       // match found
     } else if ((match = listPattern.firstMatch(lineText)) != null) {
       // match found
     } else if ((match = numListPattern.firstMatch(lineText)) != null) {
       // match found
     } else if ((match = quotePattern.firstMatch(lineText)) != null) {
       // match found
     }

     if (match != null) {
       newText = text.replaceRange(lineStart, lineStart + match.group(0)!.length, '');
       newCursor -= match.group(0)!.length;
     }

     return TextEditingValue(
       text: newText,
       selection: TextSelection.collapsed(offset: newCursor < 0 ? 0 : newCursor),
     );
  }

  static TextEditingValue processAutoFormatting(TextEditingValue oldValue, TextEditingValue newValue) {
     // Text deleted or unchanged length -> ignore
     if (newValue.text.length <= oldValue.text.length) return newValue;
     
     // Check for newline insertion
     // Simple check: old text + \n == new text (at cursor)
     final selection = newValue.selection;
     if (!selection.isValid || selection.start <= 0) return newValue;
     
     final newChar = newValue.text[selection.start - 1];
     if (newChar != '\n') return newValue;

     // Get the line BEFORE the newline
     final text = newValue.text;
     final cursor = selection.start;
     
     // cursor is after \n. so prev char is \n. 
     // We want line before that.
     // prevLineEnd is cursor - 1 (the \n position)
     final prevLineEnd = cursor - 1;
     
     if (prevLineEnd <= 0) return newValue;

     final prevLineStartIdx = text.lastIndexOf('\n', prevLineEnd - 1);
     final prevLineStart = prevLineStartIdx == -1 ? 0 : prevLineStartIdx + 1;
     
     if (prevLineStart >= prevLineEnd) return newValue; // Empty line?
     
     final prevLine = text.substring(prevLineStart, prevLineEnd);
     
     // Check for Numbered List
     // Matches "1. Text" or "1. "
     final numMatch = RegExp(r'^(\d+)\.\s(.*)').firstMatch(prevLine);
     if (numMatch != null) {
        // Group 1 is number, Group 2 is content
        final content = numMatch.group(2) ?? '';
        
        if (content.trim().isEmpty) {
           // Empty item: User pressed enter on "1. " -> Remove "1. " and newline
           // Actually, standard behavior: remove "1. ", leaving just empty line(s) or just removing indentation
           // Let's replace the previous "1. \n" with "\n\n" or just "\n"
           
           // If we just want to stop the list, we remove the "1. " from previous line.
           // Replacing range from prevLineStart to cursor
           // prevLineStart ... prevLineEnd is "1. "
           // cursor is after \n
           
           // We want to replace "1. \n" with "\n" (effectively clearing the line)
           // Or usually, it clears the line but keeps the newline.
           
           final newText = text.replaceRange(prevLineStart, prevLineEnd, ''); 
           // Now text at prevLineStart is \n. 
           // Cursor should catch up.
           
           // Wait, easier logic:
           // If I am at "1. |" and press enter -> "1. \n|"
           // Result should be empty line: "\n|" (removing the 1.)
           
           return TextEditingValue(
             text: newText,
             selection: TextSelection.collapsed(offset: prevLineStart + 1),
           );
        } else {
           // Has content: User pressed enter on "1. Text" -> Add "2. "
           final number = int.parse(numMatch.group(1)!);
           final prefix = '${number + 1}. ';
           
           final newText = text.replaceRange(cursor, cursor, prefix);
           return TextEditingValue(
             text: newText,
             selection: TextSelection.collapsed(offset: cursor + prefix.length),
           );
        }
     }
     
     // Check for Bullet List
     final bulletMatch = RegExp(r'^-\s(.*)').firstMatch(prevLine);
     if (bulletMatch != null) {
         final content = bulletMatch.group(1) ?? '';
         
         if (content.trim().isEmpty) {
            // Empty bullet: User pressed enter on "- " -> Remove "- "
            final newText = text.replaceRange(prevLineStart, prevLineEnd, '');
            return TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: prevLineStart + 1),
            );
         } else {
            // Has content: Add another bullet
            final prefix = '- ';
            final newText = text.replaceRange(cursor, cursor, prefix);
            return TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: cursor + prefix.length),
            );
         }
     }
     
     // Check for Checkbox List
     final checkboxMatch = RegExp(r'^-\s\[( |x)\]\s(.*)').firstMatch(prevLine);
     if (checkboxMatch != null) {
         final content = checkboxMatch.group(2) ?? '';
         if (content.trim().isEmpty) {
             final newText = text.replaceRange(prevLineStart, prevLineEnd, '');
             return TextEditingValue(
               text: newText,
               selection: TextSelection.collapsed(offset: prevLineStart + 1),
             );
         } else {
             final prefix = '- [ ] ';
             final newText = text.replaceRange(cursor, cursor, prefix);
             return TextEditingValue(
               text: newText,
               selection: TextSelection.collapsed(offset: cursor + prefix.length),
             );
         }
     }
     
     return newValue;
  }
}
