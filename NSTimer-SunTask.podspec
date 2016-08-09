Pod::Spec.new do |s|
  s.name             = 'NSTimer-SunTask'
  s.version          = '0.1.0'
  s.summary          = '扩展NSTimer对定期任务的支持'
  s.description      = <<-DESC
  本分类用于扩展NSTimer对定期任务的支持
                       DESC
  s.homepage         = 'https://github.com/sunbohong/NSTimer-SunTask'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunbohong' => 'sunbohong@gmail.com' }
  s.source           = { :git => 'https://github.com/sunbohong/NSTimer-SunTask.git', :tag => s.version.to_s }
  s.ios.deployment_target = '2.0'
  s.source_files = 'NSTimer-SunTask/Classes/**/*'
  s.frameworks = 'Foundation'
end
