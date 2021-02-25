Pod::Spec.new do |s|

#########
s.platform = :ios
s.ios.deployment_target = '9.0'
s.swift_version = "4.2"
#########
s.version = "0.1.8"
#########
s.name = "KVLocalLog"
s.summary = "KVLocalLog : simple log with realm"
s.requires_arc = true
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Anh Vu" => "hoanganh6491@gmail.com" }
s.homepage = "https://www.citigo.com.vn/"
s.source = { :git => "git@github.com:anhdn-citigo/KVLocalLog.git",
             :tag => "#{s.version}" }
#########
s.framework = "UIKit"
s.framework = "Foundation"
s.dependency 'RealmSwift', '~> 2.10.0'
s.dependency 'SwiftyUserDefaults', '~> 3.0.0'
s.dependency 'SwiftyJSON'
#########
s.source_files = "KVLocalLog/**/*.{swift}"

end
