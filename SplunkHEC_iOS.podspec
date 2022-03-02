Pod::Spec.new do |spec|

  spec.name         = "SplunkHEC_iOS"
  spec.version      = "1.0.0"
  spec.summary      = "Implementation of Splunk HEC for iOS"

  spec.description  = <<-DESC
        Send messages directly to splunk from your iOS apps.           
	DESC

  spec.homepage     = "https://github.com/r0bgus/SplunkHEC_iOS"

  spec.license = { :type => "MIT", :file => "LICENSE"}

  spec.author    = "r0bgus"

  spec.ios.deployment_target = "9.0"
  spec.swift_version = "5.5"

  spec.source       = { :git => "https://github.com/r0bgus/SplunkHEC_iOS.git", :tag => "#{spec.version}" }

  spec.source_files  = "SplunkHEC/**/*.{h,m,swift}"

end
