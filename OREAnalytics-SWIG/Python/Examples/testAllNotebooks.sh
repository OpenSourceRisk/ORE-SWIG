#!/bin/sh
status=0
return_code=0
for dir in $(find ./Notebooks -type d); do
    # Loop over all ipynb files in the current subdirectory
    for file in "$dir"/*.ipynb; do
        # Run nbconvert on the current ipynb file
        if test -f "$file"; then
            jupyter nbconvert --execute "$file" --to notebook --output-dir=./tmp
            return_code=$?
            if [ $return_code -gt $status ]; then
                    status=$return_code
            fi
        fi
    done
done
exit $status