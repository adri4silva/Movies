# Uncomment the next line to define a global platform for your project
platform :ios, '15.2'

def shared_pods 
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
end

target 'Movies' do
  use_frameworks!
  shared_pods
end

target 'Core' do
  use_frameworks!
  shared_pods
end

target 'Trending' do
  use_frameworks!
  shared_pods
  pod 'Kingfisher', '~> 7.0'
end