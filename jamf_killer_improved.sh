#!/bin/bash

# JamfKiller - Improved Detection Edition
# Better detection for all Jamf processes

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_header() {
    clear
    echo -e "${RED}💀 JAMF KILLER - IMPROVED DETECTION 💀${NC}"
    echo -e "${RED}====================================${NC}"
    echo -e "${CYAN}Enhanced detection for all Jamf processes${NC}"
    echo -e "${RED}====================================${NC}"
    echo ""
}

show_menu() {
    echo -e "${BLUE}Choose your weapon:${NC}"
    echo -e "${GREEN}1.${NC} 🔍 Scan for ALL Jamf processes (detailed)"
    echo -e "${GREEN}2.${NC} 💀 Kill all Jamf processes (improved detection)"
    echo -e "${GREEN}3.${NC} ⚡ Ultra-fast kill mode (0.1s monitoring)"
    echo -e "${GREEN}4.${NC} 🤖 Smart auto-kill (enhanced detection)"
    echo -e "${GREEN}5.${NC} 🎯 Kill specific process by PID"
    echo -e "${GREEN}6.${NC} 🚫 Nuclear option (kill everything Jamf)"
    echo -e "${GREEN}7.${NC} ❌ Quit"
    echo ""
    echo -n "Enter your choice (1-7): "
}

find_jamf_processes() {
    # Enhanced detection using multiple methods
    local processes=()
    
    # Method 1: ps aux with grep (most reliable)
    local ps_results=$(ps aux | grep -i jamf | grep -v grep | grep -v "jamf_killer")
    
    # Method 2: pgrep with different patterns
    local pgrep_results=$(pgrep -fl "Jamf\|jamf\|JC\|JAMF" 2>/dev/null | grep -v "jamf_killer")
    
    # Method 3: find processes in typical Jamf directories
    local dir_processes=$(ps aux | grep -E "/JAMF/|/JamfConnect/|Jamf Connect" | grep -v grep)
    
    # Combine all results and extract PIDs
    {
        echo "$ps_results"
        echo "$pgrep_results" 
        echo "$dir_processes"
    } | while read line; do
        if [[ ! -z "$line" ]]; then
            # Extract PID (second column in ps aux output)
            local pid=$(echo "$line" | awk '{print $2}')
            if [[ "$pid" =~ ^[0-9]+$ ]]; then
                echo "$pid:$line"
            fi
        fi
    done | sort -u
}

