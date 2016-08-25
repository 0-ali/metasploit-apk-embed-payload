0.2 / 2016-08-25
===========

* Remove `tmp` folder and uses default user `tmp` folder.
* Rename `embed_tools` to `Tools`.
* Use `apktool` of system to avoid apktool.jar errors ,[ref](https://github.com/xc0d3rz/metasploit-apk-embed-payload/commit/30e7f1ef50c9d4d9e8118e153c38663593507eca).
* Add `OOP` for faster embedding and for mult-purpose,[ref](https://github.com/xc0d3rz/metasploit-apk-embed-payload/commit/122f643f6c2633179c1659fdf592d5d30fea1c72).
* Update [`apk-embed-payload.rb`](https://github.com/xc0d3rz/metasploit-apk-embed-payload/blob/releases/v0.2/apk-embed-payload.rb)
* Add auto-clean for `tmp` [on error](https://github.com/xc0d3rz/metasploit-apk-embed-payload/blob/releases/v0.2/lib/embed-payload.rb#L140) happens or on [finish embedding](https://github.com/xc0d3rz/metasploit-apk-embed-payload/blob/releases/v0.2/lib/embed-payload.rb#L263).
