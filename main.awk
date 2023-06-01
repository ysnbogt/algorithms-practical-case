BEGIN {
    color["bold"] = "\033[1m";
    color["red"] = "\033[31m";
    color["green"] = "\033[32m";
    color["yellow"] = "\033[33m";
    color["blue"] = "\033[34m";
    color["reset"] = "\033[0m";
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
}

END {
    for (r = 1; r <= NR; r++) {
        if (r == header_end) {
            for (i = 2; i < n; i++) {
                printf "| %-*s ", max_length[i], row[r,i];
            }
            print "|";
            for (i = 2; i < n; i++) {
                printf("| %-*s ", max_length[i], gensub(/./, "-", "g", sprintf("%-*s", max_length[i], "")));
            }
            print "|";
        } else if (r > header_end) {
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
                printf "| %s%-*s%s ", color_code, max_length[i], cell, color["reset"];
            }
            print "|";
        }
    }
}
