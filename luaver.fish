function luaver
    set -l luaver_load
    if which luaver > /dev/null
        set luaver_load ". luaver"
    else
        set luaver_load ". "(cd (dirname (status -f)); pwd)"/luaver"
    end

    set -l target_cmd "$luaver_load && luaver $argv"

    switch "$argv[1]"

    case 'install*'
        echo y\ny\nn\ny | bash -c "$target_cmd" | grep -iv switch

    case 'use*'
        set -l list (echo "$argv[1]" | sed -e s/use/list/)
        set -l list_cmd "$luaver_load && luaver $list"

        if not bash -c "$list_cmd" | grep -q "$argv[2]"
            set -l inst (echo "$argv[1]" | sed -e s/use/install/)
            echo "Cannot $argv: Run luaver $inst $argv[2]"
            return 1
        end

        set -x PATH (bash -c "$target_cmd"' 1>&2 && echo $PATH' | tr : \n)

    case load
        set -x PATH (bash -c "$luaver_load"' 1>&2 && echo $PATH' | tr : \n)

    case '*'
        bash -c $target_cmd

    end
end

luaver load
