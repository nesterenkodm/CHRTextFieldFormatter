Pod::Spec.new do |s|

  s.name         = "CHRTextFieldFormatter"
  s.version      = "1.0.1"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/chebur/CHRTextFieldFormatter.git", :tag => "#{s.version}" }
  s.source_files = "CHRTextFieldFormatter"
  s.requires_arc = true
  s.summary      = "Provides UITextField formatting masks. Such as phone number and credit card number formatters."
  s.authors      = "chebur"
  s.license      = "MIT"
  s.homepage     = "https://github.com/chebur/CHRTextFieldFormatter"

end
