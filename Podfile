platform :ios, '8.0'
use_frameworks!

target 'zhuanzhedian' do

pod 'AVOSCloud'               # 数据存储、短信、云引擎调用等基础服务模块
pod 'AVOSCloudIM'             # 实时通信模块
pod 'AVOSCloudCrashReporting' # 错误报告模块

pod 'Wilddog/Sync'

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end