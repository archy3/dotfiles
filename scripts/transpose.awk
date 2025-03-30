#!/usr/bin/awk -f

# Note that tabs in the input are treated as occupying a
# single character cell on the terminal screen, and tabs will
# remain as tabs (they will not be expanded to spaces) in the
# output (though tabs and spaces that would result in trailing
# whitespace in the output will be stripped unless the
# argument sequence `-v trim=false` is supplied).

# If the argument sequence `-v trim=false` is supplied, then
# the output will be right-padded with spaces to form a
# perfect rectangular grid of output (where tabs in the output
# are also treated as occupying just a single character cell).

BEGIN {
    longest_line_length = 0
    trim = (trim == "false" ? 0 : 1)
}

{
    lines[NR] = $0
    line_length = length($0)

    if (line_length > longest_line_length) {
        longest_line_length = line_length
    }
}

END {
    # Right-pad lines with spaces:
    for (i = 1; i <= NR; i++) {
        lines[i] = sprintf("%-" longest_line_length "s", lines[i])
    }

    # Place characters into matrix:
    for (i = 1; i <= NR; i++) {
        for (j = 1; j <= longest_line_length; j++) {
            matrix[i "," j] = substr(lines[i], j, 1)
        }
    }

    # Print transpose of matrix:
    for (j = 1; j <= longest_line_length; j++) {
        row_of_transpose = ""
        for (i = 1; i <= NR; i++) {
            row_of_transpose = row_of_transpose matrix[i "," j]
        }

        # Strip trailing whitespace (unless not desired):
        if (trim) {
            sub("[ \t]+$", "", row_of_transpose)
        }

        # Print row:
        printf "%s\n", row_of_transpose
    }
}
