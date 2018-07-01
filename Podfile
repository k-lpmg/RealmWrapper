# platform :ios, '9.0'

def shared_pods
  inhibit_all_warnings!
  use_frameworks!

  pod 'RealmSwift'
end

target 'RealmWrapper' do
    shared_pods

  target 'RealmWrapperExample' do
    inherit! :search_paths
    shared_pods
  end

  target 'RealmWrapperTests' do
    inherit! :search_paths
    shared_pods
  end

end