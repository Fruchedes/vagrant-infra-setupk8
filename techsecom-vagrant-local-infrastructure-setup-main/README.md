# techsecom-vagrant-local-infrastructure-setup
Github action repo management for creating resources in AWS Cloud and authentication with OIDC

Requirements
__________________________

1.⁠ ⁠VirtualBox  
2.⁠ ⁠VMware Workstation or 
3.⁠ ⁠VMware vSphere

Assignment
__________________________
1. 3 VMs
2. Allocate RAM, CPU & DISK (Remember to allocate only what your system can handle) 
3. 3 different OS 
 - Ubuntu GUI 
 - CentOS non-GUI
 - Windows 11

Vagrant can Create Virtual Machines in Seconds on VirtualBox, Hyper-V, and VMware

### Common Vagrant Providers

```sh
parallels for mac
virtualbox for VirtualBox
```

To use a specific provider, you need to specify it in your Vagrantfile or when you bring up a VM.

### Provider 

```sh
config.vm.provider "virtualbox"
```

### Network configuration 
Change all occurrences of ``eth0`` to ``enp0s8``

### Image configuration 
Modify the value of config.vm.box = "bento/ubuntu-20.04"

### Set Up a Virtual Environment with Vagrant and VMware on MacOS

### For Ubuntu 



Step 1: Install Vagrant with Homebrew
Run Command 

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install gcc
brew install vagrant 
brew install virtualbox
brew install virtualbox-extension-pack
brew install vagrant-completion
vagrant box add hashicorp/bionic64
vagrant plugin install vagrant-vmware-desktop
```

Then, you must enable WSL 2 support. To do that, append two lines into the ~/.zshrcfile:

The terminal on WSL 2
# append those two lines into ~/.zshrc

```sh 
echo 'export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"' >> ~/.zshrc
echo 'export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"' >> ~/.zshrc
```

# now reload the ~/.zshrc file

```sh
source ~/.zshrc
```

 Installing the vmware-desktop plugin

```sh
vagrant plugin install vagrant-vmware-desktop
```

Create Ubuntu Virtual Machine

Ensure ``Vagrantfile`` is in your present working directory:

```sh
vagrant up 
```

Step 7. Now we will SSH into the VM and see if we can get an ip address to show. 

```sh
vagrant ssh
```


### Useful Vagrant Box Commands

``vagrant init`` - Initializes a new Vagrant environment. 

``vagrant status`` - Check vagrant status 

``vagrant up`` - Starts and provisions the Vagrant environment as defined in the Vagrantfile.

``vagrant suspend`` - Suspends the machine, saving the current running state and stopping it. 

``vagrant halt`` - Gracefully shuts down the running machine.

``vagrant reload`` - Restarts the machine, loading new Vagrantfile configuration changes without having to halt and up the machine again.

``vagrant destroy`` - Destroying a virtual machine.

``vagrant status`` - Displays the current status of the machine 

``vagrant ssh`` - Connects to the machine via SSH.

``vagrant provision`` - Provisions the machine according to the configuration specified in the Vagrantfile.

``vagrant box add`` - Adds a box to your Vagrant installation.

``vagrant box remove`` -- Removes an existing box from your Vagrant installation.

``vagrant box update`` - Updates the boxes to the latest version, respecting the constraints in the Vagrantfile.

``vagrant box list`` - Lists all the boxes installed on your system.

``vagrant plugin install`` - Installs a Vagrant plugin to extend Vagrant’s functionality.

``vagrant plugin uninstall`` - Uninstalls a previously installed Vagrant plugin.

``vagrant plugin list`` - Lists all the plugins currently installed in your Vagrant environment.

