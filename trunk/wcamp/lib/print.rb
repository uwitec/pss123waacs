#!ruby -Ks
=begin
必ず ファイルをShiftJISにて保管すること
=end
require 'win32ole'

class WIN32OLE
  include Enumerable
end

parent, name = File.split(File.expand_path(ARGV.shift))
parent.gsub!("/", "\\")

shell = WIN32OLE.new('Shell.Application')
verbs = shell.NameSpace(parent).ParseName(name).Verbs
#puts verbs.map {|v| v.Name }

if v = verbs.find {|v| v.Name == "印刷(&P)" }
  v.doIt
  sleep(2) # 起動が遅い場合 (excel とか)、少し待ってあげないとだめ。
end
