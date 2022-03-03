//
//  Log.swift
//  
//
//  Created by rg on 2/24/22.
//

import Foundation

public class SplunkHEC_Log {
    
    private let string_format:String
    private let time_format:String
    private var session:SplunkHEC_Session!
    private var is_session_set:Bool = false
    
    init(session:SplunkHEC_Session, string_format:String, time_format:String) {
        
        self.session = session
        self.string_format = string_format
        self.time_format = time_format
        is_session_set = true
        
    }
    
    init(string_format:String, time_format:String) {
        
        self.string_format = string_format
        self.time_format = time_format
        
    }
    
    
    func set_session(session:SplunkHEC_Session) {
        self.session = session
        is_session_set = true
    }
    
    public func system_info(level:String="DEBUG",
                     date:Date = Date(),
                     file:String = #file,
                     function:String = #function,
                     line:String = String(#line)
    ) {
        let splunkHEC = SplunkHEC_SystemInfo()
        let kv_message = splunkHEC.description()
        
        event(message: kv_message, level: level, date: date, file: file, function: function, line: line)

    }
    
    public func info(message:[String:Any],
              date:Date = Date(),
              file:String = #file,
              function:String = #function,
              line:String = String(#line)
    ) {
        
        let kv_message = SplunkHEC_Utils().dict2KV(dict: message)
        event(message: kv_message, level: "INFO", date: date, file: file, function: function, line: line)
        
    }
    public func i(message:[String:Any],
           date:Date = Date(),
           file:String = #file,
           function:String = #function,
           line:String = String(#line)
    ) {
        
        info(message: message, date: date, file: file, function: function, line: line)
        
    }
    
    public func info(message:String,
              date:Date = Date(),
              file:String = #file,
              function:String = #function,
              line:String = String(#line)
    ) {
        
        event(message: message, level: "INFO", date: date, file: file, function: function, line: line)
        
    }
    public func i(message:String,
           date:Date = Date(),
           file:String = #file,
           function:String = #function,
           line:String = String(#line)
    ) {
        
        info(message: message, date: date, file: file, function: function, line: line)
        
    }
    
    public func warn(message:[String:Any],
                  date:Date = Date(),
                  file:String = #file,
                  function:String = #function,
                  line:String = String(#line)
        ) {
            
            let kv_message = SplunkHEC_Utils().dict2KV(dict: message)
            event(message: kv_message, level: "WARN", date: date, file: file, function: function, line: line)
            
    }
    public func w(message:[String:Any],
           date:Date = Date(),
           file:String = #file,
           function:String = #function,
           line:String = String(#line)
    ) {
        
        warn(message: message, date: date, file: file, function: function, line: line)
        
    }
    
    public func warn(message:String,
              date:Date = Date(),
              file:String = #file,
              function:String = #function,
              line:String = String(#line)
    ) {
        
        event(message: message, level: "WARN", date: date, file: file, function: function, line: line)
        
    }
    public func w(message:String,
           date:Date = Date(),
           file:String = #file,
           function:String = #function,
           line:String = String(#line)
    ) {
        
        warn(message: message, date: date, file: file, function: function, line: line)
        
    }
    public func error(message:[String:Any],
                  date:Date = Date(),
                  file:String = #file,
                  function:String = #function,
                  line:String = String(#line)
        ) {
            
            let kv_message = SplunkHEC_Utils().dict2KV(dict: message)
            event(message: kv_message, level: "ERROR", date: date, file: file, function: function, line: line)
            
    }
    public func e(message:[String:Any],
           date:Date = Date(),
           file:String = #file,
           function:String = #function,
           line:String = String(#line)
    ) {
        
        error(message: message, date: date, file: file, function: function, line: line)
        
    }
    
    public func error(message:String,
              date:Date = Date(),
              file:String = #file,
              function:String = #function,
              line:String = String(#line)
    ) {
        
        event(message: message, level: "ERROR", date: date, file: file, function: function, line: line)
        
    }
    public func e(message:String,
           date:Date = Date(),
           file:String = #file,
           function:String = #function,
           line:String = String(#line)
    ) {
        
        error(message: message, date: date, file: file, function: function, line: line)
        
    }
    
    public func fatal(message:[String:Any],
                  date:Date = Date(),
                  file:String = #file,
                  function:String = #function,
                  line:String = String(#line)
        ) {
            
            let kv_message = SplunkHEC_Utils().dict2KV(dict: message)
            event(message: kv_message, level: "FATAL", date: date, file: file, function: function, line: line)
            
    }
    public func f(message:[String:Any],
           date:Date = Date(),
           file:String = #file,
           function:String = #function,
           line:String = String(#line)
    ) {
        
        fatal(message: message, date: date, file: file, function: function, line: line)
        
    }
    
    public func fatal(message:String,
              date:Date = Date(),
              file:String = #file,
              function:String = #function,
              line:String = String(#line)
    ) {
        
        event(message: message, level: "FATAL", date: date, file: file, function: function, line: line)
        
    }
    public func f(message:String,
           date:Date = Date(),
           file:String = #file,
           function:String = #function,
           line:String = String(#line)
    ) {
        
        fatal(message: message, date: date, file: file, function: function, line: line)
        
    }
    
    public func debug(message:[String:Any],
                  date:Date = Date(),
                  file:String = #file,
                  function:String = #function,
                  line:String = String(#line)
        ) {
            
            let kv_message = SplunkHEC_Utils().dict2KV(dict: message)
            event(message: kv_message, level: "DEBUG", date: date, file: file, function: function, line: line)
            
    }
    public func d(message:[String:Any],
           date:Date = Date(),
           file:String = #file,
           function:String = #function,
           line:String = String(#line)
    ) {
        
        debug(message: message, date: date, file: file, function: function, line: line)
        
    }
    
    public func debug(message:String,
              date:Date = Date(),
              file:String = #file,
              function:String = #function,
              line:String = String(#line)
    ) {
        
        event(message: message, level: "DEBUG", date: date, file: file, function: function, line: line)
        
    }
    public func d(message:String,
           date:Date = Date(),
           file:String = #file,
           function:String = #function,
           line:String = String(#line)
    ) {
        
        debug(message: message, date: date, file: file, function: function, line: line)
        
    }
    
    
    public func event(message:[String:Any],
               level:String = "",
               date:Date = Date(),
               file:String = #file,
               function:String = #function,
               line:String = String(#line)
    ) {
      
        let kv_message = SplunkHEC_Utils().dict2KV(dict: message)
        
        event(message: kv_message, level: level, date: date, file: file, function: function, line: line)
        
    }
    
    public func event(message:String,
               level:String = "",
               date:Date = Date(),
               file:String = #file,
               function:String = #function,
               line:String = String(#line)
    ) {
        
        if is_session_set && session.is_active {
        
            let event_data = [
                "message": message,
                "session_id": session.session_id,
                "level": level,
                "timestamp":SplunkHEC_Utils().formatDate(date:date, format: self.time_format),
                "file":file,
                "function":function,
                "line":line
            ]
            
            let log_event = SplunkHEC_Utils().formatLogString(logEvent: event_data, format: self.string_format)
            
            session.add_event(date:date,event: log_event)
        }
        else {
            print(NSError(domain:"SplunkHec:Log Session not set or started.", code:31).localizedDescription)
            
            return
        }
        
    }
    
}
