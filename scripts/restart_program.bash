#!/bin/bash

usage(){
    echo "Restarts the program"
    echo "Usage: ./restart_program.bash [-c] [-s] [-d]"
    echo "-c: Clean up docker system"
    echo "-s (Optional): Stop and start"
    echo "-d (Optional): Full restart. Kills MongoDB as well"
    exit 1
}
while getopts ":hsdc" opt; do
    case ${opt} in
        h)
            usage
            ;;
        c)
            sudo docker volume prune -f
            sudo docker system prune -f
            ;;
        s)
            echo "Stopping and starting"
            ./scripts/stop_program.bash ; ./scripts/start_program.bash -b
            exit 0
            ;;
        d)
            read -p "This action will also kill MongoDB and its content. Continue? [y/n] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "Full restarting. Killing MongoDB"
            elif [[ $REPLY =~ ^[Nn]$ ]]; then
                echo "Not Killing MongoDB"
            else
                echo "Type y/n"
                exit 1
            fi
            exit 0
            ;;
        ?)
            echo "Invalid option: -${OPTARG}."
            usage
        ;;
    esac
done

echo "Normal Restart"
sudo docker-compose restart