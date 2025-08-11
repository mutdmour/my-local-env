#!/usr/bin/env zsh

# Git utility functions
# File: ~/.config/zsh/git-functions.zsh

# Git Worktree Add shortcut function
gwa() {
    local base_path="/Users/mutasem/repos/n8n-worktree"
    local branch_name=""
    local create_new_branch=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -b)
                create_new_branch=true
                shift
                ;;
            *)
                branch_name="$1"
                shift
                ;;
        esac
    done
    
    # Check if branch name is provided
    if [[ -z "$branch_name" ]]; then
        echo "Usage: gwa [-b] <branch-name>"
        echo "  -b: Create new branch"
        echo "Examples:"
        echo "  gwa branch-name                 # Add worktree for existing branch"
        echo "  gwa -b branch-name             # Create new branch and add worktree"
        return 1
    fi
    
    local worktree_path="$base_path/$branch_name"
    
    # Execute git worktree add command
    if [[ "$create_new_branch" == true ]]; then
        echo "Creating new branch and worktree: $branch_name"
        git worktree add "$worktree_path" -b "$branch_name"
    else
        echo "Adding worktree for existing branch: $branch_name"
        git worktree add "$worktree_path" "$branch_name"
    fi
    
    # Check if command was successful
    if [[ $? -eq 0 ]]; then
        echo "Worktree created successfully at: $worktree_path"
        echo "Navigating to worktree directory..."
        z "$worktree_path"
        
        # Add VSCode color customization to new worktree
        echo "Setting up VSCode color customization..."
        add_vscode_color
    else
        echo "Failed to create worktree"
        return 1
    fi
}

add_vscode_color() {
    local vscode_dir=".vscode"
    local settings_file="$vscode_dir/settings.json"
    
    # Create .vscode directory if it doesn't exist
    if [[ ! -d "$vscode_dir" ]]; then
        echo "Creating .vscode directory..."
        mkdir -p "$vscode_dir"
    fi
    
    # Generate random color - distinct colors for easy visual differentiation
    local colors=(
        "#0066CC" "#228B22" "#FF8C00" "#9932CC" "#008B8B" 
        "#4169E1" "#32CD32" "#FFD700" "#8A2BE2" "#00CED1"
        "#1E90FF" "#00FF7F" "#FFA500" "#6A5ACD" "#20B2AA"
        "#4682B4" "#3CB371" "#F4A460" "#7B68EE" "#48D1CC"
        "#5F9EA0" "#9ACD32" "#DEB887" "#9370DB" "#40E0D0"
        "#87CEEB" "#ADFF2F" "#F0E68C" "#DA70D6" "#AFEEEE"
    )
    local active_color=${colors[$((RANDOM % ${#colors[@]}))]}
    
    # Create inactive color (add alpha transparency)
    local inactive_color="${active_color}99"
    
    # Create color customization object
    local color_customizations='{
        "titleBar.activeBackground": "'$active_color'",
        "titleBar.activeForeground": "#e7e7e7",
        "titleBar.inactiveBackground": "'$inactive_color'",
        "titleBar.inactiveForeground": "#e7e7e799"
    }'
    
    # Update or create settings.json
    if [[ -f "$settings_file" ]]; then
        echo "Updating existing VSCode settings.json..."
        # Use jq to merge the color customizations with existing settings
        local temp_file=$(mktemp)
        jq --argjson colors "$color_customizations" '.["workbench.colorCustomizations"] = $colors' "$settings_file" > "$temp_file" && mv "$temp_file" "$settings_file"
    else
        echo "Creating new VSCode settings.json..."
        # Create new settings.json with color customizations
        echo '{
    "workbench.colorCustomizations": '$color_customizations'
}' > "$settings_file"
    fi
    echo "✓ VSCode settings.json created/updated with color: $active_color"
    echo "Settings file: $settings_file"
}

# Git Fetch and Checkout shortcut function
gfco() {
    local branch_name="$1"
    
    # Check if branch name is provided
    if [[ -z "$branch_name" ]]; then
        echo "Usage: gfco <branch-name>"
        echo "Example: gfco branch-name"
        return 1
    fi
    
    echo "Fetching branch: $branch_name"
    git fetch origin "$branch_name"
    
    # Check if fetch was successful
    if [[ $? -eq 0 ]]; then
        echo "Checking out branch: $branch_name"
        git checkout "$branch_name"
        
        if [[ $? -eq 0 ]]; then
            echo "Successfully checked out branch: $branch_name"
        else
            echo "Failed to checkout branch: $branch_name"
            return 1
        fi
    else
        echo "Failed to fetch branch: $branch_name"
        return 1
    fi
}

# Git Worktree List shortcut function
gwl() {
    echo "Listing all worktrees:"
    git worktree list
}

# Git Worktree Remove shortcut function
gwrm() {
    # Check if any arguments are provided
    if [[ $# -eq 0 ]]; then
        echo "Usage: gwrm <worktree-path-or-branch-name> [worktree-path-or-branch-name...]"
        echo "Examples:"
        echo "  gwrm branch-name                           # Remove single branch by name"
        echo "  gwrm branch1 branch2 branch3              # Remove multiple branches by name"
        echo "  gwrm /Users/mutasem/repos/n8n-worktree/branch-name  # Remove by full path"
        echo ""
        echo "Current worktrees:"
        git worktree list
        return 1
    fi
    
    local failed_removals=()
    local successful_removals=()
    
    # Process each worktree path/branch name
    for worktree_arg in "$@"; do
        local worktree_path="$worktree_arg"
        
        # If the argument doesn't start with /, assume it's a branch name and construct the full path
        if [[ "$worktree_path" != /* ]]; then
            local base_path="/Users/mutasem/repos/n8n-worktree"
            worktree_path="$base_path/$worktree_path"
        fi
        
        echo "Removing worktree: $worktree_path"
        git worktree remove "$worktree_path"
        
        # Check if command was successful
        if [[ $? -eq 0 ]]; then
            echo "✓ Worktree removed successfully: $worktree_path"
            successful_removals+=("$worktree_arg")
        else
            echo "✗ Failed to remove worktree: $worktree_path"
            failed_removals+=("$worktree_arg")
        fi
        echo ""
    done
    
    # Summary
    if [[ ${#successful_removals[@]} -gt 0 ]]; then
        echo "Successfully removed ${#successful_removals[@]} worktree(s):"
        printf "  - %s\n" "${successful_removals[@]}"
    fi
    
    if [[ ${#failed_removals[@]} -gt 0 ]]; then
        echo "Failed to remove ${#failed_removals[@]} worktree(s):"
        printf "  - %s\n" "${failed_removals[@]}"
        return 1
    fi
}