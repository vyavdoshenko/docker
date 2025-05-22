import sys
import re

# ANSI escape sequences
ESC = "\033["

# Colors
RED_FG = f"{ESC}31m"
GREEN_FG = f"{ESC}32m"
YELLOW_FG = f"{ESC}33m"
CYAN_FG = f"{ESC}36m"
GRAY_FG = f"{ESC}90m"
RESET_ALL = f"{ESC}0m"

for line in sys.stdin:
    original_line = line.rstrip("\n")
    output_parts = []

    first_char_original = original_line[0] if original_line else ""
    rest_of_line = original_line[1:] if original_line else ""

    if first_char_original == "E":
        output_parts.append(f"{RED_FG}E{RESET_ALL}")
    elif first_char_original == "W":
        output_parts.append(f"{YELLOW_FG}W{RESET_ALL}")
    elif first_char_original == "I":
        output_parts.append(f"{GREEN_FG}I{RESET_ALL}")
    else:
        if first_char_original:
            output_parts.append(first_char_original)
    
    current_text_to_process = rest_of_line
    
    bracket_pos = current_text_to_process.find("]")

    if bracket_pos != -1:
        text_before_bracket = current_text_to_process[:bracket_pos]
        text_after_bracket = current_text_to_process[bracket_pos+1:]

        processed_text_before_bracket = re.sub(r"(\d+)", f"{CYAN_FG}\\1{RESET_ALL}", text_before_bracket)
        processed_text_before_bracket = re.sub(r"\.", f"{GRAY_FG}.{RESET_ALL}", processed_text_before_bracket)
        processed_text_before_bracket = re.sub(r":", f"{GRAY_FG}:{RESET_ALL}", processed_text_before_bracket)
        
        output_parts.append(processed_text_before_bracket)
        output_parts.append(f"{GRAY_FG}]{RESET_ALL}")
        output_parts.append(text_after_bracket)
    else:
        output_parts.append(current_text_to_process)
            
    sys.stdout.write("".join(output_parts) + "\n")
    sys.stdout.flush() 