# Introduction

## `proxy-to-https`
Local service proxy to Any domain
> following below instructions, if you never used shell
### 1: Start your local service, and got the `local_port_number`
### 2: Run the following commands
- Change your current directory to `proxy-to-https`
```powershell
cd ./proxy-to-https
```
- Make all files executable
```powershell
chmod +x ./*
```
- Add a new host to your `/etc/hosts` file
```powershell
./manage-hosts.sh add 127.0.0.1 your_domain
```
- Proxy your local service port to default port `80` or `443`, and make a `server.pem` file
> port `80` is the default port for http
```powershell
./port-forward.sh 80 your_local_port_number
```

If you want to use https, you need to run the following commands
> port `443` is the default port for https
```powershell
./port-forward.sh 443 your_local_port_number
```

Or you can use `iTerm2` to integrate custom instructions and build them into your `Shell` environment
### 3: Open your browser, and visit `your_domain`  <img src="https://emojis.slackmojis.com/emojis/images/1669813533/62956/doge.gif?1669813533" alt="proxy" width="30"/>