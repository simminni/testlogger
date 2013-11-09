require 'nokogiri'
require 'fileutils'
require 'time'
    
    class Log

        @nodeCursor='log'
        @Resultslocation = "C:/Results"
        @logFileName = @Resultslocation+"TestResults_"+(Time.new.strftime "%H_%M_%S")+".xml"
        
        #FileUtils.mkdir_p(File.dirname(@logFileName))
        def self.getResultLocation()
            puts  "Find results at: "+@logFileName
        end        
        
        def self.configure(location = nil)
            if location.nil?
                location = File.expand_path(File.dirname(__FILE__)+"/../conf.rb")
                require location
                configValues = getLogConfiguration()
                puts configValues[:resultFileLocation]
                @logFileName = configValues[:resultFileLocation]+"/TestResults_"+(Time.new.strftime "%H_%M_%S")+".xml"
                puts "Loading results location from default 'config.rb'"
                Log.getResultLocation
            else
                require location
                configValues = getLogConfiguration()
                @logFileName = configValues[:resultFileLocation]+"/TestResults_"+(Time.new.strftime "%H_%M_%S")+".xml"
                puts "Updataed results location from '#{location}'"
                Log.getResultLocation
            end
        end

        def self.createFileIfDoesnotExist()
            unless File.exists?(@logFileName)  
                FileUtils.mkdir_p(File.dirname(@logFileName))
                f = File.new(@logFileName, "w")
                f.write("<log></log>")
                f.close 
            end
            if File.zero?(@logFileName)   
                f = File.new(@logFileName, "w")
                f.write("<log></log>")
                f.close 
            end
    
        end
        def self.getCurrentNode
            cursor_local = ''
            @nodeCursor.split("|").each do |i|
                cursor_local = cursor_local+"/"+i+"[last()]"
            end
            return cursor_local
        end
  
        def self.test_script(scriptValue = 'NA')
            Log.createFileIfDoesnotExist()
            if @nodeCursor.include? "test-script"
                @nodeCursor = 'log'
            end
            f1 = File.open(@logFileName)
            doc = Nokogiri::XML(f1)
            log = doc.at_xpath(Log.getCurrentNode)
            test_scriptNode = Nokogiri::XML::Node.new("test-script", doc)
            test_scriptNode['name'] = (scriptValue)
            test_scriptNode['start_time'] = Time.now.iso8601(3)
            f2 = File.open(@logFileName,"w")
            log.add_child(test_scriptNode)
        rescue Exception => e
            Log.error e
        ensure 
            f2.write(doc)
            f1.close()
            f2.close()
            @nodeCursor = @nodeCursor+"|test-script"
        end
  
        def self.close_test_script()
            @nodeCursor = "log|test-script"
            f1 = File.open(@logFileName)
            doc = Nokogiri::XML(f1)
            log = doc.at_xpath(Log.getCurrentNode)
            log['end_time'] = Time.now.iso8601(3)
            f2 = File.open(@logFileName,"w")
        rescue Exception => e
            Log.error e
        ensure 
            f2.write(doc)
            f1.close()
            f2.close()
            @nodeCursor = "log"
        end
  
        def self.test_case(idValue = 'NA',nameValue = 'NA')
    
            Log.createFileIfDoesnotExist()
            if @nodeCursor.include? "test-case"
                @nodeCursor = 'log|test-script'
            end  
    
            f1 = File.open(@logFileName)
            doc = Nokogiri::XML(f1)
            log = doc.at_xpath(Log.getCurrentNode)
            testCaseNode = Nokogiri::XML::Node.new("test-case", doc)
            testCaseNode['id'] = (idValue)
            testCaseNode['name'] = (nameValue)
            testCaseNode['start_time'] = Time.now.iso8601(3)
            f2 = File.open(@logFileName,"w")
            log.add_child(testCaseNode)
        rescue Exception => e
            Log.error e
        ensure
            f2.write(doc)
            f1.close()
            f2.close()
            @nodeCursor = @nodeCursor+"|test-case"
    
        end
        
        def self.close_test_case()
            @nodeCursor = "log|test-script|test-case"
            f1 = File.open(@logFileName)
            doc = Nokogiri::XML(f1)
            log = doc.at_xpath(Log.getCurrentNode)
            log['end_time'] = Time.now.iso8601(3)
            f2 = File.open(@logFileName,"w")
        rescue Exception => e
            Log.error e
        ensure 
            f2.write(doc)
            f1.close()
            f2.close()
            @nodeCursor = "log|test-script"
        end
  
        def self.test_step(idValue = 'NA',nameValue = 'NA')
            Log.createFileIfDoesnotExist()
            if @nodeCursor.include? "test-step"
                @nodeCursor = 'log|test-script|test-case'
            end  
            f1 = File.open(@logFileName)
            doc = Nokogiri::XML(f1)
            log = doc.at_xpath(Log.getCurrentNode)
            testStepNode = Nokogiri::XML::Node.new("test-step", doc)
            testStepNode['id'] = (idValue)
            testStepNode['name'] = (nameValue)
            testStepNode['start_time'] = Time.now.iso8601(3)
    
            f2 = File.open(@logFileName,"w")
            log.add_child(testStepNode)
        rescue Exception => e
            Log.error e
        ensure
            f2.write(doc)
            f1.close()
            f2.close()
            @nodeCursor = @nodeCursor+"|test-step"
        end
        
        def self.close_test_step()
            @nodeCursor = "log|test-script|test-case|test-step"
            f1 = File.open(@logFileName)
            doc = Nokogiri::XML(f1)
            log = doc.at_xpath(Log.getCurrentNode)
            log['end_time'] = Time.now.iso8601(3)
            f2 = File.open(@logFileName,"w")
        rescue Exception => e
            Log.error e
        ensure 
            f2.write(doc)
            f1.close()
            f2.close()
            @nodeCursor = "log|test-script|test-case"
        end
  
        def self.message(details= 'NA',picture = 'NA')
            Log.createFileIfDoesnotExist  
            f1 = File.open(@logFileName)
            doc = Nokogiri::XML(f1)
            log = doc.at_xpath(Log.getCurrentNode)
            message = Nokogiri::XML::Node.new("message", doc)
            log.add_child(message)
            log = doc.at_xpath(Log.getCurrentNode+"/message[last()]")
    
            timeN = Nokogiri::XML::Node.new("time", doc)
            timeN.content=Time.now.iso8601(3)
            log.add_child(timeN)
    
            detailsmessage = Nokogiri::XML::Node.new("details", doc)
            detailsmessage.content=details
            log.add_child(detailsmessage)
    
            pictureLocation = Nokogiri::XML::Node.new("picture", doc)
            pictureLocation.content=picture
            log.add_child(pictureLocation)
    
            f2 = File.open(@logFileName,"w")
        rescue Exception => e
            Log.error e
        ensure
            f2.write(doc)
            f1.close()
            f2.close()
        end

        def self.error(details = 'NA',picture = 'NA')
            Log.createFileIfDoesnotExist
            f1 = File.open(@logFileName)
            doc = Nokogiri::XML(f1)
            log = doc.at_xpath(Log.getCurrentNode)
            error = Nokogiri::XML::Node.new("error", doc)
            log.add_child(error)
            log = doc.at_xpath(Log.getCurrentNode+"/error[last()]")
    
            timeN = Nokogiri::XML::Node.new("Time", doc)
            timeN.content=Time.now.iso8601(3)
            log.add_child(timeN)
    
            detailsmessage = Nokogiri::XML::Node.new("details", doc)
            detailsmessage.content=details
            log.add_child(detailsmessage)
    
            additionaldetailsmessage = Nokogiri::XML::Node.new("additional_details", doc)
            additionaldetailsmessage.content=caller.inspect
            log.add_child(additionaldetailsmessage)
    
            pictureLocation = Nokogiri::XML::Node.new("picture", doc)
            pictureLocation.content=picture
            log.add_child(pictureLocation)
        rescue Exception => e
            return false
        ensure 
            #$global_return = false
            f2 = File.open(@logFileName,"w")
            f2.write(doc)
            f1.close()
            f2.close()
        end

        def self.warning(details='NA',picture = 'NA')
            Log.createFileIfDoesnotExist
            f1 = File.open(@logFileName)
            doc = Nokogiri::XML(f1)
            log = doc.at_xpath(Log.getCurrentNode)
            warning = Nokogiri::XML::Node.new("warning", doc)
            log.add_child(warning)
            log = doc.at_xpath(Log.getCurrentNode+"/warning[last()]")
    
            timeN = Nokogiri::XML::Node.new("time", doc)
            timeN.content=Time.now.iso8601(3)
            log.add_child(timeN)
    
            detailsmessage = Nokogiri::XML::Node.new("details", doc)
            detailsmessage.content=details
            log.add_child(detailsmessage)
    
            pictureLocation = Nokogiri::XML::Node.new("picture", doc)
            pictureLocation.content= picture
            log.add_child(pictureLocation)
        rescue Exception => e
            Log.error e
        ensure  
            f2 = File.open(@logFileName,"w")
            f2.write(doc)
            f1.close()
            f2.close()
        end

        def self.utility(message = 'NA')
            Log.createFileIfDoesnotExist()
      
            f1 = File.open(@logFileName)
            doc = Nokogiri::XML(f1)
            log = doc.at_xpath(Log.getCurrentNode)
            utilityNode = Nokogiri::XML::Node.new("utility", doc)
            utilityNode['name'] = (message)
            f2 = File.open(@logFileName,"w")
            log.add_child(utilityNode)
        rescue Exception => e
            Log.error e
        ensure  
            f2.write(doc)
            f1.close()
            f2.close()
            @nodeCursor = @nodeCursor+"|utility"
        end
        
        def self.close_utility()
    
            index = @nodeCursor.rindex('|utility')
            @nodeCursor = @nodeCursor.slice(0...index)
    
        end
        
        #Default configure
        Log.configure()
  end

