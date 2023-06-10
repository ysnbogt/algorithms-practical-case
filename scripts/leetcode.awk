BEGIN {
    color["reset"] = "\033[0m";

    color["black"] = "\033[30m";
    color["red"] = "\033[31m";
    color["green"] = "\033[32m";
    color["yellow"] = "\033[33m";
    color["blue"] = "\033[34m";
    color["magenta"] = "\033[35m";
    color["cyan"] = "\033[36m";
    color["white"] = "\033[37m";
    color["gray"] = "\033[90m";

    color["brightBlack"] = "\033[30;1m";
    color["brightRed"] = "\033[31;1m";
    color["brightGreen"] = "\033[32;1m";
    color["brightYellow"] = "\033[33;1m";
    color["brightBlue"] = "\033[34;1m";
    color["brightMagenta"] = "\033[35;1m";
    color["brightCyan"] = "\033[36;1m";
    color["brightWhite"] = "\033[37;1m";

    color["bgBlack"] = "\033[40m";
    color["bgRed"] = "\033[41m";
    color["bgGreen"] = "\033[42m";
    color["bgYellow"] = "\033[43m";
    color["bgBlue"] = "\033[44m";
    color["bgMagenta"] = "\033[45m";
    color["bgCyan"] = "\033[46m";
    color["bgWhite"] = "\033[47m";

    color["bgBrightBlack"] = "\033[40;1m";
    color["bgBrightRed"] = "\033[41;1m";
    color["bgBrightGreen"] = "\033[42;1m";
    color["bgBrightYellow"] = "\033[43;1m";
    color["bgBrightBlue"] = "\033[44;1m";
    color["bgBrightMagenta"] = "\033[45;1m";
    color["bgBrightCyan"] = "\033[46;1m";
    color["bgBrightWhite"] = "\033[47;1m";

    color["bold"] = "\033[1m";
    color["underline"] = "\033[4m";
    color["blink"] = "\033[5m";
    color["reverse"] = "\033[7m";
    color["hidden"] = "\033[8m";

    base_url = "https://leetcode.com/problems/";
    flag = 0;
}

function url_encode(str) {
    gsub(/[?.,;\/:"'"'<>\[\]{}\\|=+)(*&^%$#@!~`]/, "", str);
    gsub(/ /, "-", str);
    gsub(/-+/, "-", str);
    gsub(/^-+|-+$/, "", str);
    return tolower(str);
}

/---/ && !flag {
    flag = 1;
    next;
}

/---/ && flag {
    flag = 0;
    next;
}

flag {
    split($0, arr, ":");

    key = arr[1];
    value = arr[2];

    gsub(/^[ \t]+|[ \t]+$/, "", key);
    gsub(/^[ \t]+|[ \t]+$/, "", value);

    data[tolower(key)] = tolower(value);
}

/^(\|[ \t]*Name[ \t]*\|)/ {
    header_end = NR;

    split($0, arr, "|");

    for (i = 2; i < length(arr); i++) {
        gsub(/^[ \t]+|[ \t]+$/, "", arr[i]);

        headers[i] = tolower(arr[i]);
    }

    headers[length(arr)] = "url";

    flag = 1;
}

/^\|/ {
    n = split($0, arr, "|");

    for (i = 2; i < n; i++) {
        cell = arr[i];

        gsub(/^[ \t]+|[ \t]+$/, "", cell);

        if (length(cell) > max_length[i]) {
            max_length[i] = length(cell);
        }

        row[NR,i] = cell;
    }

    if (flag == 0) {
        gsub(/^[ \t]+|[ \t]+$/, "", arr[2]);
        url = sprintf("%s%s", base_url, url_encode(arr[2]));
        row[NR,length(arr)] = url;

        if (length(url) > max_length[length(arr)]) {
            max_length[length(arr)] = length(url);
        }
    } else {
        row[NR,length(arr)] = "URL";
    }
}

END {
    printf("\n");
    for (r = 1; r <= NR; r++) {
        if (r == 1) {
            for (i = 2; i <= n; i++) {
                if (i == 2) {
                    printf("┌%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                } else {
                    printf("┬%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                }
            }
            print("┐");
        }
        if (r == header_end) {
            for (i = 2; i <= n; i++) {
                printf "│ %-*s ", max_length[i], row[r,i];
            }
            print("│");
            for (i = 2; i <= n; i++) {
                if (i == 2) {
                    printf("├%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                } else {
                    printf("┼%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                }
            }
            print("┤");
        } else if (r > header_end + 1) {
            for (i = 2; i <= n; i++) {
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
        if (r == NR) {
            for (i = 2; i <= n; i++) {
                if (i == 2) {
                    printf("└%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                } else {
                    printf("┴%-*s──", max_length[i], gensub(/./, "─", "g", sprintf("%-*s", max_length[i], "")));
                }
            }
            print("┘");
        }
    }
    printf(" %d rows\n", NR - header_end - 1);
    printf("\n");
}