scan_jamf_processes() {
    echo -e "${CYAN}🔍 Scanning for ALL Jamf processes (enhanced detection)...${NC}"
    echo ""
    
    local found=false
    local process_info=$(find_jamf_processes)
    
    if [[ ! -z "$process_info" ]]; then
        echo -e "${YELLOW}🎯 Found Jamf processes:${NC}"
        echo ""
        
        while IFS=: read -r pid full_line; do
            if [[ ! -z "$pid" && ! -z "$full_line" ]]; then
                # Extract process name and details
                local process_name=$(echo "$full_line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/[[:space:]]*$//')
                local cpu=$(echo "$full_line" | awk '{print $3}')
                local mem=$(echo "$full_line" | awk '{print $4}')
                
                echo -e "${RED}💀 PID: ${pid}${NC}"
                echo -e "   ${BLUE}CPU: ${cpu}% | Memory: ${mem}%${NC}"
                echo -e "   ${YELLOW}Process: ${process_name}${NC}"
                echo ""
                found=true
            fi
        done <<< "$process_info"
    fi
    
    if [[ "$found" == false ]]; then
        echo -e "${GREEN}✅ No Jamf processes currently running${NC}"
    fi
    echo ""
}

kill_jamf_processes() {
    echo -e "${RED}💀 Killing all Jamf processes (enhanced detection)...${NC}"
    local killed_count=0
    local process_info=$(find_jamf_processes)
    
    if [[ ! -z "$process_info" ]]; then
        while IFS=: read -r pid full_line; do
            if [[ ! -z "$pid" && "$pid" =~ ^[0-9]+$ ]]; then
                local process_name=$(echo "$full_line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/[[:space:]]*$//')
                
                if kill -9 "$pid" 2>/dev/null; then
                    echo -e "${GREEN}🔥 Killed PID ${pid}: ${process_name}${NC}"
                    ((killed_count++))
                else
                    echo -e "${YELLOW}⚠️  Could not kill PID ${pid} (may already be dead)${NC}"
                fi
            fi
        done <<< "$process_info"
    fi
    
    # Additional cleanup with killall
    local additional_killed=0
    for name in "Jamf Connect" "JamfDaemon" "JamfAgent" "JCDaemon"; do
        if killall -9 "$name" 2>/dev/null; then
            echo -e "${GREEN}⚡ Killed via killall: ${name}${NC}"
            ((additional_killed++))
        fi
    done
    
    local total_killed=$((killed_count + additional_killed))
    
    if [[ $total_killed -gt 0 ]]; then
        echo -e "${GREEN}🎉 Successfully killed ${total_killed} Jamf processes!${NC}"
    else
        echo -e "${BLUE}ℹ️  No Jamf processes found to kill${NC}"
    fi
    
    return $total_killed
}

ultra_fast_monitor() {
    echo -e "${PURPLE}⚡ Starting ultra-fast monitoring (0.1s intervals)...${NC}"
    echo -e "${YELLOW}Enhanced detection - kills processes before UI appears${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}"
    echo ""
    
    local total_killed=0
    trap 'echo -e "\n${GREEN}👋 Ultra-fast monitor stopped. Total killed: ${total_killed}${NC}"; exit 0' INT
    
    while true; do
        local process_info=$(find_jamf_processes)
        
        if [[ ! -z "$process_info" ]]; then
            echo -e "${RED}⚡ Jamf detected! Instant kill mode...${NC}"
            
            while IFS=: read -r pid full_line; do
                if [[ ! -z "$pid" && "$pid" =~ ^[0-9]+$ ]]; then
                    if kill -9 "$pid" 2>/dev/null; then
                        echo -e "${GREEN}💥 Instant kill: PID ${pid}${NC}"
                        ((total_killed++))
                    fi
                fi
            done <<< "$process_info"
            
            # Additional instant kills
            killall -9 "Jamf Connect" 2>/dev/null && echo -e "${GREEN}💥 Killall: Jamf Connect${NC}" && ((total_killed++))
            killall -9 "JamfDaemon" 2>/dev/null && echo -e "${GREEN}💥 Killall: JamfDaemon${NC}" && ((total_killed++))
            killall -9 "JamfAgent" 2>/dev/null && echo -e "${GREEN}💥 Killall: JamfAgent${NC}" && ((total_killed++))
        fi
        
        sleep 0.1  # Check every 100ms
    done
}

smart_auto_kill() {
    echo -e "${PURPLE}🤖 Starting smart auto-kill mode...${NC}"
    echo -e "${YELLOW}Enhanced detection with 2-second intervals${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}"
    echo ""
    
    local total_killed=0
    trap 'echo -e "\n${GREEN}👋 Smart auto-kill stopped. Total killed: ${total_killed}${NC}"; exit 0' INT
    
    while true; do
        local process_info=$(find_jamf_processes)
        
        if [[ ! -z "$process_info" ]]; then
            echo -e "${YELLOW}⚠️  Jamf processes detected! Terminating...${NC}"
            
            local session_killed=0
            while IFS=: read -r pid full_line; do
                if [[ ! -z "$pid" && "$pid" =~ ^[0-9]+$ ]]; then
                    local process_name=$(echo "$full_line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/[[:space:]]*$//')
                    
                    if kill -9 "$pid" 2>/dev/null; then
                        echo -e "${GREEN}🔥 Killed: PID ${pid}${NC}"
                        ((session_killed++))
                        ((total_killed++))
                    fi
                fi
            done <<< "$process_info"
            
            if [[ $session_killed -gt 0 ]]; then
                echo -e "${GREEN}✅ Killed ${session_killed} processes (Total: ${total_killed})${NC}"
            fi
        else
            echo -e "${GREEN}✅ All clear - $(date '+%H:%M:%S')${NC}"
        fi
        
        sleep 2
    done
}

kill_specific_pid() {
    echo -e "${CYAN}Current Jamf processes:${NC}"
    scan_jamf_processes
    
    echo -n "Enter PID to kill: "
    read -r target_pid
    
    if [[ ! "$target_pid" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}❌ Invalid PID${NC}"
        return
    fi
    
    # Check if it's a Jamf process
    local process_info=$(ps -p "$target_pid" -o comm= 2>/dev/null)
    if [[ -z "$process_info" ]]; then
        echo -e "${RED}❌ Process not found${NC}"
        return
    fi
    
    if kill -9 "$target_pid" 2>/dev/null; then
        echo -e "${GREEN}💀 Successfully killed PID ${target_pid}${NC}"
    else
        echo -e "${RED}❌ Failed to kill PID ${target_pid}${NC}"
    fi
}

nuclear_option() {
    echo -e "${RED}🚫 NUCLEAR OPTION - Killing EVERYTHING Jamf-related${NC}"
    echo -e "${YELLOW}This will be very aggressive!${NC}"
    echo -n "Are you sure? (y/N): "
    read -r confirm
    
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo -e "${BLUE}Nuclear option cancelled${NC}"
        return
    fi
    
    echo -e "${RED}💥 ENGAGING NUCLEAR MODE...${NC}"
    
    # Kill everything with jamf in the name
    pkill -9 -i jamf 2>/dev/null
    killall -9 "Jamf Connect" 2>/dev/null
    killall -9 "JamfDaemon" 2>/dev/null  
    killall -9 "JamfAgent" 2>/dev/null
    killall -9 "JCDaemon" 2>/dev/null
    
    # Kill by path patterns
    ps aux | grep -i jamf | grep -v grep | awk '{print $2}' | xargs -r kill -9 2>/dev/null
    
    echo -e "${GREEN}💥 Nuclear strike complete! All Jamf processes eliminated!${NC}"
}

# Main execution
main() {
    if [[ "$(uname)" != "Darwin" ]]; then
        echo -e "${RED}❌ This script requires macOS${NC}"
        exit 1
    fi
    
    print_header
    
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                echo ""
                scan_jamf_processes
                echo -n "Press Enter to continue..."
                read -r
                print_header
                ;;
            2)
                echo ""
                kill_jamf_processes
                echo ""
                echo -n "Press Enter to continue..."
                read -r
                print_header
                ;;
            3)
                echo ""
                ultra_fast_monitor
                ;;
            4)
                echo ""
                smart_auto_kill
                ;;
            5)
                echo ""
                kill_specific_pid
                echo ""
                echo -n "Press Enter to continue..."
                read -r
                print_header
                ;;
            6)
                echo ""
                nuclear_option
                echo ""
                echo -n "Press Enter to continue..."
                read -r
                print_header
                ;;
            7)
                echo -e "${GREEN}👋 Goodbye! Jamf processes have been terminated!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice${NC}"
                echo ""
                ;;
        esac
    done
}

main "$@" 