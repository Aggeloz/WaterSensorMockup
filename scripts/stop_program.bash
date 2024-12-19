#!/bin/bash

usage(){
    echo "Stops the program"
    echo "Usage: ./stop_program.bash [-d] [-c] [-v]"
    echo "-d: Full stop. Kills MongoDB as well"
    echo "-c: Clean up docker system"
    echo "-v: Remove KR Volumes"
    exit 1
}
while getopts ":hdcv" opt; do
    case ${opt} in
        h)
            usage
            ;;
        d)
            read -p "This action will also kill MongoDB and its content. Continue? [y/n] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "Full stopping. Killing MongoDB"
            elif [[ $REPLY =~ ^[Nn]$ ]]; then
                echo "Not Killing MongoDB"
            else
                echo "Type y/n"
                exit 1
            fi
            exit 0
            ;;
        c)
            sudo docker system prune -f
            sudo docker volume prune -f
            ;;
        v)
            sudo docker volume rm db_data

            ;;
        ?)
            echo "Invalid option: -${OPTARG}."
            usage
            ;;
    esac
done

sudo docker-compose down