#!/bin/bash

usage(){
    echo "Starts the program"
    echo "Usage: ./start_program.bash [-c] [-b]"
    echo "-c: Clean up docker system"
    echo "-b (Optional): Docker build images"
    exit 1
}

while getopts ":hcb" opt; do
    case ${opt} in
        h)
            usage
            ;;
        c)
            sudo docker volume prune -f
            sudo docker system prune -f
            ;;
        b)
            sudo docker-compose up --build -d
            exit 0
            ;;
        ?)
            echo "Invalid option: -${OPTARG}."
            usage
            ;;
    esac
done
sudo docker-compose up -d