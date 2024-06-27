#!/bin/bash
# tolga erok
# 17 june 2024


list_inactive_services_and_timers() {
    echo "Listing all inactive, dead, or failed systemd services and timers:"
    echo "--------------------------------------------------------------"
    systemctl list-units --type=service --type=timer --state=inactive,failed --no-legend --no-pager
}

show_menu() {
    echo "Select an option:"
    echo "1) Start a service/timer"
    echo "2) Stop a service/timer"
    echo "3) Restart a service/timer"
    echo "4) Start all services/timers"
    echo "5) Stop all services/timers"
    echo "6) Restart all services/timers"
    echo "7) Exit"
}

manage_service() {
    action=$1
    echo "Enter the name of the service/timer (e.g., sshd.service or update.timer):"
    read service_name
    if [ -z "$service_name" ]; then
        echo "No service/timer name entered. Returning to menu."
        return
    fi
    sudo systemctl $action $service_name
}

manage_all_services() {
    action=$1
    echo "This will $action all inactive, dead, or failed services and timers. Are you sure? (y/n)"
    read confirm
    if [ "$confirm" == "y" ]; then
        for unit in $(systemctl list-units --type=service --type=timer --state=inactive,failed --no-legend --no-pager | awk '{print $1}'); do
            sudo systemctl $action $unit
        done
    else
        echo "Operation cancelled. Returning to menu."
    fi
}

while true; do
    list_inactive_services_and_timers
    show_menu
    read -p "Enter your choice: " choice
    
    case $choice in
        1)
            manage_service start
        ;;
        2)
            manage_service stop
        ;;
        3)
            manage_service restart
        ;;
        4)
            manage_all_services start
        ;;
        5)
            manage_all_services stop
        ;;
        6)
            manage_all_services restart
        ;;
        7)
            echo "Exiting."
            exit 0
        ;;
        *)
            echo "Invalid choice. Please try again."
        ;;
    esac
done
