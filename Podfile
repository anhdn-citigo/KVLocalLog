# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!

# Cocoapods binary
plugin 'cocoapods-binary'

# Keep source code for backing up
keep_source_code_for_prebuilt_frameworks!

# Enable bitcode
enable_bitcode_for_prebuilt_frameworks!

# Apply prebuilt for all pods
all_binary!

target 'KVLocalLog' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KVLocalLog
  pod 'RealmSwift', '~> 3.17.3', :modular_headers => true
  pod 'SwiftyUserDefaults', '~> 3.0.0'
  pod 'SwiftyJSON'
end
