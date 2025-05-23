import sys
import re

# ANSI escape sequences
ESC = "\033["

# Colors
RED_FG = f"{ESC}31m"
GREEN_FG = f"{ESC}32m"
YELLOW_FG = f"{ESC}33m"
CYAN_FG = f"{ESC}36m"  # For .: and ] in original mode
GRAY_FG = f"{ESC}90m"  # For digits in original mode
RESET_ALL = f"{ESC}0m"

mode = None
if len(sys.argv) > 1 and sys.argv[1].lower() == "cut":
    mode = "cut"

for line_in_script in sys.stdin:
    original_line = line_in_script.rstrip("\n")
    
    if not original_line:
        sys.stdout.write("\n")
        sys.stdout.flush()
        continue

    # New check: if not starting with I, W, E AND no ']' present, print as is
    first_char_for_check = original_line[0] # Safe as original_line is not empty here
    is_iwe_start = first_char_for_check in ('I', 'W', 'E')
    contains_bracket = ']' in original_line

    if not is_iwe_start or not contains_bracket:
        sys.stdout.write(original_line + "\n")
        sys.stdout.flush()
        continue
    # End of new check

    output_parts = []
    first_char_original = first_char_for_check # Reuse the already obtained first char
    
    # Determine colored first character (common for both modes)
    colored_first_char_part = ""
    if first_char_original == 'I':
        colored_first_char_part = f"{GREEN_FG}I{RESET_ALL}"
    elif first_char_original == 'W':
        colored_first_char_part = f"{YELLOW_FG}W{RESET_ALL}"
    elif first_char_original == 'E':
        colored_first_char_part = f"{RED_FG}E{RESET_ALL}"
    else:
        colored_first_char_part = first_char_original # Default color

    if mode == "cut":
        output_parts.append(colored_first_char_part)
        
        line_after_first_char = original_line[1:] if len(original_line) > 1 else ""
        bracket_pos_cut = line_after_first_char.find(']')

        if bracket_pos_cut != -1:
            # Content after ']'
            message_part = line_after_first_char[bracket_pos_cut+1:].lstrip()
            output_parts.append(f": {message_part}") # Colon and space will be default terminal color
        else:
            # No ']', so just add ": " and the rest of the line (after first char), lstripped
            output_parts.append(f": {line_after_first_char.lstrip()}")
    else:
        # Original logic
        output_parts.append(colored_first_char_part)
        
        rest_of_line_orig_logic = original_line[1:] if len(original_line) > 1 else ""
        bracket_pos_orig_logic = rest_of_line_orig_logic.find("]")

        if bracket_pos_orig_logic != -1:
            text_before_bracket = rest_of_line_orig_logic[:bracket_pos_orig_logic]
            text_after_bracket_content = rest_of_line_orig_logic[bracket_pos_orig_logic+1:]

            # Apply GRAY to digits in 'text_before_bracket'
            processed_text_before_bracket = re.sub(r"(\d+)", f"{GRAY_FG}\\1{RESET_ALL}", text_before_bracket)
            # Then apply CYAN to .: in the (potentially already modified) 'text_before_bracket'
            processed_text_before_bracket_final = re.sub(r"([.:]+)", f"{CYAN_FG}\\1{RESET_ALL}", processed_text_before_bracket)
            
            output_parts.append(processed_text_before_bracket_final)
            output_parts.append(f"{CYAN_FG}]{RESET_ALL}") # ] itself is CYAN
            output_parts.append(text_after_bracket_content)
        else: # No ']' in original mode
            output_parts.append(rest_of_line_orig_logic)
            
    sys.stdout.write("".join(output_parts) + "\n")
    sys.stdout.flush()
