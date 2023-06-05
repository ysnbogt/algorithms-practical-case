# ╭─ Zsh ─────────────────────────────────────────────────────────────────────────────────────────╮
# ├───────────────────────────────────────────────────────────────────────────────────────────────┤
# │ $ brew install gawk                                                                           │
# ╰───────────────────────────────────────────────────────────────────────────────────────────────╯

# In FrontMatter, you can decorate tables, define decorations for an entire column, or specify
# decorations for specific values in a cell.

# ╭─ Markdown ─ README.md ────────────────────────────────────────────────────────────────────────╮
# ├───────────────────────────────────────────────────────────────────────────────────────────────┤
# │ ---                                                                                           │
# │ name: bold                                                                                    │
# │ url: blue                                                                                     │
# │ easy: green                                                                                   │
# │ medium: yellow                                                                                │
# │ hard: red                                                                                     │
# │ ---                                                                                           │
# │                                                                                               │
# │ | Name   | Difficulty | Language | URL                          |                             │
# │ | ------ | ---------- | -------- | ---------------------------- |                             │
# │ | First  | Easy       | Python   | https://.../problems/first/  |                             │
# │ | Second | Medium     | Python   | https://.../problems/second/ |                             │
# │ | Third  | Hard       | Python   | https://.../problems/third/  |                             │
# ╰───────────────────────────────────────────────────────────────────────────────────────────────╯

# ╭─ Zsh ─────────────────────────────────────────────────────────────────────────────────────────╮
# ├───────────────────────────────────────────────────────────────────────────────────────────────┤
# │ $ gawk -f main.awk README.md                                                                  │
# ╰───────────────────────────────────────────────────────────────────────────────────────────────╯

# The BEGIN block, executes before any input is read.
# It is used to initialize a list of ANSI escape codes for color in the console.
BEGIN {
    # Initialize ANSI color codes
    color["reset"] = "\033[0m";  # Reset all attributes

    # Basic Colors
    color["black"] = "\033[30m";
    color["red"] = "\033[31m";
    color["green"] = "\033[32m";
    color["yellow"] = "\033[33m";
    color["blue"] = "\033[34m";
    color["magenta"] = "\033[35m";
    color["cyan"] = "\033[36m";
    color["white"] = "\033[37m";

    # Bright Colors
    color["brightBlack"] = "\033[30;1m";
    color["brightRed"] = "\033[31;1m";
    color["brightGreen"] = "\033[32;1m";
    color["brightYellow"] = "\033[33;1m";
    color["brightBlue"] = "\033[34;1m";
    color["brightMagenta"] = "\033[35;1m";
    color["brightCyan"] = "\033[36;1m";
    color["brightWhite"] = "\033[37;1m";

    # Background Colors
    color["bgBlack"] = "\033[40m";
    color["bgRed"] = "\033[41m";
    color["bgGreen"] = "\033[42m";
    color["bgYellow"] = "\033[43m";
    color["bgBlue"] = "\033[44m";
    color["bgMagenta"] = "\033[45m";
    color["bgCyan"] = "\033[46m";
    color["bgWhite"] = "\033[47m";

    # Bright Background Colors
    color["bgBrightBlack"] = "\033[40;1m";
    color["bgBrightRed"] = "\033[41;1m";
    color["bgBrightGreen"] = "\033[42;1m";
    color["bgBrightYellow"] = "\033[43;1m";
    color["bgBrightBlue"] = "\033[44;1m";
    color["bgBrightMagenta"] = "\033[45;1m";
    color["bgBrightCyan"] = "\033[46;1m";
    color["bgBrightWhite"] = "\033[47;1m";

    # Decorations
    color["bold"] = "\033[1m";
    color["underline"] = "\033[4m";
    color["blink"] = "\033[5m";
    color["reverse"] = "\033[7m";
    color["hidden"] = "\033[8m";
}

# This block handles '---' separators. It's using a flag to indicate if we are 
# inside a section enclosed by '---' separators.
/---/ && !flag {
    # Set a flag when the first '---' separator is encountered
    flag = 1;
    next;
}

/---/ && flag {
    # Clear the flag when the next '---' separator is encountered
    flag = 0;
    next;
}

# This block is for processing lines between '---' separators. This is where
# color configurations are defined.
flag {
    # Split each line into key:value pairs
    split($0, arr, ":");

    # Extract the key and the value from the array
    key = arr[1];
    value = arr[2];

    # Remove leading/trailing spaces from key and value
    gsub(/^[ \t]+|[ \t]+$/, "", key);
    gsub(/^[ \t]+|[ \t]+$/, "", value);

    # Convert key and value to lower case and add them to 'data' array
    data[tolower(key)] = tolower(value);
}

# This block processes lines beginning with '|Name'
# It is used to parse the table headers.
/^(\|[ \t]*Name[ \t]*\|)/ {
    # Record the line number of the end of the header
    header_end = NR;

    # Split the header line into its cells
    split($0, arr, "|");

    # For each cell in the header
    for (i = 2; i < length(arr); i++) {
        # Remove leading/trailing spaces from the cell
        gsub(/^[ \t]+|[ \t]+$/, "", arr[i]);

        # Add the cell to the 'headers' array
        headers[i] = tolower(arr[i]);
    }
}

# This block processes lines beginning with '|'.
# It is used to parse the table data.
/^\|/ {
    # Split each line into its cells
    n = split($0, arr, "|");

    # For each cell
    for (i = 2; i < n; i++) {
        # Extract the cell content
        cell = arr[i];

        # Remove leading/trailing spaces from the cell
        gsub(/^[ \t]+|[ \t]+$/, "", cell);

        # Update the maximum cell length for this column if necessary
        if (length(cell) > max_length[i]) {
            max_length[i] = length(cell);
        }

        # Add the cell to the 'row' array
        row[NR,i] = cell;
    }
}

# The END block, executes after all input is read.
# It is used to print the final formatted output.
END {
    printf("\n");
    # Loop over each row
    for (r = 1; r <= NR; r++) {
        # If current row is the top border row
        if (r == 1) {
            # Print the top border row
            for (i = 2; i < n; i++) {
                if (i == 2) {
                    printf("┌%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                } else {
                    printf("┬%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                }
            }
            print("┐");
        }
        # If current row is the header row
        if (r == header_end) {
            # Print the header row and a row of dashes
            for (i = 2; i < n; i++) {
                printf "│ %-*s ", max_length[i], row[r,i];
            }
            print("│");
            for (i = 2; i < n; i++) {
                if (i == 2) {
                    printf("├%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                } else {
                    printf("┼%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                }
            }
            print("┤");
        # If current row is a data row
        } else if (r > header_end + 1) {
            # Print the data row with color coding
            for (i = 2; i < n; i++) {
                cell = row[r,i];
                lower_cell = tolower(cell);
                if (data[headers[i]] != "" && cell != "") {
                    color_code = color[data[headers[i]]];
                } else if (data[lower_cell] != "" && cell != "") {
                    color_code = color[data[lower_cell]];
                } else {
                    color_code = color["reset"];
                }
                printf "│ %s%-*s%s ", color_code, max_length[i], cell, color["reset"];
            }
            print("│");
        }
        # If current row is the last row
        if (r == NR) {
            # Print a row of dashes
            for (i = 2; i < n; i++) {
                if (i == 2) {
                    printf("└%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                } else {
                    printf("┴%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                }
            }
            print("┘");
        }
    }
    printf("\n");
}
