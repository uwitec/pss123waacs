#!ruby -Ks
=begin
�K�� �t�@�C����ShiftJIS�ɂĕۊǂ��邱��
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

if v = verbs.find {|v| v.Name == "���(&P)" }
  v.doIt
  sleep(2) # �N�����x���ꍇ (excel �Ƃ�)�A�����҂��Ă����Ȃ��Ƃ��߁B
end
