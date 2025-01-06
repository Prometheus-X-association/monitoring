#!/bin/bash

for container in $(docker ps -a --filter "name=ptx_" --format "{{.Names}}"); do
    healthcheckStatus=$(docker inspect --format='{{.State.Status}}' $container)

    case $healthcheckStatus in
        "healthy" | "running")
            # green
            echo -e "\e[32m$container: $healthcheckStatus\e[0m"
            ;;
        "No healthcheck defined")
            # gray
            echo -e "\e[37m$container: $healthcheckStatus\e[0m"
            ;;
        *)
            # red
            echo -e "\e[31m$container: $healthcheckStatus\e[0m"
            ;;
    esac
done
