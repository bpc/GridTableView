Pod::Spec.new do |s|
  s.name         = "GridTableView"
  s.version      = "0.0.7"
  s.summary      = "Minimal patched grid view from UITableView, for iOS5 compatibility."
  s.homepage     = "https://github.com/bpc/GridTableView"
  s.license      = '2-clause BSD'
  s.author       = { "Jeong YunWon" => "jeong+gridtableview@youknowone.org" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/bpc/GridTableView.git", :tag => "0.0.7" }
  s.source_files  = 'GridTableView'
  s.requires_arc = true
end
