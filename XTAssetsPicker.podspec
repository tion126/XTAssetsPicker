Pod::Spec.new do |s|

s.name         = "XTAssetsPicker"

s.version      = "1.0.3"

s.summary      = "XTAssetsPicker"

s.homepage     = "https://github.com/tion126/XTAssetsPicker"

s.license      = "MIT"

s.author       = { "tion126" => "tion126@126.com" }

s.platform     = :ios, "8.0"

s.source       = { :git => 'https://github.com/tion126/XTAssetsPicker.git', :tag => s.version.to_s }

s.requires_arc = true

s.source_files = "XTAssetsPicker/XTAssetsPicker/*.{swift}"

s.resources    = "XTAssetsPicker/XTAssetsPicker/*.{storyboard,xcassets}"

end