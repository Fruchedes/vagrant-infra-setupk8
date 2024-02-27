#!/bin/bash

# Function to check if a user exists
user_exists() {
    id "$1" &>/dev/null
}

# Function to check if a group exists, and create it if it doesn't
ensure_group_exists() {
    local GROUP_NAME=$1
    if ! getent group "$GROUP_NAME" &>/dev/null; then
        echo "Creating group: $GROUP_NAME"
        sudo groupadd "$GROUP_NAME"
    fi
}

# Add a group to the sudoers file with no password prompt for simplicity in this example
# In a real-world scenario, consider security implications
add_group_to_sudoers() {
    local GROUP_NAME=$1
    echo "%$GROUP_NAME ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$GROUP_NAME >/dev/null
    sudo chmod 0440 /etc/sudoers.d/$GROUP_NAME
}

# Update package lists and upgrade system
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" == "ubuntu" ]; then
        sudo apt-get update && sudo apt-get upgrade -y
    elif [ "$ID" == "centos" ]; then
        sudo yum update -y
    else
        echo "Unsupported OS"
        exit 1
    fi
fi

# Define users and their information
declare -A USERS_INFO=(
    ["henry"]="Henry Ford:Engineering:henry@example.com:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4d7YIaqf55AAOi77q/gEzeEt148og0n/eTMekJ38Ty:sudo"
    ["john"]="John Doe:HR:john@example.com:sssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4d7YIaqf55AAOi77q/gEzeEt148og0n/eTMekJ38Ty:sudo"
    ["mary"]="Mary Smith:Finance:mary@example.com:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4d7YIaqf55AAOi77q/gEzeEt148og0n/eTMekJ38Ty:sudo"
    ["peter"]="Peter Parker:IT:peter@example.com:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4d7YIaqf55AAOi77q/gEzeEt148og0n/eTMekJ38Ty:"
    ["mac"]="Mac Johnson:Marketing:mac@example.com:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4d7YIaqf55AAOi77q/gEzeEt148og0n/eTMekJ38Ty:"
    ["george"]="George Washington:Operations:george@example.com:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4d7YIaqf55AAOi77q/gEzeEt148og0n/eTMekJ38Ty:"
)

# Ensure departmental and specific groups exist
DEPARTMENTS=("Engineering" "HR" "Finance" "IT" "Marketing" "Operations")
SPECIAL_GROUPS=("developers-grp" "administrators-grp")

for DEPT in "${DEPARTMENTS[@]}"; do
    ensure_group_exists "$DEPT"
done

for GROUP in "${SPECIAL_GROUPS[@]}"; do
    ensure_group_exists "$GROUP"
done

# Add administrators-grp to sudoers with appropriate permissions
add_group_to_sudoers "administrators-grp"

# Function to add SSH public key for a user
add_ssh_key() {
    local USER=$1
    local SSH_KEY=$2

    sudo mkdir -p /home/$USER/.ssh
    echo "$SSH_KEY" | sudo tee /home/$USER/.ssh/authorized_keys >/dev/null
    sudo chown -R $USER:$USER /home/$USER
    sudo chmod 700 /home/$USER/.ssh
    sudo chmod 600 /home/$USER/.ssh/authorized_keys
}

# Create users, ensuring groups exist and setting up their environment
for USER in "${!USERS_INFO[@]}"; do
    USER_INFO=${USERS_INFO[$USER]}
    IFS=':' read -r FULL_NAME DEPARTMENT EMAIL SSH_KEY SUDO_ACCESS <<< "$USER_INFO"

    if ! user_exists $USER; then
        echo "Creating user: $USER"
        sudo useradd -m -s /bin/bash -c "$FULL_NAME ($DEPARTMENT)" $USER
        add_ssh_key $USER "$SSH_KEY"

        # Assign user to their departmental group
        sudo usermod -aG "$DEPARTMENT" $USER

        # Assign users to either administrators-grp or developers-grp based on their sudo access requirement
        if [ "$SUDO_ACCESS" == "sudo" ]; then
            sudo usermod -aG "administrators-grp" $USER
        else
            sudo usermod -aG "developers-grp" $USER
        fi
    else
        echo "User $USER already exists. Skipping creation."
    fi
done

# Restart SSH service
if [ "$ID" == "ubuntu" ]; then
    sudo systemctl restart ssh
elif [ "$ID" == "centos" ]; then
    sudo systemctl restart sshd
fi

echo "Script execution completed."
