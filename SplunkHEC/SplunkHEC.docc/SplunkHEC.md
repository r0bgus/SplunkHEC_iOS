# Splunk HEC for iOS

Implementation of Splunk HEC for iOS

## Overview

Send messages directly to Splunk from your iOS apps via HEC

## Quick Start

Create a config object with your Splunk HEC token and Splunk server url. 

```swift
let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
                                splunk_URL: "https://http-inputs_mystack.splunkcloud.com"
                                )
```

Init the SplunkHEC object 

```swift
guard let splunkHEC:SplunkHEC = SplunkHEC(splunkHEC_Configs: splunkHEC_Configs) { 
  return
}
```

Start a HEC session 

```swift
splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session()
```

Grab the logging object

```swift
let splunkHEC_Log = splunkHEC_Session.Log
```

Send messages 

```swift
splunkHEC_Log.info(message: "Hello Splunk!")
```

Close the HEC session
```swift
splunkHEC.stop_session()
```

