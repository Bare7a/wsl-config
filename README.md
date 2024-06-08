Clone the repo inside the home directory in `wsl`

```SH
git clone git@github.com:Bare7a/wsl-config.git ~/wsl
```

Mark the `install.sh` and `preinstall.sh` scritps are executable

```SH
chmod +x ~/wsl/install.sh
chmod +x ~/wsl/preinstall.sh
```

Apply DNS fix before running the actual script

```SH
sudo ~/wsl/preinstall.sh
```

Restart WSL and run the following script to install, update and configure the system and apps

```SH
sudo ~/wsl/install.sh
```
