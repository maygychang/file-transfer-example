#!/bin/bash
image_name="test-file"
docker_name="test-file"
docker_file="Dockerfile"
api_port=8080

show_usage()
{
    cat << __EOF__
    Usage:
    Requirement:
        [-b] # Build A new $image_name image
        [-l] # Login image_name container
        [-r] # Relogin $docker_name container
        [-s] # Stop $docker_name container
__EOF__
  exit 1
}

if [ "$#" -eq "0" ]; then
    show_usage
    exit
fi

while getopts 'blrs' o; do
    case "${o}" in
        b)
            check_build_image="y"
            ;;
        l)
            check_login_image="y"
            ;;
        r)
            check_relogin_container="y"
            ;;
        s)
            check_stop_container="y"
            ;;
        *)
            /bin/echo -e "Warning! wrong paramter."
            show_usage
            ;;
    esac
done

remove_image()
{
    /bin/echo -e "\n=== Remove $image_name Image ===\n"
    docker rmi -f $image_name
}

remove_container()
{
    /bin/echo -e "\n=== Remove $docker_name Container ===\n"
    docker rm -f $docker_name
    containers=`docker ps --filter status=exited -q`
    if [ "$containers" != "" ]; then
        docker rm $containers
    fi
}


stop_container()
{
    /bin/echo -e "\n=== Stop $docker_name Container ===\n"
    docker stop $docker_name
}


build_image()
{
    /bin/echo -e "\n=== Build $image_name Image by $docker_file ===\n"
    docker build -t $image_name -f $docker_file . 
}


login_message()
{
    /bin/echo -e "Run $docker_name Engine"
    /bin/echo -e "\n"
}


login_image()
{
    /bin/echo -e "\n=== Login $image_name Container($docker_name) ===\n"
    login_message
    /bin/echo -e "login $image_name/$docker_name"
    docker run -ti --name $docker_name -p $api_port:$api_port -v `pwd`:`pwd` -v `pwd`:/test_file $image_name 
}


relogin_container()
{
    /bin/echo -e "\n=== Relogin $image_name Container($docker_name) ===\n"
    docker exec -ti $docker_name bash
}

main()
{
    if [ "$check_build_image" = "y" ] && [ "$check_login_image" != "y" ]; then
        build_image
        exit 0
    fi

    if [ "$check_build_image" = "y" ] && [ "$check_login_image" = "y" ]; then
        build_image
        login_image
        exit 0
    fi

    if [ "$check_build_image" != "y" ] && [ "$check_login_image" = "y" ]; then
        login_image
        exit 0
    fi

    if [ "$check_relogin_container" = "y" ]; then
        relogin_container
        exit 0
    fi

    if [ "$check_stop_container" = "y" ]; then
        stop_container
        remove_container
        remove_image
        exit 0
    fi

}

main















