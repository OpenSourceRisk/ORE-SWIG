#!/bin/sh
status = 0
for file in *.py; do
    if [ -f "$file" ]; then
        echo RUN $file
        python3 "$file" || status = 1
        return_code = $?
        if [$return_code -gt $status]; then
                status = $return_code
        fi
    fi
done
exit $status
